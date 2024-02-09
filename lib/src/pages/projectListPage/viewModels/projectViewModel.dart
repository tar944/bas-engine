import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/mainPage/views/dlgProjectInfo.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:pmvvm/pmvvm.dart';

class ProjectViewModel extends ViewModel {
  List<ProjectModel> projects;
  ValueSetter<ProjectModel> onProjectActionCaller;

  ProjectViewModel(this.projects,this.onProjectActionCaller);

  void onCreateCourseHandler(ProjectModel curProject) async {
    final id = await ProjectDAO().update(curProject);
    await DirectoryManager().createPrjDir(curProject.uuid);
    projects = await ProjectDAO().getAll();
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
              DlgProjectInfo(onSaveCaller: onCreateCourseHandler, project: prj),
        );
        break;
      case 'delete':
        await ProjectDAO().delete(prj!);
        projects = await ProjectDAO().getAll();
        notifyListeners();
        break;
      case 'goto':
        context.goNamed('screensSource',
            params: {'projectId': prj!.id.toString()});
        break;
    }
  }

  void onNewSoftwareHandler(String action) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) =>
            DlgProjectInfo(onSaveCaller: onCreateCourseHandler));
  }
}
