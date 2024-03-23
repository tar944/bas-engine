import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/projectListPage/views/dlgProjectInfo.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ProjectViewModel extends ViewModel {
  List<ProjectModel> projects=[];
  ValueSetter<int> onProjectActionCaller;

  ProjectViewModel(this.onProjectActionCaller);

  @override
  void init() async{
    // final address = await Preference().getMainAddress();
    final address = "";
    updateProjectData();
    if(address!="") {
      onProjectSelect("goto&&${address.split('&&')[0]}");
    }
  }

  updateProjectData()async{
    projects=await ProjectDAO().getAll();
    notifyListeners();
  }

  void onProjectSelect(String action) async {
    ProjectModel? prj =
        await ProjectDAO().getDetails(int.parse(action.split('&&')[1]));
    switch (action.split('&&')[0]) {
      case 'edit':
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) =>
              DlgProjectInfo(onSaveCaller: onEditProjectHandler, project: prj),
        );
        break;
      case 'delete':
        await ProjectDAO().delete(prj!);
        onProjectActionCaller(-1);
        updateProjectData();
        break;
      case 'goto':
        onProjectActionCaller(prj!.id);
        break;
    }
  }
  void onEditProjectHandler(ProjectModel curProject) async {
    await ProjectDAO().update(curProject);
    updateProjectData();
  }

  void onCreateProjectHandler(ProjectModel curProject) async {
    await ProjectDAO().addProject(curProject);
    await DirectoryManager().createPrjDir(curProject.uuid);
    onProjectActionCaller(-1);
    updateProjectData();
  }

  createProject(){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) =>
            DlgProjectInfo(onSaveCaller: onCreateProjectHandler));
  }
}
