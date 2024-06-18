import 'dart:io';

import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalVOCModel.dart';
import 'package:bas_dataset_generator_engine/src/data/preferences/preferencesData.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/toast.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/views/dlgObjProperties.dart';
import 'package:bas_dataset_generator_engine/src/pages/mainPage/views/dlgExport.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:bas_dataset_generator_engine/src/utility/formatManager.dart';
import 'package:bas_dataset_generator_engine/src/utility/platform_util.dart';
import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:window_manager/window_manager.dart';
import 'package:path/path.dart' as path;

class ExportReviewViewModel extends ViewModel {

  final confirmController = FlyoutController();
  final moreController = FlyoutController();
  List<PascalVOCModel>mainStates=[];
  final String prjUUID;
  int indexImage = 0,processedNumber=-1,percent=0;
  int imgW=0, imgH=0;
  Size imgSize = const Size(0, 0);
  String guidePos="bottomLeft",exportAction="";

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

    await DirectoryManager().saveFileInLocal(
        path.join(
            await DirectoryManager().createPrjDir(prjUUID),
            'db_${DateTime.now().millisecondsSinceEpoch.toString()}.json'),
        await FormatManager().getProjectData(curProject!));

    var mainGroups =<ImageGroupModel>[];
    var mainObjects =<String>[];

    for(var part in curProject!.allParts){
      var dir = Directory(await DirectoryManager().getPartImageDirectoryPath(prjUUID, part.uuid));
      List contents = dir.listSync();

      for (var fileOrDir in contents) {
        var img = await ImageDAO().getDetailsByPath(fileOrDir.path);
        if(img != null){
          mainObjects.add(img.objUUID);
        }
      }
      if(part.allGroups.isNotEmpty){
        mainGroups.addAll(part.allGroups);
      }
      for(var grp in part.allGroups){
        if(grp.otherShapes.isNotEmpty){
          mainGroups.addAll(grp.otherShapes);
        }
      }
    }

