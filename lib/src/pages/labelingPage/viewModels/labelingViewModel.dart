import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageGroupDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/labelDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectPartDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/navModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectPartModel.dart';
import 'package:bas_dataset_generator_engine/src/data/preferences/preferencesData.dart';
import 'package:bas_dataset_generator_engine/src/pages/cutToPiecesPage/views/dlgCutToPiece.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/controller/bodyController.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/controller/navRowController.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/dlgLevel.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:uuid/uuid.dart';

class LabelingViewModel extends ViewModel {
  BodyController bodyController=BodyController();
  List<NavRowController> allNavRows = [];
  ImageGroupModel? curGroup;
  ProjectPartModel? curPart;
  int partId;
  final String prjUUID;
  final ValueSetter<String> onGroupActionCaller;

  LabelingViewModel(this.partId, this.prjUUID, this.onGroupActionCaller);

  @override
  void init() async {
    final address = await Preference().getMainAddress();
    bodyController.setPrjUUID(prjUUID);
    updateByPartData(NavModel(-1, 0, "part", "", "","","",[]));
    if (address != '') {
      onGroupSelect("goto&&${address.split("&&")[2]}");
      await Preference().setMainAddress('');
    }
    if (await LabelDAO().needAddDefaultValue(prjUUID)) {
      await LabelDAO().addList(prjUUID, ObjectType.values.map((e) => LabelModel(0,const Uuid().v4(), e.name.toString().split('__')[0], "objects",e.name.toString().split('__')[1])).toList());
      await LabelDAO().addList(prjUUID, Windows.values.map((e) => LabelModel(0,const Uuid().v4(), e.name.toString(), "windows","")).toList());
    }
  }

  updateByPartData(NavModel curNav) async {
    curGroup = null;
    bodyController.setGrpUUID("");
    if (allNavRows.isEmpty) {
      var prj = await ProjectDAO().getDetailsByUUID(prjUUID);
      List<NavModel> allNavs = [];
      for (var part in prj!.allParts) {
        int imgNumber = part.allObjects.length;
        for (var grp in part.allGroups) {
          imgNumber += grp.allStates.length;
        }
        var imgPath = part.allObjects.isNotEmpty ? part.allObjects[0].image.target!.path! : "";
        if(imgPath==""){
          for(var grp in part.allGroups){
            if(grp.mainState.target!=null){
              imgPath=grp.mainState.target!.image.target!.path!;
              break;
            }
          }
        }
        allNavs.add(NavModel(
            part.id,
            imgNumber,
            "part",
            part.name!,
            imgPath,
            part.description!,
            "",
            []
          )
        );
      }
      allNavRows.add(
          NavRowController()
            ..setAllItems(allNavs)
            ..setSelectedNav(allNavs[0])
            ..setRowNumber(1)
            ..visibleBtn(false)
      );
      curNav.id = prj.allParts[0].id;
    }

    curPart = await ProjectPartDAO().getDetails(curNav.id);
    var objects=<ObjectModel>[];
    objects.addAll(curPart!.allObjects);
    for (var grp in curPart!.allGroups) {
      objects.addAll(grp.allStates);
      for(var shp in grp.otherShapes){
        objects.addAll(shp.allStates);
      }
    }
    bodyController.setObjects(objects);
    bodyController.setPartId(curPart!.id);
    partId=curPart!.id;
    bodyController.setPartUUID(curPart!.uuid);
    notifyListeners();
  }

  updateByGroupData(NavModel curNav) async {
    for(int i=0;i<allNavRows.length;i++){
      allNavRows[i].visibleBtn(false);
    }
    if(curNav.imgPath=="newRow582990"){
      List<ImageGroupModel> allGroups = curPart==null?curGroup!.allGroups:curPart!.allGroups;
      List<NavModel> allNavs = [];
      for (var grp in allGroups) {
        if(grp.label.target!=null){
          String name=grp.name!;
          String lblName = grp.label.target!.name;
          if(grp.name==""){
            name = lblName;
            if(grp.partUUID!=""){
              var parGrp = await ProjectPartDAO().getDetailsByUUID(grp.partUUID);
              lblName=parGrp!.name!;
            }else if(grp.groupUUID!=""){
              var parGrp = await ImageGroupDAO().getDetailsByUUID(grp.groupUUID);
              lblName=parGrp!.label.target!.name;
            }
          }
          if(grp.mainState.target!=null&&grp.mainState.target!.image.target==null) {
            grp.mainState.target=null;
            grp.state=GroupState.findMainState.name;
            await ImageGroupDAO().update(grp);
          }
          if(grp.otherShapes.isNotEmpty&&grp.allStates.isNotEmpty) {
            grp.otherShapes.insert(0,grp);
          }
          var imgPath =grp.state != GroupState.findMainState.name ? grp.mainState.target!.image.target!.path! : "";
          if(imgPath==""){
            for(var shape in grp.otherShapes){
              if(shape.mainState.target!=null){
                imgPath=shape.mainState.target!.image.target!.path!;
                break;
              }
            }
          }
          allNavs.add(NavModel(
              grp.id,
              grp.allStates.length,
              "group",
              name,
              imgPath,
              "",
              lblName,
              grp.otherShapes
          ));
        }
      }
      allNavRows.add(
          NavRowController()
            ..setAllItems(allNavs)
            ..setSelectedNav(allNavs.firstWhere((element) => element.id == curNav.id))
            ..setRowNumber(allNavRows[allNavRows.length-1].rowNumber+1)
            ..visibleBtn(true)
      );
      curGroup=allGroups.firstWhere((element) => element.id==curNav.id);
    }else{
      allNavRows[allNavRows.length-1].setSelectedNav(curNav);
      allNavRows[allNavRows.length-1].visibleBtn(true);
      curGroup = await ImageGroupDAO().getDetails(curNav.id);
    }

    curPart=null;
    curGroup = curGroup!.otherShapes.isEmpty?curGroup:curGroup!.otherShapes[0];
    bodyController.setObjects(curGroup!.allStates);
    bodyController.setPartUUID("");
    bodyController.setGrpUUID(curGroup!.uuid);
    notifyListeners();
  }

