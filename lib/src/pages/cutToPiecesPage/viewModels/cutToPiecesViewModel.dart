import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageGroupDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/preferences/preferencesData.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/dlgGuide.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:bas_dataset_generator_engine/src/utility/platform_util.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:uuid/uuid.dart';
import 'package:window_manager/window_manager.dart';
import 'package:image/image.dart' as i;
import 'package:path/path.dart' as p;

class CutToPiecesViewModel extends ViewModel {

  final confirmController = FlyoutController();
  final moreController = FlyoutController();
  ImageGroupModel? group;
  ObjectModel? curObject;
  bool isShowAll=true;
  String pageDuty="cutting";
  List<ObjectModel>subObject=[];
  List<int>minimizedObjects=[];
  final int groupId;
  final String title,partUUID,prjUUID;
  int indexImage = 0, imgH = 0,imgW = 0;
  Size imgSize = const Size(0, 0);

  CutToPiecesViewModel(this.partUUID,this.prjUUID,this.groupId,this.title);

  @override
  void init() async{
    await windowManager.setPreventClose(true);
    windowManager.waitUntilReadyToShow().then((_) async {
      if (kIsLinux || kIsWindows) {
        if (kIsLinux) {
          await windowManager.setAsFrameless();
        } else {
          await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
        }
        await windowManager.setPosition(Offset.zero);
      }
      await windowManager.setSkipTaskbar(true);
      await windowManager.setFullScreen(true);
      await Future.delayed(const Duration(milliseconds: 100));
      await _windowShow();
    });
    group=await ImageGroupDAO().getDetails(groupId);
    subObject=group!.subObjects;

    if(group!.state==GroupState.findMainState.name){
      pageDuty="drawMainRectangle";
    }
    curObject=group!.allStates[0];
    updatePageData();
    if(pageDuty=="drawMainRectangle"&&await Preference().getShowGuide("firstGuide")){
      showGuideDialog(context, Strings.firstGuide, Strings.firstGuideTitle, 'firstGuide');
    }else if(pageDuty=="cutting"&&await Preference().getShowGuide("labelingGuide")){
      showGuideDialog(context, Strings.labelingGuide, Strings.labelingGuideTitle, 'labelingGuide');
    }
  }

  updatePageData()async{
    curObject=group!.allStates[indexImage];
    final img = await i.decodeImageFile(curObject!.image.target!.path!);
    imgH = img!.height;
    imgW = img.width;
    imgSize = Size(
        imgW > MediaQuery.of(context).size.width
            ? MediaQuery.of(context).size.width
            : imgW.toDouble(),
        imgH>(MediaQuery.of(context).size.height - Dimens.topBarHeight)?
        (MediaQuery.of(context).size.height - Dimens.topBarHeight):
        imgH.toDouble()
    );
    notifyListeners();
  }

  onBackClicked(){
    context.goNamed('mainPage');
  }

  Future<void> _windowShow() async {
    bool isAlwaysOnTop = await windowManager.isAlwaysOnTop();
    if (kIsLinux) {
      await windowManager.setPosition(Offset.zero);
    }

    bool isVisible = await windowManager.isVisible();
    if (!isVisible) {
      await windowManager.show();
    } else {
      await windowManager.focus();
    }

    if (kIsLinux && !isAlwaysOnTop) {
      await windowManager.setAlwaysOnTop(true);
      await Future.delayed(const Duration(milliseconds: 10));
      await windowManager.setAlwaysOnTop(false);
      await Future.delayed(const Duration(milliseconds: 10));
      await windowManager.focus();
    }
  }

  nextImage() async{
    indexImage = ++indexImage;
    if (indexImage == group!.allStates.length) {
      return indexImage = 0;
    }
    updatePageData();
  }

  perviousImage() async{
    if (indexImage == 0) return;
    indexImage = --indexImage;
    updatePageData();
  }

  onObjectActionHandler(String action) async {
    var actions = action.split('&&');
    switch (actions[0]) {
      case Strings.hideAll:
      case Strings.showAll:
        isShowAll=!isShowAll;
        notifyListeners();
        break;
      case "confirm":
        var grp = await ImageGroupDAO().getDetails(groupId);
        grp!.state=GroupState.finishCutting.name;
        await ImageGroupDAO().update(grp);
        onBackClicked();
        break;
      case 'next':
        indexImage=group!.allStates.indexWhere((element) => element.id==int.parse(action.split('&&')[1]));
        updatePageData();
        break;
      case 'goto':
        curObject = group!.allStates[indexImage];
        indexImage = 0;
        notifyListeners();
        break;
    }
  }

  int getY(int y) {
    final curHeight = MediaQuery.of(context).size.height - (Dimens.topBarHeight);
    if (imgH > curHeight) {
      return (y * imgH) ~/ curHeight;
    } else {
      return y;
    }
  }

  int getX(int x) {
    if (imgW > MediaQuery.of(context).size.width) {
      return (x * imgW) ~/ MediaQuery.of(context).size.width;
    } else {
      return x;
    }
  }

  onPartObjectHandler(String action){
    var act=action.split("&&");
    if(act[0]=="minimize"){
      minimizedObjects.add(int.parse(act[1]));
    }else{
      minimizedObjects.removeWhere((element) => element==int.parse(act[1]));
    }
    notifyListeners();
  }
  //todo crop image part is here
  onNewPartCreatedHandler(ObjectModel newObject) async {
    newObject.uuid=const Uuid().v4();
    newObject.srcObject.target=curObject!;
    newObject.left=getX(newObject.left.toInt()).toDouble();
    newObject.right=getX(newObject.right.toInt()).toDouble();
    newObject.top=getY(newObject.top.toInt()).toDouble();
    newObject.bottom=getY(newObject.bottom.toInt()).toDouble();

    final path = await DirectoryManager().getObjectImagePath(prjUUID, partUUID);
    final cmd = i.Command()
      ..decodeImageFile(curObject!.image.target!.path!)
      ..copyCrop(
          x: newObject.left.toInt(),
          y: newObject.top.toInt(),
          width: (newObject.right.toInt() - newObject.left.toInt()).abs().toInt(),
          height: (newObject.bottom.toInt() - newObject.top.toInt()))
      ..writeToFile(path);
    await cmd.executeThread();
    var img = ImageModel(-1, const Uuid().v4(), newObject.uuid, p.basename(path), path);
    img.id =await ImageDAO().add(img);
    newObject.image.target=img;

    if(pageDuty=="cutting"){
      newObject.id=await ObjectDAO().addObject(newObject);
      await ImageGroupDAO().addSubObject(groupId, newObject);
      group=await ImageGroupDAO().getDetails(groupId);
      subObject=group!.subObjects;
      notifyListeners();
    }else if(pageDuty=="drawMainRectangle"){
      newObject.isMainObject=true;
      newObject.id=await ObjectDAO().addObject(newObject);
      await ImageGroupDAO().addMainState(groupId, newObject);
      onBackClicked();
    }
  }
}