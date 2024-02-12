import 'package:bas_dataset_generator_engine/src/data/dao/imageGroupDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectPartDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectPartModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/imageGroupPage/views/dlgImageGroup.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
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
    ProjectPartModel? part =
        await ProjectPartDAO().getDetails(int.parse(action.split('&&')[1]));
    switch (action.split('&&')[0]) {
      case 'edit':
        break;
      case 'record':
        context.goNamed('recordScreens', params: {'partId': part!.id.toString()});
        Navigator.pop(context);
        break;
      case 'deleteObject':
        // await ProjectPartDAO().delete(part!);
        // await ProjectDAO().removeAPart(prjID, part);
        // onPartActionCaller(-1);
        updateProjectData();
        break;
      case 'deleteGroup':
        // await ProjectPartDAO().delete(part!);
        // await ProjectDAO().removeAPart(prjID, part);
        // onPartActionCaller(-1);
        updateProjectData();
        break;
      case 'goto':
        onGroupActionCaller(part!.id.toString());
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
    await ImageGroupModelDAO().update(curGroup);
    updateProjectData();
  }

  void onCreateGroupHandler(ImageGroupModel group) async {
    // curPart.id = await ProjectPartDAO().add(curPart);
    // await ProjectDAO().addAPart(prjID, curPart);
    // await DirectoryManager().createPartDir(curPart.prjUUID, curPart.uuid);
    // onGroupActionCaller(-1);
    updateProjectData();
  }

  createGroup() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => DlgImageGroup(
              onSaveCaller: onCreateGroupHandler,
              partUUID: partUUID,
            ));
  }
}
