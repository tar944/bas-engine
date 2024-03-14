import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/labelingBodyViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/navigationRowViewModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:pmvvm/pmvvm.dart';

class NavigationRow extends StatelessWidget {
  NavigationRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: NavigationRowViewModel(),
    );
  }
}

class _View extends StatelessView<NavigationRowViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, NavigationRowViewModel vm) {

    return Container();
  }
}
