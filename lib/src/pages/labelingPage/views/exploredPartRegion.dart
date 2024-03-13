import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/controllers/regionRecController.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/flyDlgDelete.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/ExplorerPartViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/rectanglePainter.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ExploredPartRegion extends StatelessWidget {
  ExploredPartRegion({
    Key? key,
    required this.curObject,
    required this.mainObject,
    required this.isMine,
    required this.controller,
    required this.onObjectActionCaller,
  }) : super(key: key);

  ObjectModel curObject, mainObject;
  ValueSetter<String> onObjectActionCaller;
  bool isMine;
  RegionRecController controller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: ExplorerPartViewModel(curObject, mainObject, isMine,
          controller, onObjectActionCaller),
    );
  }
}

class _View extends StatelessView<ExplorerPartViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, ExplorerPartViewModel vm) {
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
                  object: ObjectModel(
                      0,
                      "",
                      0.0,
                      vm.isMaximize?vm.curObject.right - vm.curObject.left:40,
                      0.0,
                      vm.isMaximize?vm.curObject.bottom - vm.curObject.top:40,
                      ""),
                  color: vm.isMine?Colors.blue.dark:Colors.orange.dark,
                  isActive: vm.controller.activeID == vm.curObject.id),
            ),
            Positioned(
                right: 5,
                bottom: 5,
                child: Row(
                  children: [
                    vm.isMaximize&&vm.isMine?
                    FlyoutTarget(
                      key: GlobalKey(),
                      controller: controller,
                      child:
                      IconButton(
                          icon: Icon(
                            FluentIcons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => showFlyDelete(
                              Strings.deleteObject,
                              Strings.yes,
                              controller,
                              FlyoutPlacementMode.topCenter,
                              vm.curObject.id!,
                              vm.onObjectActionCaller)),
                    ):
                    Container(),
                    IconButton(
                        icon: Icon(
                          vm.isMaximize?FluentIcons.arrow_up_right_mirrored8:FluentIcons.arrow_down_right8,
                          color: Colors.white,
                        ),
                        onPressed: () => vm.onShowHandler())
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
