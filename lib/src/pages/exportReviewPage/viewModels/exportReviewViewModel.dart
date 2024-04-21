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
import 'package:image/image.dart' as i;

class ExportReviewViewModel extends ViewModel {

  final confirmController = FlyoutController();
  final moreController = FlyoutController();
  List<PascalVOCModel>mainStates=[];
  List<ImageGroupModel>mainGroups=[];
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
      await windowManager.setSkipTaskbar(true);
      await windowManager.setFullScreen(true);
      await Future.delayed(const Duration(milliseconds: 100));
      await _windowShow();
    });
    var curProject = await ProjectDAO().getDetailsByUUID(prjUUID);

    for(var part in curProject!.allParts){
      for (var grp in part.allGroups){
        if(grp.label.target!=null){
          mainGroups.add(grp);
          for(var obj in grp.allStates){
            mainStates.add(
                PascalVOCModel(
                    obj.uuid,
                    obj.image.target!.name,
                    obj.image.target!.path,
                    obj.image.target!.width.toInt(),
                    obj.image.target!.height.toInt()));
            print("======================================================");
            print("${grp.label.target!.levelName}&&${grp.label.target!.name}${grp.name!=""?"&&${grp.name}":""}");
            mainStates[mainStates.length-1].objects.addAll(
                findSubObjects(
                    obj,
                    grp.allGroups,
                    "${grp.label.target!.levelName}&&${grp.label.target!.name}${grp.name!=""?"&&${grp.name}":""}",0,0));
          }
        }
      }
    }
  }

  List<PascalObjectModel> findSubObjects(ObjectModel mainObject,List<ImageGroupModel>allGroups,String preName,double startX,double startY){
    List<PascalObjectModel> allObjects=[];
    for(var grp in allGroups){
      if(grp.label.target!=null){
        for(var state in grp.allStates){
          if(state.srcObject.target!.uuid==mainObject.uuid){
            var name ="$preName&&${grp.label.target!.name}${grp.name!=""?"&&${grp.name}":""}";
            allObjects.add(PascalObjectModel(
              name,
              (state.left+startX).toInt(),
              (state.right+startX).toInt(),
              (state.top+startY).toInt(),
              (state.bottom+startY).toInt()
            ));
            print(name);
            if(grp.label.target!.levelName!="objects"){
              allObjects.addAll(findSubObjects(state, grp.allGroups, name, state.left+startX, state.top+startY));
            }
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
    // if (indexImage == group!.allStates.length) {
    //   return indexImage = 0;
    // }
  }

  perviousImage() async{
    if (indexImage == 0) return;
    indexImage = --indexImage;
  }

  onObjectActionHandler(String action) async {
    var actions = action.split('&&');

  }
}