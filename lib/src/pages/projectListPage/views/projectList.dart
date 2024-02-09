
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectModel.dart';
import 'package:bas_dataset_generator_engine/src/items/projectItem.dart';
import 'package:bas_dataset_generator_engine/src/pages/projectListPage/views/dlgNewProject.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class ProjectsList extends HookWidget{

  void _init() async {
  }

  @override
  Widget build(BuildContext context) {
    final projects = useState([]);

    useEffect(() {
      _init();
      Future<void>.microtask(() async {
        projects.value = await ProjectDAO().getAll();
      });
      return null;
    }, const []);

    void onCreateCourseHandler(ProjectModel curProject) async {
      final id = await ProjectDAO().update(curProject);
      await DirectoryManager().createPrjDir(curProject.uuid);
      projects.value = await ProjectDAO().getAll();
    }

    void onSoftwareSelect(String action) async{
      ProjectModel? prj =  await ProjectDAO().getDetails(int.parse(action.split('&&')[1]));
      switch(action.split('&&')[0]){
        case 'edit':
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) =>DlgNewProject(onSaveCaller: onCreateCourseHandler,project:prj),);
          break;
        case 'delete':
          await ProjectDAO().delete(prj!);
          projects.value = await ProjectDAO().getAll();
          break;
        case 'goto':
          context.goNamed('screensSource',params: {'projectId':prj!.id.toString()});
          break;
      }
    }

    void onNewSoftwareHandler(String action) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) =>
              DlgNewProject(onSaveCaller: onCreateCourseHandler));
    }

    return Container(
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20,left: 20,right: 20),
        child: projects.value.isNotEmpty
            ? GridView(
          controller: ScrollController(
              keepScrollOffset: false),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          gridDelegate:
          const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              childAspectRatio: 3 / 1.8,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          children: projects.value
              .map((item) => ProjectItem(
              project: item,
              onActionCaller:
              onSoftwareSelect))
              .toList(),
        )
            : Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            Container(
              height: 350,
              width: 350,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'lib/assets/images/emptyBox.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              Strings.emptySoftware,
              style: TextSystem.textL(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