    for (var grp in mainGroups){
      if(grp.label.target!=null&&grp.mainState.target!=null){
        for(var obj in grp.allStates){
          ObjectModel? curObject;
          do{
            curObject= curObject==null?obj.srcObject.target:curObject.srcObject.target;
          }while(mainObjects.contains(curObject!.uuid)==false);

          mainStates.add(
              PascalVOCModel(
                  curObject.uuid,
                  curObject.image.target!.name,
                  curObject.image.target!.path,
                  curObject.image.target!.width.toInt(),
                  curObject.image.target!.height.toInt()));

          var name = "${grp.label.target!.levelName}**${grp.label.target!.name}${grp.name!=""?"**${grp.name}":""}";
          if(obj.isMainObject){
            if(obj.exportName==""){
              obj.exportName=grp.label.target!.levelName=="objects"?grp.label.target!.name:name;
              await ObjectDAO().update(obj);
            }
            mainStates[mainStates.length - 1].objects.add(PascalObjectModel(
                obj.uuid,
                grp.uuid,
                grp.label.target!.levelName,
                obj.exportState,
                obj.exportName,
                name,
                obj.left.toInt() + obj.srcObject.target!.left.toInt(),
                obj.right.toInt() + obj.srcObject.target!.left.toInt(),
                obj.top.toInt() + obj.srcObject.target!.top.toInt(),
                obj.bottom.toInt() + obj.srcObject.target!.top.toInt()));
          }
          mainStates[mainStates.length-1].objects.addAll(
              await findSubObjects(
                  obj,
                  grp.allGroups,
                  name,
                  obj.srcObject.target!.left,
                  obj.srcObject.target!.top));
        }
      }
    }
  }

  Future<List<PascalObjectModel>> findSubObjects(ObjectModel mainObject,List<ImageGroupModel>allGroups,String preName,double startX,double startY)async{
    List<PascalObjectModel> allObjects=[];
    for(var grp in allGroups){
      if(grp.label.target!=null){
        var name ="$preName**${grp.label.target!.name}${grp.name!=""?"**${grp.name}":""}";
        for(var state in grp.allStates){
          if(state.srcObject.target!.uuid==mainObject.uuid||state.srcObject.target!.srcObject.target!.uuid==mainObject.uuid){
            var left = state.srcObject.target!.uuid==mainObject.uuid?state.left:state.srcObject.target!.left;
            var top = state.srcObject.target!.uuid==mainObject.uuid?state.top:state.srcObject.target!.top;
            var right = state.srcObject.target!.uuid==mainObject.uuid?state.right:state.srcObject.target!.right;
            var bottom = state.srcObject.target!.uuid==mainObject.uuid?state.bottom:state.srcObject.target!.bottom;
            if(state.exportName==""){
              state.exportName=grp.label.target!.levelName=="objects"?grp.label.target!.name:name;
              await ObjectDAO().update(state);
            }
            allObjects.add(PascalObjectModel(
              state.uuid,
              grp.uuid,
              grp.label.target!.levelName,
              state.exportState,
              state.exportName,
              name,
              (left+startX).toInt(),
              (right+startX).toInt(),
              (top+startY).toInt(),
              (bottom+startY).toInt()
            ));
            if(grp.label.target!.levelName!="objects"&&grp.mainState.target!=null){
              allObjects.addAll(await findSubObjects(state, grp.allGroups, name,left+startX, top+startY));
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
    notifyListeners();
  }

  perviousImage() async{
    indexImage = --indexImage;
    notifyListeners();
  }

  onExportBtnHandler()async{
    var curProject = await ProjectDAO().getDetailsByUUID(prjUUID);
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => DlgExport(
                                prjUUID:prjUUID,
                                prjName: curProject!.title!,
                                onExportCaller:exportHandler,));
  }

  exportHandler(String action)async{
    processedNumber=1;
    exportAction=action;
    notifyListeners();
    var path = await FormatManager().generateFile(prjUUID,action, mainStates,onItemProcessedHandler);
    if(action=="saveInServer"){
      var file=File(path);
      if(file.existsSync())
      {
        await uploadFile(file);
      }
    }
  }

  Future<String> uploadFile(File file) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "dataSet":
      await MultipartFile.fromFile(file.path, filename:fileName),
    });
    String token= await Preference().shouldAuth(prjUUID)?await Preference().getAuthToken(prjUUID):"";
    Dio dio = Dio();
    var response = await dio.post(
                                    await Preference().getUploadLink(prjUUID),
                                    data: formData,
                                    options:Options(
                                      headers: {
                                        "Content-Type": "application/json",
                                        "Authorization": token==""?"":"Bearer $token",
                                      }
                                    )
                                  );
    print(response);
    processedNumber=-1;
    notifyListeners();
    return response.data['status'];
  }

  onItemProcessedHandler(int count){
    processedNumber=count;
    if(count!=-1){
      percent=count*100~/mainStates.length;
    }else{
      processedNumber=-2;
    }
    notifyListeners();
  }

  onObjectActionHandler(String action) async {
    var act = action.split('&&');
    indexImage=mainStates.indexWhere((element) => element.objUUID==act[1]);
    notifyListeners();
  }

  onRegionActionHandler(String action)async{
    var act = action.split("&&");
    switch(act[0]){
      case "click":
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) =>
              DlgObjProperties(
                  object: mainStates[indexImage].objects.firstWhere((element) => element.objUUID==act[1]),
                  onActionCaller: onObjPropertiesHandler),
        );
        break;
      case "rightClick":
        await ObjectDAO().updateExportState(act[1], act[2]);
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
      mainStates[indexImage].objects.removeWhere((element) => element.objUUID==act[1]);
      notifyListeners();
    }else if(act[0]=="confirm"){
      var obj= await ObjectDAO().getDetailsByUUID(act[1]);
      obj!.exportName=act[2];
      await ObjectDAO().update(obj);
      mainStates[indexImage].objects[mainStates[indexImage].objects.indexWhere((element) => element.objUUID==act[1])].exportName=act[2];
      notifyListeners();
    }
  }

  onMouseEnter(){
    if(guidePos=="bottomLeft"){
      guidePos="topLeft";
    }else if(guidePos=="topLeft"){
      guidePos="topRight";
    }else if(guidePos=="topRight"){
      guidePos="bottomRight";
    }else{
      guidePos="bottomLeft";
    }
    notifyListeners();
  }

  double getGuidePos(int dir){
    //[L,T,R,B]
    switch (guidePos){
      case "bottomRight":
        return [-1.0,-1.0,20.0,20.0][dir];
      case "bottomLeft":
        return [20.0,-1.0,-1.0,20.0][dir];
      case "topRight":
        return [-1.0,20.0,20.0,-1.0][dir];
      case "topLeft":
        return [20.0,20.0,-1.0,-1.0][dir];
      default:
        return [20.0,-1.0,-1.0,20.0][dir];
    }
  }
}