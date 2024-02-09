import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:pmvvm/pmvvm.dart';

class ProjectViewModel extends ViewModel {
  List<ProjectModel> projects;
  ValueSetter<ProjectModel> onEditProjectCaller;
  ValueSetter<int> onDeleteProjectCaller;

  ProjectViewModel(this.projects,this.onEditProjectCaller,this.onDeleteProjectCaller);

  void onProjectSelect(String action) async {
    ProjectModel? prj =
        await ProjectDAO().getDetails(int.parse(action.split('&&')[1]));
    switch (action.split('&&')[0]) {
      case 'edit':
        onEditProjectCaller(prj!);
        break;
      case 'delete':
        onDeleteProjectCaller(prj!.id);
        break;
      case 'goto':
        context.goNamed('screensSource',
            params: {'projectId': prj!.id.toString()});
        break;
    }
  }
}
