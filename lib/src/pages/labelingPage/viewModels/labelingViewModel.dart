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
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

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
    updateByPartData(NavModel(-1, 0, "part", "", ""));
    if (address != '') {
      onGroupSelect("goto&&${address.split("&&")[2]}");
      await Preference().setMainAddress('');
    }
    if (await LabelDAO().needAddDefaultValue(prjUUID)) {
      await LabelDAO().addList(
          prjUUID,
          ObjectType.values
              .map((e) => LabelModel(0, e.name, "objects"))
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
          imgNumber += grp.otherStates.length;
        }
        allNavs.add(NavModel(
            part.id,
            imgNumber,
            "part",
            part.name!,
            part.allObjects.isNotEmpty
                ? part.allObjects[0].image.target!.path!
                : ""));
      }
      allNavsRows.add(allNavs);
      selectedNavs.add(allNavsRows[0][0]);
      curNav.id = prj.allParts[0].id;
    }

    curPart = await ProjectPartDAO().getDetails(curNav.id);
    objects=[];
    objects.addAll(curPart!.allObjects);
    for (var grp in curPart!.allGroups) {
      objects.addAll(grp.otherStates);
    }

    notifyListeners();
  }

  updateByGroupData(NavModel curNav) async {
    if(curNav.imgPath=="newRow582990"){
      List<ImageGroupModel> allGroups = curPart==null?curGroup!.allGroups:curPart!.allGroups;
      List<NavModel> allNavs = [];
      for (var grp in allGroups) {
        allNavs.add(NavModel(
            grp.id,
            grp.otherStates.length,
            "group",
            grp.name!,
            grp.mainState.target != null
                ? grp.mainState.target!.image.target!.path!
                : ""));
      }
      allNavsRows.add(allNavs);
      selectedNavs.add(allNavs.firstWhere((element) => element.id == curNav.id));
      curGroup=allGroups.firstWhere((element) => element.id==curNav.id);
    }else{
      curGroup = await ImageGroupDAO().getDetails(curNav.id);
    }
    curPart=null;
    objects = [];
    objects.addAll(curGroup!.otherStates);
    for (var grp in curGroup!.allGroups) {
      objects.addAll(grp.otherStates);
    }
    notifyListeners();
  }

  onNavItemSelectHandler(NavModel curNav) async {
    int rowNumber = allNavsRows.length;
    for (int i = curNav.rowNumber; i < rowNumber ; i++) {
      allNavsRows.removeAt(allNavsRows.length - 1);
      selectedNavs.removeAt(selectedNavs.length - 1);
    }

    if (curNav.kind == "part") {
      updateByPartData(curNav);
    } else {
      updateByGroupData(curNav);
    }
  }

  void onGroupSelect(String action) async {
    var act = action.split("&&");
    switch (act[0]) {
      case 'open':
        updateByGroupData(NavModel(int.parse(act[1]), 0, 'group',"", "newRow582990"));
        break;
      case 'gotoLabeling':
        onGroupActionCaller(action);
        break;
    }
  }
}
