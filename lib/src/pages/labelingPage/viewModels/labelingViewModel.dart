import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageGroupDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectPartDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/navModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/preferences/preferencesData.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/toast.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/dlgImageGroup.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class LabelingViewModel extends ViewModel {
  List<ImageGroupModel> groups = [];
  List<ObjectModel> objects = [];
  List<List<NavModel>> allNavsRows = [];
  ImageGroupModel curGroup=ImageGroupModel(-1, "", "", "", "");
  int partId;
  String partUUID="";
  String prjUUID="";
  ValueSetter<String> onGroupActionCaller;

  LabelingViewModel(this.partId, this.onGroupActionCaller);

  @override
  void init() async {
    final address = await Preference().getMainAddress();
    updateProjectData(-1);
    if(address!=''){
      onGroupSelect("goto&&${address.split("&&")[2]}");
      await Preference().setMainAddress('');
    }
  }

  updateProjectData(groupId) async {
    if(groupId==-1){
      var part = await ProjectPartDAO().getDetails(partId);
      prjUUID=part!.prjUUID;
      partUUID = part.uuid;
      groups = part.allGroups;
    }
    notifyListeners();
  }

  onNavItemSelectHandler(NavModel curNav){

  }

  void onGroupSelect(String action) async {
    ImageGroupModel? group = await ImageGroupDAO().getDetails(int.parse(action.split("&&")[1]));
    switch (action.split('&&')[0]) {
      case 'edit':
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => DlgImageGroup(
              group: group,
              onSaveCaller: onEditGroupHandler,
              partUUID: partUUID,
            )
        );
        break;
      case 'delete':
        if(group!.allGroups.isNotEmpty||group.allObjects.isNotEmpty){
          Toast(Strings.deleteGroupError,false).showError(context);
          return;
        }
        await ImageGroupDAO().delete(group);
        onGroupActionCaller('refresh');
        updateProjectData(-1);
        break;
      case 'goto':
        updateProjectData(int.parse(action.split("&&")[1]));
        onGroupActionCaller("refreshGroup&&${action.split("&&")[1]}");
        break;
      case 'gotoLabeling':
        onGroupActionCaller(action);
        break;
    }
  }

  void onEditGroupHandler(ImageGroupModel curGroup) async {
    await ImageGroupDAO().update(curGroup);
    updateProjectData(-1);
  }

  void onCreateGroupHandler(ImageGroupModel group) async {
    group.id = await ImageGroupDAO().add(group);
    await ProjectPartDAO().addGroup(partId, group);
    onGroupActionCaller('refresh');
    updateProjectData(-1);
  }

  onBackClickHandler(){
    updateProjectData(-1);
    onGroupActionCaller("refreshGroup&&-1");
  }

  createGroup() async{
    var part = await ProjectPartDAO().getDetails(partId);
    if(part!.allGroups.length>8){
      Toast(Strings.maxGroupNumberError,false).showError(context);
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => DlgImageGroup(
              onSaveCaller: onCreateGroupHandler,
              partUUID: partUUID,
            )
    );
  }
}
