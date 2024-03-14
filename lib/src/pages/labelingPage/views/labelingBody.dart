import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/labelingBodyViewModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:pmvvm/pmvvm.dart';

class LabelingBody extends StatelessWidget {
  LabelingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: LabelingBodyViewModel(),
    );
  }
}

class _View extends StatelessView<LabelingBodyViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, LabelingBodyViewModel vm) {

    return Container();
  }
}
