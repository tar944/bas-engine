import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageGroupDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/labelDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:bas_dataset_generator_engine/src/utility/platform_util.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:uuid/uuid.dart';
import 'package:window_manager/window_manager.dart';
import 'package:image/image.dart' as i;

class CutToPiecesViewModel extends ViewModel {

  final deleteController = FlyoutController();
  final moreController = FlyoutController();
  ImageGroupModel? group;
  ObjectModel? curObject;
  bool isShowAll=true;
  List<ObjectModel>otherStates=[];
  final int groupId,objId;
  final String title,partUUID,prjUUID;
  int indexImage = 0, imgH = 0,imgW = 0;
  Size imgSize = const Size(0, 0);

  CutToPiecesViewModel(this.objId,this.partUUID,this.prjUUID,this.groupId,this.title);

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
    otherStates=group!.otherStates;
    for(var grp in group!.allGroups){
      if(grp.subObjects.isNotEmpty){
        otherStates.addAll(grp.subObjects);
      }
    }

    curObject=group!.otherStates[0];
    for (final object in group!.otherStates) {
      if (object.id==objId) {
        indexImage= group!.otherStates.indexOf(object);
        break;
      }
    }

    if (await LabelDAO().needAddDefaultValue(prjUUID)) {
      await LabelDAO().addList(prjUUID,ObjectType.values
          .map((e) => LabelModel(0, e.name,"objects"))
          .toList());
    }
    updatePageData();
  }

  updatePageData()async{
    curObject=group!.otherStates[indexImage];
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
    if (indexImage == group!.otherStates.length) {
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
      case 'delete':
        await ObjectDAO().deleteObject(curObject!);
        await ImageGroupDAO().removeObject(groupId, curObject!);
        group = await ImageGroupDAO().getDetails(groupId);
        if (group!.otherStates.isNotEmpty) {
          indexImage = indexImage == group!.otherStates.length
              ? --indexImage
              : indexImage;
          updatePageData();
        } else {
          onBackClicked();
        }
        break;
      case 'show':
        // ScreenShootModel? screen =
        //     await ScreenDAO().getScreen(int.parse(actions[1]));
        // for (final item in listData.value) {
        //   if (item.getId() == screen!.id) {
        //     indexImage.value = listData.value.indexOf(item);
        //     break;
        //   }
        // }
        break;
      case 'next':
        indexImage=group!.otherStates.indexWhere((element) => element.id==int.parse(action.split('&&')[1]));
        updatePageData();
        break;
      case 'goto':
        curObject = group!.otherStates[indexImage];
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
  //todo crop image part is here
  onNewPartCreatedHandler(ObjectModel newObject) async {
    newObject.uuid=const Uuid().v4();
    newObject.parentUUID=curObject!.uuid;
    newObject.validObjects.add(curObject!);
    newObject.id=await ObjectDAO().addObject(newObject);
    await ImageGroupDAO().addSubObject(groupId, newObject);
    otherStates.add(newObject);
    notifyListeners();
  }
}