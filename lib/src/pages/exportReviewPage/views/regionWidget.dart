import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/cutToPiecesPage/views/rectanglePainter.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/viewModels/regionViewModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class RegionWidget extends StatelessWidget {
  RegionWidget({
    Key? key,
    required this.curObject,
    required this.width,
    required this.height,
    required this.regionStatus,
    required this.onObjectActionCaller,
  }) : super(key: key);

  final PascalObjectModel curObject;
  final double width,height;
  final String regionStatus;
  final ValueSetter<String> onObjectActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: RegionViewModel(curObject,regionStatus,width,height, onObjectActionCaller),
    );
  }
}

class _View extends StatelessView<RegionViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, RegionViewModel vm) {
   return MouseRegion(
     onEnter:(e)=> vm.onHoverHandler(true),
     onExit: (e)=> vm.onHoverHandler(false),
     child: GestureDetector(
       onTapUp: (e)=>vm.onClickHandler(),
       onSecondaryTapUp: (e)=>vm.onRightClickHandler(),
       onTertiaryTapUp: (e)=>vm.onMiddleHandler(),
       child: SizedBox(
          width: vm.width,
          height: vm.height,
          child: CustomPaint(
            painter: RectanglePainter(
                object: ObjectModel(0, "", 0.0,
                  vm.width,
                    0.0,
                  vm.height,
                ),
                color: vm.regionStatus=="active"?Colors.green:vm.regionStatus=="none"?Colors.orange:Colors.magenta.light,
                isActive: vm.isHover),
          ),
        ),
     ),
   );
  }
}
