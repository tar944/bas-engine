import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageGroupDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectPartDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/toast.dart';
import 'package:bas_dataset_generator_engine/src/pages/imageGroupPage/views/dlgImageGroup.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ImageGroupsViewModel extends ViewModel {
  List<ObjectModel> objects = [];
  List<ImageGroupModel> groups = [];
  List<int> selectedObjects=[];
  ImageGroupModel? curGroup;
  int partId;
  int groupId=-1;
  String partUUID="";
  ValueSetter<String> onGroupActionCaller;

  ImageGroupsViewModel(this.partId, this.onGroupActionCaller);

  @override
  void init() async {
    updateProjectData();
  }

  updateProjectData() async {
    var part = await ProjectPartDAO().getDetails(partId);
    partUUID = part!.uuid;
    objects = part.allObjects;
    groups = part.allGroups;
    notifyListeners();
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
        updateProjectData();
        break;
      case 'goto':
        onGroupActionCaller(group!.id.toString());
        break;
    }
  }

  onObjectActionHandler(String action)async{
    switch (action.split('&&')[0]) {
      case 'clicked':
        int objId = int.parse(action.split('&&')[1]);
        if(selectedObjects.contains(objId)){
          selectedObjects.removeWhere((element) => element==objId);
        }else{
          selectedObjects.add(objId);
        }
        notifyListeners();
        break;
      case 'setGroup':

        break;
    }
  }

  void onEditGroupHandler(ImageGroupModel curGroup) async {
    await ImageGroupDAO().update(curGroup);
    updateProjectData();
  }

  void onCreateGroupHandler(ImageGroupModel group) async {
    group.id = await ImageGroupDAO().add(group);
    await ProjectPartDAO().addGroup(partId, group);
    onGroupActionCaller('refresh');
    updateProjectData();
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
