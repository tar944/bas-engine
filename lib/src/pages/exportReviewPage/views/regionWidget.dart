import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/cutToPiecesPage/views/rectanglePainter.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/viewModels/regionViewModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class RegionWidget extends StatelessWidget {
  RegionWidget({
    Key? key,
    required this.curObject,
    required this.onObjectActionCaller,
  }) : super(key: key);

  final ObjectModel curObject;
  final ValueSetter<String> onObjectActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: RegionViewModel(curObject, onObjectActionCaller),
    );
  }
}

class _View extends StatelessView<RegionViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, RegionViewModel vm) {
   return SizedBox(
      width: vm.getSize(isWidth: true),
      height: vm.getSize(),
      child: CustomPaint(
        painter: RectanglePainter(
            object: ObjectModel(0, "", 0.0,
              vm.getSize(isWidth: true),
                0.0,
              vm.getSize(),
            ),
            color: Colors.blue.dark,
            isActive: false),
      ),
    );
  }
}
