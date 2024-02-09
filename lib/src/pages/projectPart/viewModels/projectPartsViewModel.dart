import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectPartDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectPartModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/projectPart/views/dlgProjectPart.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:pmvvm/pmvvm.dart';

class ProjectPartsViewModel extends ViewModel {
  List<ProjectPartModel> parts=[];
  int prjID;
  String prjUUID="";
  ValueSetter<int> onPartActionCaller;

  ProjectPartsViewModel(this.prjID,this.onPartActionCaller);

  @override
  void init() async{
    var prj= await ProjectDAO().getDetails(prjID);
    prjUUID=prj!.uuid;
    updateProjectData();
  }

  updateProjectData()async{
    parts=await ProjectDAO().getAllParts(prjID);
    notifyListeners();
  }

  void onPartSelect(String action) async {
    ProjectPartModel? part =
    await ProjectPartDAO().getDetails(int.parse(action.split('&&')[1]));
    switch (action.split('&&')[0]) {
      case 'edit':
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) =>
              DlgProjectPart(onSaveCaller: onEditPartHandler, part: part,prjUUID: prjUUID,),
        );
        break;
      case 'record':
        context.goNamed('recordScreens',params: {'partId':part!.id.toString()});
        Navigator.pop(context);
        break;
      case 'delete':
        await ProjectPartDAO().delete(part!);
        await ProjectDAO().removeAPart(prjID, part);
        onPartActionCaller(-1);
        updateProjectData();
        break;
      case 'goto':
        onPartActionCaller(part!.id);
        break;
    }
  }
  void onEditPartHandler(ProjectPartModel curPart) async {
    await ProjectPartDAO().update(curPart);
    updateProjectData();
  }

  void onCreateProjectHandler(ProjectPartModel curPart) async {
    curPart.id=await ProjectPartDAO().add(curPart);
    await ProjectDAO().addAPart(prjID, curPart);
    await DirectoryManager().createPartDir(curPart.prjUUID,curPart.uuid);
    onPartActionCaller(-1);
    updateProjectData();
  }

  createPart(){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) =>
            DlgProjectPart(onSaveCaller: onCreateProjectHandler,prjUUID: prjUUID,));
  }
}
