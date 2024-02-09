
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectModel.dart';
import 'package:bas_dataset_generator_engine/src/items/projectItem.dart';
import 'package:bas_dataset_generator_engine/src/pages/projectListPage/viewModels/projectViewModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ProjectsList extends StatelessWidget {
  ProjectsList({super.key,required this.projects,required this.onProjectActionCaller});

  ValueSetter<ProjectModel> onProjectActionCaller;
  List<ProjectModel> projects;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: ProjectViewModel(projects,onProjectActionCaller),
    );
  }
}

class _View extends StatelessView<ProjectViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, ProjectViewModel vm) {
    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20,left: 20,right: 20),
        child: vm.projects.isNotEmpty
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
          children: vm.projects
              .map((item) => ProjectItem(
              project: item,
              onActionCaller:
              vm.onProjectSelect))
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
