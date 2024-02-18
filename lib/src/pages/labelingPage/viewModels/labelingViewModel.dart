import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageGroupDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:bas_dataset_generator_engine/src/utility/platform_util.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:uuid/uuid.dart';
import 'package:window_manager/window_manager.dart';
import 'package:image/image.dart' as i;
import 'package:path/path.dart' as p;

class LabelingViewModel extends ViewModel {

  final deleteController = FlyoutController();
  final moreController = FlyoutController();
  ImageGroupModel? group;
  ObjectModel? curObject;
  List<ObjectModel>subObjects=[];
  final int groupId,objId;
  final String title,partUUID,prjUUID;
  int indexImage = 0, imgH = 0,imgW = 0;
  Size imgSize = const Size(0, 0);

  LabelingViewModel(this.objId,this.partUUID,this.prjUUID,this.groupId,this.title);

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
    subObjects=group!.subObjects;
    for(var grp in group!.allGroups){
      if(grp.allObjects.isNotEmpty){
        subObjects.addAll(grp.allObjects);
      }
    }

    curObject=group!.allObjects[0];
    for (final object in group!.allObjects) {
      if (object.id==objId) {
        indexImage= group!.allObjects.indexOf(object);
        break;
      }
    }
    updatePageData();
  }

  updatePageData()async{
    curObject=group!.allObjects[indexImage];
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
    if (indexImage == group!.allObjects.length) {
      return indexImage = 0;
    }
    updatePageData();
  }

  perviousImage() async{
    if (indexImage == 0) return;
    indexImage = --indexImage;
    updatePageData();
  }

  doScreenAction(String action) async {
    var actions = action.split('&&');
    switch (actions[0]) {
      case 'edit':
        // ScreenShootModel? screen =
        //     await ScreenDAO().getScreen(int.parse(actions[1]));
        // screen!.type = actions[2];
        // screen.description = actions[3];
        // screen.status = 'finished';
        // await ScreenDAO().updateScreen(screen);
        // await setScreenAsData();
        break;
      case 'delete':
        var obj = await ObjectDAO().getDetails(int.parse(action.split("&&")[1]));
        await ObjectDAO().deleteObject(obj!);
        await ImageGroupDAO().removeObject(groupId, obj);
        group=await ImageGroupDAO().getDetails(groupId);
        if(group!.allObjects.isNotEmpty){
          indexImage=indexImage==group!.allObjects.length?--indexImage:indexImage;
          updatePageData();
        }else{
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
        indexImage=group!.allObjects.indexWhere((element) => element.id==int.parse(action.split('&&')[1]));
        updatePageData();
        break;
      case 'goto':
        curObject = group!.allObjects[indexImage];
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

  onNewPartCreatedHandler(ObjectModel newObject) async {
    final path = await DirectoryManager().getObjectImagePath(prjUUID, partUUID);
    final cmd = i.Command()
      ..decodeImageFile(curObject!.image.target!.path!)
      ..copyCrop(
          x: getX(newObject.left.toInt()),
          y: getY(newObject.top.toInt()),
          width: (getX(newObject.right.toInt()) - getX(newObject.left.toInt()))
              .abs()
              .toInt(),
          height: (getY(newObject.bottom.toInt()) - getY(newObject.top.toInt())))
      ..writeToFile(path);
    await cmd.executeThread();
    var img = ImageModel(-1, const Uuid().v4(), newObject.uuid, p.basename(path), path);
    img.id =await ImageDAO().add(img);
    newObject.image.target = img;
    newObject.uuid=const Uuid().v4();
    newObject.parentUUID=curObject!.uuid;
    newObject.id=await ObjectDAO().addObject(newObject);
    await ImageGroupDAO().addSubObject(groupId, newObject);
    subObjects.add(newObject);
    notifyListeners();
  }
}