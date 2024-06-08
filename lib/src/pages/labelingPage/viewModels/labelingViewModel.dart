import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageGroupDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/labelDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectPartDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/navModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectPartModel.dart';
import 'package:bas_dataset_generator_engine/src/data/preferences/preferencesData.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/dlgLevel.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:uuid/uuid.dart';

class LabelingViewModel extends ViewModel {
  List<ObjectModel> objects = [];
  List<List<NavModel>> allNavsRows = [];
  List<NavModel> selectedNavs = [];
  ImageGroupModel? curGroup;
  ProjectPartModel? curPart;
  int partId;
  final String prjUUID;
  final ValueSetter<String> onGroupActionCaller;

  LabelingViewModel(this.partId, this.prjUUID, this.onGroupActionCaller);

  @override
  void init() async {
    final address = await Preference().getMainAddress();
    updateByPartData(NavModel(-1, 0,1, "part", "", "","",""));
    if (address != '') {
      onGroupSelect("goto&&${address.split("&&")[2]}");
      await Preference().setMainAddress('');
    }
    if (await LabelDAO().needAddDefaultValue(prjUUID)) {
      await LabelDAO().addList(
          prjUUID,
          ObjectType.values
              .map((e) => LabelModel(0,const Uuid().v4(), e.name.toString().split('__')[0], "objects",e.name.toString().split('__')[1]))
              .toList());

      await LabelDAO().addList(
          prjUUID,
          Windows.values
              .map((e) => LabelModel(0,const Uuid().v4(), e.name.toString(), "windows",""))
              .toList());
    }
  }

  updateByPartData(NavModel curNav) async {
    curGroup = null;
    if (allNavsRows.isEmpty) {
      var prj = await ProjectDAO().getDetailsByUUID(prjUUID);
      List<NavModel> allNavs = [];
      for (var part in prj!.allParts) {
        int imgNumber = part.allObjects.length;
        for (var grp in part.allGroups) {
          imgNumber += grp.allStates.length;
        }
        allNavs.add(NavModel(
            part.id,
            imgNumber,
            1,
            "part",
            part.name!,
            part.allObjects.isNotEmpty
                ? part.allObjects[0].image.target!.path!
                : "",
          part.description!,
          ""
          )
        );
      }
      allNavsRows.add(allNavs);
      selectedNavs.add(allNavsRows[0][0]);
      curNav.id = prj.allParts[0].id;
    }

    curPart = await ProjectPartDAO().getDetails(curNav.id);
    objects=[];
    objects.addAll(curPart!.allObjects);
    for (var grp in curPart!.allGroups) {
      objects.addAll(grp.allStates);
    }
    partId=curPart!.id;
    notifyListeners();
  }

  updateByGroupData(NavModel curNav) async {
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
          allNavs.add(NavModel(
              grp.id,
              grp.allStates.length,
              curNav.rowNumber+1,
              "group",
              name,
              grp.state != GroupState.findMainState.name ? grp.mainState.target!.image.target!.path! : "",
              "",
              lblName
          ));
        }
      }
      allNavsRows.add(allNavs);
      selectedNavs.add(allNavs.firstWhere((element) => element.id == curNav.id));
      curGroup=allGroups.firstWhere((element) => element.id==curNav.id);
    }else{
      selectedNavs.add(curNav);
      curGroup = await ImageGroupDAO().getDetails(curNav.id);
    }
    curPart=null;
    objects = [];
    objects.addAll(curGroup!.allStates);
    notifyListeners();
  }

  onNavItemSelectHandler(NavModel curNav) async {
    int rowNumber = allNavsRows.length;
    if(curNav.rowNumber!=rowNumber){
      for (int i = curNav.rowNumber; i < rowNumber ; i++) {
        allNavsRows.removeAt(allNavsRows.length - 1);
        selectedNavs.removeAt(selectedNavs.length - 1);
      }
    }else{
      selectedNavs.removeAt(selectedNavs.length - 1);
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
    newGrp.id=await ImageGroupDAO().add(newGrp);
    curGroup!.otherShapes.add(newGrp);
    await ImageGroupDAO().update(curGroup!);
    curGroup=await ImageGroupDAO().getDetails(curGroup!.id);
    notifyListeners();
  }

  void onGroupSelect(String action) async {
    var act = action.split("&&");
    switch (act[0]) {
      case 'open':
        updateByGroupData(NavModel(int.parse(act[1]), 0,allNavsRows[allNavsRows.length-1][0].rowNumber, 'group',"", "newRow582990","",""));
        break;
      case 'changePart':
        partId=int.parse(action.split("&&")[1]);
        break;
      case 'setMainState':
      case 'goToCuttingPage':
        final curProject = await ProjectDAO().getDetailsByUUID(prjUUID);
        final curPart = await ProjectPartDAO().getDetails(partId);
        await Preference().setMainAddress('${curProject!.id}&&${curPart!.id}&&${curGroup!.id}');
        context.goNamed('cutToPieces',params: {
          'groupId':curGroup!.id.toString(),
          'partUUID':curPart.uuid,
          'prjUUID':prjUUID,
          'title': '${curProject.title} > ${curPart.name} > ${curGroup!.name}'
        });
        break;
    }
  }
}
