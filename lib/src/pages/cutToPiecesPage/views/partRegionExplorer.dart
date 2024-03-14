import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/cutToPiecesPage/viewModels/partRegionViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/cutToPiecesPage/views/rectanglePainter.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';
import 'exploredPartRegion.dart';

class PartRegionExplorer extends StatelessWidget {
  PartRegionExplorer(
      {
        Key? key,
        required this.onNewObjectCaller,
        required this.otherObjects,
        required this.itsObjects,
        required this.mainObject,
        required this.prjUUID,
        required this.showOthers
      }) : super(key: key);

  final List<ObjectModel> otherObjects;
  final List<ObjectModel> itsObjects;
  final ObjectModel mainObject;
  final bool showOthers;
  final ValueSetter<ObjectModel> onNewObjectCaller;
  String prjUUID;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: PartRegionViewModel(
          prjUUID,
          mainObject,
          otherObjects,
          itsObjects,
          showOthers,
          onNewObjectCaller
      ),
    );
  }
}

class _View extends StatelessView<PartRegionViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, PartRegionViewModel vm) {
    return Listener(
      child: Stack(children: [
        Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Listener(
              onPointerDown: (e) => vm.pointerDownHandler(e),
              onPointerMove: (e) => vm.pointerMoveHandler(e),
              onPointerUp: (e) => vm.pointerUpHandler(e),
              child: CustomPaint(
                painter: RectanglePainter(
                    object: ObjectModel(
                        0, "", vm.left, vm.right, vm.top, vm.bottom, ""),
                    color: Colors.white,
                    isActive: false),
              ),
            )),
        ...vm.otherObjects.map((item) {
          return vm.showOthers?Positioned(
            top: item.top,
            left: item.left,
            child: ExploredPartRegion(
              mainObject:  vm.mainObject,
              curObject: item,
              isMine: false,
              controller: vm.objectController,
              onObjectActionCaller: (e) => vm.onObjectActionHandler(e),
            ),
          ) : Positioned(
            top: item.top,
            left: item.left,
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  color: Colors.magenta.withOpacity(.3)),
            ),
          );
        }).toList(),
        ...vm.itsObjects.map((item) {
          return Positioned(
                  top: item.top,
                  left: item.left,
                  child: ExploredPartRegion(
                    mainObject: vm.mainObject,
                    curObject: item,
                    isMine: true,
                    controller: vm.objectController,
                    onObjectActionCaller: (e) => vm.onObjectActionHandler(e),
                  ),
                );
        }).toList(),
      ]),
    );
  }
}
