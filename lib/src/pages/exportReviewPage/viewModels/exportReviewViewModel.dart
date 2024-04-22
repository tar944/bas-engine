import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalVOCModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/platform_util.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:window_manager/window_manager.dart';

class ExportReviewViewModel extends ViewModel {

  final confirmController = FlyoutController();
  final moreController = FlyoutController();
  List<PascalVOCModel>mainStates=[];
  final String prjUUID;
  int indexImage = 0;
  int imgW=0, imgH=0;
  Size imgSize = const Size(0, 0);

  ExportReviewViewModel(this.prjUUID);

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
      await windowManager.setSkipTaskbar(false);
      await windowManager.setFullScreen(true);
      await Future.delayed(const Duration(milliseconds: 100));
      await _windowShow();
    });
  }


  @override
  void onMount() async{
    var curProject = await ProjectDAO().getDetailsByUUID(prjUUID);

    for(var part in curProject!.allParts){
      for (var grp in part.allGroups){
        if(grp.label.target!=null&&grp.mainState.target!=null){
          for(var obj in grp.allStates){
            var curObject = obj.srcObject.target!=null?obj.srcObject.target!:obj;
            mainStates.add(
                PascalVOCModel(
                    curObject.uuid,
                    curObject.image.target!.name,
                    curObject.image.target!.path,
                    curObject.image.target!.width.toInt(),
                    curObject.image.target!.height.toInt()));
            print("======================================================");
            var name = "${grp.label.target!.levelName}&&${grp.label.target!.name}${grp.name!=""?"&&${grp.name}":""}";
            if(obj.isMainObject){
              mainStates[mainStates.length-1].objects.add(PascalObjectModel(obj.uuid,obj.exportState,name, obj.left.toInt(), obj.right.toInt(), obj.top.toInt(), obj.bottom.toInt()));
            }
            mainStates[mainStates.length-1].objects.addAll(
                findSubObjects(
                    obj,
                    grp.allGroups,
                    name,
                    grp.mainState.target!.left,
                    grp.mainState.target!.top));
          }
        }
      }
    }
    print(mainStates.length);
  }

  List<PascalObjectModel> findSubObjects(ObjectModel mainObject,List<ImageGroupModel>allGroups,String preName,double startX,double startY){
    List<PascalObjectModel> allObjects=[];
    for(var grp in allGroups){
      if(grp.label.target!=null){
        for(var state in grp.allStates){
          var name ="$preName&&${grp.label.target!.name}${grp.name!=""?"&&${grp.name}":""}";
          if(state.srcObject.target!.uuid==mainObject.uuid){
            allObjects.add(PascalObjectModel(
              state.uuid,
              state.exportState,
              name,
              (state.left+startX).toInt(),
              (state.right+startX).toInt(),
              (state.top+startY).toInt(),
              (state.bottom+startY).toInt()
            ));
          }

          if(grp.label.target!.levelName!="objects"&&grp.mainState.target!=null){
            allObjects.addAll(findSubObjects(state, grp.allGroups, name, grp.mainState.target!.left+startX, grp.mainState.target!.top+startY));
          }
        }
      }
    }
    return allObjects;
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
    notifyListeners();
    print("------------------------------------");
    print(mainStates[indexImage].filename);
  }

  perviousImage() async{
    indexImage = --indexImage;
    notifyListeners();
    print("------------------------------------");
    print(mainStates[indexImage].filename);
  }

  onObjectActionHandler(String action) async {
    var act = action.split('&&');
    indexImage=mainStates.indexWhere((element) => element.objUUID==act[1]);
    notifyListeners();
  }
}