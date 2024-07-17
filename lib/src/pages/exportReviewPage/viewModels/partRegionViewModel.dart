import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/toast.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/views/dlgObjProperties.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:image/image.dart' as i;


class PartRegionViewModel extends ViewModel {
  List<PascalObjectModel> allObjects;
  ObjectModel mainObject;
  final bool isSelectionMode,isKeyActive;
  int imgW=0,imgH=0;
  final ValueSetter<String> onActionCaller;
  final String imgPath;
  String activeObjUUID='';


  PartRegionViewModel(
      this.allObjects,
      this.imgPath,
      this.isSelectionMode,
      this.isKeyActive,
      this.onActionCaller,
      this.mainObject);


  @override
  void init() async{
    final img = await i.decodeImageFile(imgPath);
    imgH = img!.height;
    imgW = img.width;
    if(!isSelectionMode&&isKeyActive){
      findNextActiveObject();
    }
    notifyListeners();
  }

  findNextActiveObject(){
    activeObjUUID=Strings.notSet;
    for(var obj in allObjects){
      if(obj.dirKind==''){
        activeObjUUID=obj.objUUID!;
        break;
      }
    }
    if(activeObjUUID==Strings.notSet){
      Toast(Strings.jobDone,false).showSuccess(context);
      if(isKeyActive){
        onActionCaller('return&&');
      }
    }
    notifyListeners();
  }

  onObjectHandler(String action)async{
    var acts= action.split('&&');
    switch(acts[1]){
      case 'train':
        if(acts[2]=="true"){
          mainObject.trainObjects.removeWhere((element) => element.uuid==acts[0]);
        }else{
          var obj = await ObjectDAO().getDetailsByUUID(acts[0]);
          mainObject.trainObjects.add(obj!);
        }
        await ObjectDAO().update(mainObject);
        findNextActiveObject();
        break;
      case 'valid':
        if(acts[2]=="true"){
          mainObject.validObjects.removeWhere((element) => element.uuid==acts[0]);
        }else{
          var obj = await ObjectDAO().getDetailsByUUID(acts[0]);
          mainObject.validObjects.add(obj!);
        }
        await ObjectDAO().update(mainObject);
        findNextActiveObject();
        break;
      case 'test':
        if(acts[2]=="true"){
          mainObject.testObjects.removeWhere((element) => element.uuid==acts[0]);
        }else{
          var obj = await ObjectDAO().getDetailsByUUID(acts[0]);
          mainObject.testObjects.add(obj!);
        }
        await ObjectDAO().update(mainObject);
        findNextActiveObject();
        break;
      case 'none':
        mainObject.labelObjects.removeWhere((element) => element.uuid==acts[0]);
        await ObjectDAO().update(mainObject);
        notifyListeners();
        break;
      case 'active':
        var obj = await ObjectDAO().getDetailsByUUID(acts[0]);
        if(!obj!.isGlobalObject){
          mainObject.labelObjects.add(obj);
          await ObjectDAO().update(mainObject);
          notifyListeners();
        }
        break;
      case 'banned':
        var obj = await ObjectDAO().getDetailsByUUID(acts[0]);
        if(!obj!.isGlobalObject){
          mainObject.banObjects.add(obj);
          allObjects.removeWhere((element) => element.objUUID==acts[0]);
          await ObjectDAO().update(mainObject);
          notifyListeners();
        }
        break;
      case 'unBanned':
        mainObject.banObjects.removeWhere((element) => element.uuid==acts[0]);
        await ObjectDAO().update(mainObject);
        allObjects.removeWhere((element) => element.objUUID==acts[0]);
        notifyListeners();
        break;
      case 'setGlobal':
        await ObjectDAO().setGlobalObject(acts[0]);
        notifyListeners();
        break;
      case 'showProperties':
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) =>
              DlgObjProperties(
                needMore: true,
                  object: allObjects.firstWhere((element) => element.objUUID==acts[0]),
                  onActionCaller:(e)=> onObjPropertiesHandler(e)),
        );
        break;
      case 'escape':
        onActionCaller('escape&&');
        break;
    }
  }

  onObjPropertiesHandler(String action)async{
    var act = action.split("&&");
    if(act[0]=="delete"){
      if(act[2]!="objects"){
        Toast(Strings.errorDelete, false).showError(context);
        return;
      }
      var obj= await ObjectDAO().getDetailsByUUID(act[1]);
      await ObjectDAO().deleteObject(obj!);
      allObjects.removeWhere((element) => element.objUUID==act[1]);
      notifyListeners();
    }else if(act[0]=="confirm"){
      var obj= await ObjectDAO().getDetailsByUUID(act[1]);
      obj!.exportName=act[2];
      await ObjectDAO().update(obj);
      allObjects[allObjects.indexWhere((element) => element.objUUID==act[1])].exportName=act[2];
      notifyListeners();
    }
  }

  int getY(int y) {
    var curH = MediaQuery.of(context).size.height - Dimens.topBarHeight;
    if (imgH > curH) {
      return (y * curH) ~/ imgH;
    } else {
      return y;
    }
  }

  int getX(int x) {
    var curW=MediaQuery.of(context).size.width;
    if (imgW > curW) {
      return (x * curW) ~/ imgW;
    } else {
      return x;
    }
  }
}
