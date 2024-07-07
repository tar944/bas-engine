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
import 'package:bas_dataset_generator_engine/src/pages/mainPage/views/dlgExport.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:bas_dataset_generator_engine/src/utility/platform_util.dart';
import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_event/keyboard_event.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:window_manager/window_manager.dart';
import 'package:keyboard_event/keyboard_event.dart' as key;

class ExportReviewViewModel extends ViewModel {

  final confirmController = FlyoutController();
  final moreController = FlyoutController();
  final groupController = FlyoutController();
  List<PascalVOCModel>allStates=[];
  List<PascalVOCModel>curStates=[];
  List<ImageGroupModel>mainGroups=[];
  List<PascalObjectModel>curObjects=[];
  ObjectModel? mainObject;
  final String prjUUID;
  bool isBinState=false,isListUp=false,isSelection=true;
  int indexImage = 0,processedNumber=-1,percent=0;
  int imgW=0, imgH=0,groupIndex=0;
  Size imgSize = const Size(0, 0);
  String exportAction="",banStatesUUID="";
  late key.KeyboardEvent keyboardEvent;

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
    keyboardEvent = key.KeyboardEvent();
    keyboardEvent.startListening((keyEvent) => onKeyboardEventHandler(keyEvent));
    await KeyboardEvent.init();
  }


  onKeyboardEventHandler(key.KeyEvent event)async{
    if(event.isKeyUP&&event.vkName=='LCONTROL'){
      changeListPosition();
    }
  }

  @override
  void onMount() async{
    await Future.delayed(const Duration(milliseconds: 500));

    var curProject = await ProjectDAO().getDetailsByUUID(prjUUID);
    // await DirectoryManager().saveFileInLocal(
    //     path.join(
    //         await DirectoryManager().createPrjDir(prjUUID),
    //         'db_${DateTime.now().millisecondsSinceEpoch.toString()}.json'),
    //     await FormatManager().getProjectData(curProject!));

    var mainObjects =<String>[];
    var groups =<ImageGroupModel>[];

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
        groups.addAll(part.allGroups);
      }
      for(var grp in part.allGroups){
        if(grp.otherShapes.isNotEmpty){
          groups.addAll(grp.otherShapes);
        }
      }
    }

    for (var grp in groups){
      if(grp.label.target!=null&&grp.mainState.target!=null){
        var allObjects=<PascalObjectModel>[];
        for(var obj in grp.allStates){
          ObjectModel? curObject;
          double left=obj.left,top=obj.top;
          do{
            curObject= curObject==null?obj.srcObject.target:curObject.srcObject.target;
            left+=curObject!.left;
            top+=curObject.top;
          }while(mainObjects.contains(curObject.uuid)==false);
          var name = "${grp.label.target!.levelName}**${grp.label.target!.name}${grp.name!=""?"**${grp.name}":""}";
          if(obj.isMainObject){
            if(obj.exportName==""){
              obj.exportName=grp.label.target!.levelName=="objects"?grp.label.target!.name:name;
              await ObjectDAO().update(obj);
            }
            var subObject=PascalObjectModel(
                obj.uuid,
                grp.uuid,
                grp.label.target!.levelName,
                obj.exportName,
                name,
                obj.left.toInt(),
                obj.right.toInt() ,
                obj.top.toInt() ,
                obj.bottom.toInt());
            subObject.stateUUID=curObject.uuid;
            allObjects.add(subObject);
          }
          var subArrays=await findSubObjects(obj, grp.allGroups, name, left, top);
          for(int i=0;i<subArrays.length;i++){
            subArrays[i].stateUUID=curObject.uuid;
          }
          allObjects.addAll(subArrays);
        }
        for(var obj in grp.allStates ){
          ObjectModel? curObject;
          do{
            curObject= curObject==null?obj.srcObject.target:curObject.srcObject.target;
          }while(mainObjects.contains(curObject!.uuid)==false);
          allStates.add(
              PascalVOCModel(
                  curObject.uuid,
                  grp.uuid,
                  curObject.image.target!.name,
                  curObject.image.target!.path,
                  curObject.image.target!.width.toInt(),
                  curObject.image.target!.height.toInt()));

          allStates[allStates.length-1].objects.addAll(allObjects);
        }
        if(grp.allStates.isNotEmpty){
          mainGroups.add(grp);
        }
      }
    }
    notifyListeners();
    updateObjects();
    setDefaultBanStates();
  }

  updateObjects()async{
    curStates=allStates.where((element) => element.grpUUID==mainGroups[groupIndex].uuid).toList();
    mainObject= await ObjectDAO().getDetailsByUUID(curStates[indexImage].objUUID!);
    curObjects=[];
    if(isSelection){
      if(isBinState){
        for(var obj in curStates[indexImage].objects) {
          if(mainObject!.banObjects.firstWhere((element) => element.uuid==obj.objUUID,orElse: ()=>ObjectModel(-1, '', 0, 0, 0, 0)).id!=-1){
            if(banStatesUUID.contains('${obj.stateUUID}&&')==false){
              curObjects.add(obj);
            }
          }
        }
      }else{
        for(var obj in curStates[indexImage].objects) {
          if(mainObject!.banObjects.firstWhere((element) => element.uuid==obj.objUUID,orElse: ()=>ObjectModel(-1, '', 0, 0, 0, 0)).id==-1){
            if(banStatesUUID.contains('${obj.stateUUID}&&')==false||
                mainObject!.labelObjects.firstWhere((element) => element.uuid==obj.objUUID,orElse: ()=>ObjectModel(-1, '', 0, 0, 0, 0)).id!=-1){
              curObjects.add(obj);
            }else{
              var objDetails=await ObjectDAO().getDetailsByUUID(obj.objUUID!);
              if(objDetails!.isGlobalObject){
                curObjects.add(obj);
              }
            }
          }
        }
      }
    }else{
      var validObjects=<PascalObjectModel>[];
      for(var obj in curStates[indexImage].objects) {
        var isSelected=mainObject!.labelObjects.firstWhere((element) => element.uuid==obj.objUUID,orElse: ()=>ObjectModel(-1, '', 0, 0, 0, 0)).id!=-1;
        if(!isSelected){
          var objDetails=await ObjectDAO().getDetailsByUUID(obj.objUUID!);
          if(objDetails!.isGlobalObject){
            isSelected=true;
          }
        }
        if(isSelected){
          var dirKind='';
          if(mainObject!.trainObjects.firstWhere((element) => element.uuid==obj.objUUID,orElse: ()=>ObjectModel(-1, '', 0, 0, 0, 0)).id!=-1){
            dirKind='train&&';
          }
          if(mainObject!.validObjects.firstWhere((element) => element.uuid==obj.objUUID,orElse: ()=>ObjectModel(-1, '', 0, 0, 0, 0)).id!=-1){
            dirKind='${dirKind}valid&&';
          }
          if(mainObject!.testObjects.firstWhere((element) => element.uuid==obj.objUUID,orElse: ()=>ObjectModel(-1, '', 0, 0, 0, 0)).id!=-1){
            dirKind='${dirKind}test&&';
          }
          validObjects.add(obj);
        }
      }
      if(isBinState){
        for(var obj in validObjects){
          if(obj.dirKind==''){
            curObjects.add(obj);
          }
        }
      }else{
        curObjects=validObjects;
      }
    }

    print(curStates[indexImage].path!);
    notifyListeners();
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

  changeListPosition(){
    isListUp=!isListUp;
    notifyListeners();
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
    updateObjects();
  }

  perviousImage() async{
    indexImage = --indexImage;
    notifyListeners();
    updateObjects();
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
    var exportStates=<PascalVOCModel>[];
    for(var state in allStates.sublist(0,6)){
      var objects =<PascalObjectModel>[];
      var mainObj= await ObjectDAO().getDetailsByUUID(state.objUUID!);
      for(var obj in state.objects){
        if(mainObj!.labelObjects.firstWhere((element) => element.uuid==obj.objUUID,orElse: ()=>ObjectModel(-1, '', 0, 0, 0, 0)).id!=-1){
          objects.add(obj);
        }else{
          var curObj=await ObjectDAO().getDetailsByUUID(obj.objUUID!);
          if(curObj!.isGlobalObject){
            objects.add(obj);
          }
        }
      }
      if(objects.isNotEmpty){
        print(objects.length);
        state.objects=objects;
        exportStates.add(state);
      }
    }

    // var path = await FormatManager().generateFile(prjUUID,action, exportStates,onItemProcessedHandler);
    // if(action=="saveInServer"){
    //   var file=File(path);
    //   if(file.existsSync())
    //   {
    //     print('finished');
    //     //todo two line should remove------------------------
    //     processedNumber=-1;
    //     notifyListeners();
    //     //todo uncomment--------------------
    //     // await uploadFile(file);
    //   }
    // }
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
    processedNumber=-1;
    notifyListeners();
    return response.data['status'];
  }

  onItemProcessedHandler(int count){
    processedNumber=count;
    if(count!=-1){
      percent=count*100~/allStates.length;
    }else{
      processedNumber=-2;
    }
    notifyListeners();
  }

  onChangeState(){
    isBinState=!isBinState;
    notifyListeners();
    updateObjects();
  }

  onObjectActionHandler(String action) async {
    var act = action.split('&&');
    if(act[0]=='selected'){
      indexImage=curStates.indexWhere((element) => element.objUUID==act[1]);
      banStatesUUID=banStatesUUID.replaceAll('${act[1]}&&', '');
      updateObjects();
    }else{
      if(banStatesUUID.contains('${act[1]}&&')){
        banStatesUUID=banStatesUUID.replaceAll('${act[1]}&&', '');
      }else{
        banStatesUUID='$banStatesUUID${act[1]}&&';
      }
      updateObjects();
    }
  }

  nextGroup(){
    if((groupIndex+1)<mainGroups.length){
      groupIndex++;
      indexImage=0;
      notifyListeners();
      updateObjects();
      setDefaultBanStates();
    }
  }

  perviousGroup(){
    if(groupIndex!=0){
      groupIndex--;
      indexImage=0;
      notifyListeners();
      updateObjects();
      setDefaultBanStates();
    }
  }

  setDefaultBanStates(){
    banStatesUUID='';
    for(var i=1;i<curStates.length;i++){
      banStatesUUID+='${curStates[i].objUUID}&&';
    }
    notifyListeners();
  }

  String getGroupName(){
    String name="";
    if(mainGroups[groupIndex].name==""){
      name= mainGroups[groupIndex].label.target!.name;
    }else{
      name= mainGroups[groupIndex].name!;
    }
    return name.length>20?"${name.substring(0,19)}...":name;
  }

  changePageType(){
    isSelection=!isSelection;
    updateObjects();
    notifyListeners();
  }
}