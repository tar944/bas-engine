import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageGroupDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
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
  ImageGroupModel? curGroup;
  int partId;
  String partUUID="";
  ValueSetter<String> onGroupActionCaller;

  ImageGroupsViewModel(this.partId, this.onGroupActionCaller);

  @override
  void init() async {
    updateProjectData(-1);
  }

  updateProjectData(groupId) async {
    if(groupId==-1){
      var part = await ProjectPartDAO().getDetails(partId);
      partUUID = part!.uuid;
      objects = part.allObjects;
      curGroup=null;
      groups = part.allGroups;
    }else{
      curGroup = await ImageGroupDAO().getDetails(groupId);
      objects = curGroup!.allObjects;
    }
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
        updateProjectData(-1);
        break;
      case 'goto':
        updateProjectData(int.parse(action.split("&&")[1]));
        onGroupActionCaller("refreshGroup&&${action.split("&&")[1]}");
        break;
    }
  }

  onObjectActionHandler(String action)async{
    switch (action.split('&&')[0]) {
      case 'addToGroup':
        var obj = await ObjectDAO().getObject(int.parse(action.split("&&")[2]));
        await ProjectPartDAO().removeObject(partId, obj!);
        await ImageGroupDAO().addObject(int.parse(action.split("&&")[1]), obj);
        updateProjectData(-1);
        break;
      case 'removeFromGroup':
        var obj = await ObjectDAO().getObject(int.parse(action.split("&&")[2]));
        await ProjectPartDAO().addObject(partId, obj!);
        await ImageGroupDAO().removeObject(int.parse(action.split("&&")[1]), obj);
        updateProjectData(curGroup!.id);
        break;
      case 'delete':
        var obj = await ObjectDAO().getObject(int.parse(action.split("&&")[1]));
        await ObjectDAO().deleteObject(obj!);
        if(curGroup==null){
          await ProjectPartDAO().removeObject(partId, obj);
          updateProjectData(-1);
        }else{
          await ImageGroupDAO().removeObject(curGroup!.id, obj);
          updateProjectData(curGroup!.id);
        }
        break;
    }
    onGroupActionCaller('refreshPart&&');
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
    curGroup=null;
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
