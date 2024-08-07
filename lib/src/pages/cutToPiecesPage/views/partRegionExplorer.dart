import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
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
        required this.minimumObjects,
        required this.onObjectActionCaller,
        required this.prjUUID,
        required this.isSimpleAction
      }) : super(key: key);

  final List<ObjectModel> otherObjects;
  final List<ObjectModel> itsObjects;
  final List<int> minimumObjects;
  final ObjectModel mainObject;
  final bool isSimpleAction;
  final ValueSetter<ObjectModel> onNewObjectCaller;
  final ValueSetter<String> onObjectActionCaller;
  String prjUUID;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: PartRegionViewModel(
          prjUUID,
          mainObject,
          minimumObjects,
          otherObjects,
          itsObjects,
          isSimpleAction,
          onNewObjectCaller,
          onObjectActionCaller
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
              onPointerDown: vm.allowDrawing?(e) => vm.pointerDownHandler(e):null,
              onPointerMove: vm.allowDrawing?(e) => vm.pointerMoveHandler(e):null,
              onPointerUp: vm.allowDrawing?(e) => vm.pointerUpHandler(e):null,
              child: CustomPaint(
                painter: RectanglePainter(
                    object: ObjectModel(
                        0, "", vm.left, vm.right, vm.top, vm.bottom),
                    color: Colors.white,
                    isActive: false),
              ),
            )),
        ...vm.otherObjects.map((item) {
          return Positioned(
            top: item.curTop(vm.mainObject.image.target!,context,Dimens.topBarHeight),
            left: item.curLeft(vm.mainObject.image.target!,context),
            child: ExploredPartRegion(
              key: GlobalKey(),
              mainObject: vm.mainObject,
              curObject: item,
              isMine: false,
              isMinimum: vm.minimumObjects.firstWhere((element) => element==item.id,orElse: ()=>-1)!=-1,
              isSimpleAction: vm.isSimpleAction,
              controller: vm.objectController,
              onObjectActionCaller: (e) => vm.onObjectActionHandler(e),
            ),
          );
        }).toList(),
        ...vm.itsObjects.map((item) {
          return Positioned(
                  top: vm.isSimpleAction?item.curTop(vm.mainObject.image.target!,context,Dimens.topBarHeight):item.top,
                  left: vm.isSimpleAction?item.curLeft(vm.mainObject.image.target!,context):item.left,
                  child: ExploredPartRegion(
                    key: GlobalKey(),
                    mainObject: vm.mainObject,
                    curObject: item,
                    isSimpleAction: vm.isSimpleAction,
                    isMine: true,
                    isMinimum: vm.minimumObjects.firstWhere((element) => element==item.id,orElse: ()=>-1)!=-1,
                    controller: vm.objectController,
                    onObjectActionCaller: (e) => vm.onObjectActionHandler(e),
                  ),
                );
        }).toList(),

      ]),
    );
  }
}
