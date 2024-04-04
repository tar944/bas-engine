import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/cutToPiecesPage/views/rectanglePainter.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/partViewModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class PartRegion extends StatelessWidget {
  PartRegion({
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
      viewModel: PartViewModel(curObject, onObjectActionCaller),
    );
  }
}

class _View extends StatelessView<PartViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, PartViewModel vm) {
    final controller = FlyoutController();
    return SizedBox(
      width: vm.isMaximize?(vm.curObject.right - vm.curObject.left).abs():40,
      height: vm.isMaximize?(vm.curObject.bottom - vm.curObject.top).abs():40,
      child: Opacity(
        opacity: vm.isMaximize?1.0:0.3,
        child: Stack(
          children: [
            CustomPaint(
              painter: RectanglePainter(
                  object: ObjectModel(0, "", 0.0,
                      vm.isMaximize?vm.curObject.right - vm.curObject.left:40,
                      0.0,
                      vm.isMaximize?vm.curObject.bottom - vm.curObject.top:40,
                  ),
                  color: Colors.orange.dark,
                  isActive: true),
            ),
            Positioned(
                  right: 5,
                  bottom: 5,
                  child: Row(
                    children: [
                      IconButton(
                          style: ButtonStyle(
                              backgroundColor: ButtonState.all(Colors.grey[180].withOpacity(.7))
                          ),
                          icon: Icon(
                            vm.isMaximize?FluentIcons.arrow_up_right_mirrored8:FluentIcons.arrow_down_right8,
                            color: Colors.white,
                          ),
                          onPressed: () => vm.onShowHandler())
                    ],
                  )),
          ],
        ),
      ),
    );
  }
}
