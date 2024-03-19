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
import 'package:bas_dataset_generator_engine/src/dialogs/toast.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/dlgImageGroup.dart';
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
    var prj = await ProjectDAO().getDetailsByUUID(prjUUID);
    List<NavModel> allNavs = [];
    for (var part in prj!.allParts) {
      int imgNumber = part.allObjects.length;
      for (var grp in part.allGroups) {
        imgNumber += grp.subObjects.length;
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
    curPart = prj.allParts[0];
    objects.addAll(curPart!.allObjects);
    for (var grp in curPart!.allGroups) {
      objects.addAll(grp.otherStates);
    }
    allNavsRows.add(allNavs);
    selectedNavs.add(allNavs[0]);
    notifyListeners();
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

  updateProjectData(int parentGrpId,int selectedGrp) async {
    List<ImageGroupModel> allGroups = [];
    allGroups = parentGrpId==-1?curPart!.allGroups:curGroup!.allGroups;
    List<NavModel> allNavs = [];
    for (var grp in allGroups) {
      allNavs.add(NavModel(
          grp.id,
          grp.otherStates.length,
          "group",
          grp.name!,
          grp.mainState.target!=null
              ? grp.mainState.target!.image.target!.path!
              : ""));
    }
    allNavsRows.add(allNavs);
    selectedNavs.add(allNavs[0]);

    curPart = null;
    curGroup =allGroups[0];
    objects=[];
    objects.addAll(curGroup!.otherStates);

    notifyListeners();
  }

  onNavItemSelectHandler(NavModel curNav) {
    if (selectedNavs.indexWhere((element) =>
            element.kind == curNav.kind && element.id == curNav.id) ==
        -1) {
      selectedNavs.add(curNav);
      notifyListeners();
    }
  }

  void onGroupSelect(String action) async {
    ImageGroupModel? group =
        await ImageGroupDAO().getDetails(int.parse(action.split("&&")[1]));
    var act = action.split("&&");
    switch (act[0]) {
      case 'open':
        updateProjectData(int.parse(act[2]),int.parse(action.split('&&')[1]));
        break;
      case 'edit':
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => DlgImageGroup(
                  group: group,
                  onSaveCaller: onEditGroupHandler,
                  partUUID: curGroup!.partUUID,
                ));
        break;
      case 'delete':
        if (group!.allGroups.isNotEmpty || group.subObjects.isNotEmpty) {
          Toast(Strings.deleteGroupError, false).showError(context);
          return;
        }
        await ImageGroupDAO().delete(group);
        onGroupActionCaller('refresh');
        updateProjectData(-1,-1);
        break;
      case 'goto':
        updateProjectData(int.parse(action.split("&&")[1]),-1);
        onGroupActionCaller("refreshGroup&&${action.split("&&")[1]}");
        break;
      case 'gotoLabeling':
        onGroupActionCaller(action);
        break;
    }
  }

  void onEditGroupHandler(ImageGroupModel curGroup) async {
    await ImageGroupDAO().update(curGroup);
    updateProjectData(-1,-1);
  }
}