  onNavItemSelectHandler(NavModel curNav) async {
    int rowNumber = allNavRows.length;
    if(curNav.rowNumber!=rowNumber){
      for (int i = curNav.rowNumber; i < rowNumber ; i++) {
        allNavRows.removeAt(allNavRows.length - 1);
      }
    }
    if (curNav.kind == "part") {
      updateByPartData(curNav);
    } else {
      updateByGroupData(curNav);
    }
  }

  onAddNewShapeHandler(NavModel nav){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          DlgTitle(onActionCaller: saveAddShapeHandler, title: "",dlgTitle: Strings.dlgShape,),
    );
  }

  saveAddShapeHandler(String name)async{
    ImageGroupModel? newGrp= ImageGroupModel(-1, "", curGroup!.uuid, name);
    newGrp.uuid = const Uuid().v4();
    newGrp.state = GroupState.findMainState.name;
    newGrp.label.target=curGroup!.label.target;
    newGrp.id=await ImageGroupDAO().add(newGrp);
    curGroup!.otherShapes.add(newGrp);
    await ImageGroupDAO().update(curGroup!);
    curGroup=await ImageGroupDAO().getDetails(curGroup!.id);
    bodyController.setGrpUUID(curGroup!.uuid);
    notifyListeners();
  }

  onShapeChangeHandler(NavModel nav)async{
    curGroup = await ImageGroupDAO().getDetails(nav.otherShapes[nav.shapeIndex].id);
    bodyController.setObjects(curGroup!.allStates);
    bodyController.setGrpUUID(curGroup!.uuid);
    var items = allNavRows[allNavRows.length-1].allItems;
    items[items.indexWhere((element) => element.id==nav.id)].shapeIndex=nav.shapeIndex;
    allNavRows[allNavRows.length-1].setAllItems(items);
    notifyListeners();
  }

  void onGroupSelect(String action) async {
    var act = action.split("&&");
    switch (act[0]) {
      case 'open':
        updateByGroupData(NavModel(int.parse(act[1]), 0, 'group',"", "newRow582990","","",[]));
        break;
      case 'changePart':
        partId=int.parse(action.split("&&")[1]);
        bodyController.setPartId(partId);
        break;
      case 'setMainState':
      case 'goToCuttingPage':
        final curProject = await ProjectDAO().getDetailsByUUID(prjUUID);
        final curPart = await ProjectPartDAO().getDetails(partId);
        await Preference().setMainAddress('${curProject!.id}&&${curPart!.id}&&${curGroup!.id}');
        var img =curGroup!.allStates[0].image.target!;
        ImageModel? srcImg;
        for(var grp in curPart.allGroups){
          if(grp.mainState.target!=null){
            srcImg=grp.mainState.target!.image.target!;
            break;
          }
        }

        if(img.width<(srcImg!.width*0.8)&&img.height<(srcImg.height*0.8)){
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) =>
                DlgCutToPiece(
                  groupId: curGroup!.id,
                  partUUID: curPart.uuid,
                  prjUUID: prjUUID,
                  title: '${curProject.title} > ${curPart.name} > ${curGroup!.name}',
                  onCloseCaller: ()=>{},
                ),
          );
        }else{
          context.goNamed('cutToPieces',params: {
            'groupId':curGroup!.id.toString(),
            'partUUID':curPart.uuid,
            'prjUUID':prjUUID,
            'title': '${curProject.title} > ${curPart.name} > ${curGroup!.name}'
          });
        }

        break;
    }
  }
}
