import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/cutToPiecesPage/views/rectanglePainter.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/partViewModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class PartRegion extends StatelessWidget {
  PartRegion({
    Key? key,
    required this.objId,
    required this.onObjectActionCaller,
  }) : super(key: key);

  final int objId;
  final VoidCallback onObjectActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: PartViewModel(objId, onObjectActionCaller),
    );
  }
}

class _View extends StatelessView<PartViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, PartViewModel vm) {
    return IconButton(
      style: ButtonStyle(
        padding: ButtonState.all(EdgeInsets.zero)
      ),
      onPressed: ()=>vm.onObjectActionCaller(),
      icon: vm.curObject!=null?SizedBox(
        width: (vm.curObject!.right - vm.curObject!.left).abs(),
        height:(vm.curObject!.bottom - vm.curObject!.top).abs(),
        child: Stack(
          children: [
            CustomPaint(
              painter: RectanglePainter(
                  object: ObjectModel(0, "", 0.0,
                      vm.curObject!.right - vm.curObject!.left,
                      0.0,
                      vm.curObject!.bottom - vm.curObject!.top,
                  ),
                  color: vm.curObject!.isNavTool?Colors.magenta.dark:Colors.orange.dark,
                  isActive: vm.curObject!.isNavTool),
            ),
          ],
        ),
      ):Container(),
    );
  }
}
