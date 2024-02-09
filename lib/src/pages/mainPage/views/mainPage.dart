import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/pages/mainPage/viewModels/mainViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/mainPage/views/headerPart.dart';
import 'package:bas_dataset_generator_engine/src/pages/projectListPage/views/projectList.dart';
import 'package:bas_dataset_generator_engine/src/parts/topBarPanel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: MainPageViewModel(),
    );
  }
}

class _View extends StatelessView<MainPageViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, MainPageViewModel vm) {
    return ScaffoldPage(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        content: Container(
          color: Colors.grey[210],
          child: Column(children: [
            TopBarPanel(
              title: Strings.appName,
              needBack: false,
              needHelp: false,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: HeaderPart(onActionCaller: vm.onNavigationChanged),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height-(Dimens.mainHeaderH+Dimens.topBarHeight+20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[190]
                ),
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: vm.controller,
                  children: <Widget>[
                    Center(
                      child: ProjectsList(),
                    ),
                    Center(
                      child: ProjectsList(),
                    ),
                    Center(
                      child: ProjectsList(),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}
