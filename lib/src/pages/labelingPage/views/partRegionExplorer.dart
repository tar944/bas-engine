import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/partRegionViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/rectanglePainter.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';
import 'exploredPartRegion.dart';


class PartRegionExplorer extends StatelessWidget {
  PartRegionExplorer( {
    Key? key,
    required this.onNewObjectCaller,
    required this.otherObjects,
    required this.itsObjects,
    required this.prjUUID
  }) : super(key: key);

  final List<ObjectModel> otherObjects;
  final List<ObjectModel> itsObjects;
  final ValueSetter<ObjectModel> onNewObjectCaller;
  String prjUUID;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel:
      PartRegionViewModel(prjUUID,otherObjects, itsObjects, onNewObjectCaller),
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
              onPointerDown: (e) =>vm.pointerDownHandler(e),
              onPointerMove: (e) =>vm.pointerMoveHandler(e),
              onPointerHover: (e) =>vm.pointerHoverHandler(e),
              onPointerUp: (e)=>vm.pointerUpHandler(e),
              child: CustomPaint(
              painter: RectanglePainter(
                  object:ObjectModel(
                      0,
                      "",
                      vm.left,
                      vm.right,
                      vm.top,
                      vm.bottom,
                      ""),color: Colors.white,isActive: false),
            ),
        )),
        ...vm.otherObjects.map((item) {
          return Positioned(
            top: item.top-40,
            left: item.left,
            child: ExploredPartRegion(
              key: GlobalKey(),
              curObject: item,
              isMine: false,
              isActive: vm.curObject!=null&&item.id==vm.curObject!.id?true:false,
              controller: vm.objectController,
              onObjectActionCaller: (e)=>vm.onObjectActionHandler(e),
            ),
          );
        }).toList(),
        ...vm.itsObjects.map((item) {
          return Positioned(
            top: item.top-40,
            left: item.left,
            child: ExploredPartRegion(
              key: GlobalKey(),
              curObject: item,
              isMine: true,
              isActive:vm.curObject!=null&&item.id==vm.curObject!.id?true:false,
              controller: vm.objectController,
              onObjectActionCaller: (e)=>vm.onObjectActionHandler(e),
            ),
          );
        }).toList(),
      ]),
    );
  }
}
