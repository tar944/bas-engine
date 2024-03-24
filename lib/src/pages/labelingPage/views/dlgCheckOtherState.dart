import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/checkOtherStateViewModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class DlgCheckOtherState extends StatelessWidget {
  const DlgCheckOtherState({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel:
      CheckOtherStateViewModel(),
    );
  }
}

class _View extends StatelessView<CheckOtherStateViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, CheckOtherStateViewModel vm) {
    return Container();
  }
}