import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/partRegionViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/rectanglePainter.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:uuid/uuid.dart';
import 'exploredPartRegion.dart';


class PartRegionExplorer extends StatelessWidget {
  const PartRegionExplorer( {
    Key? key,
    required this.onNewObjectHandler,
    required this.otherObjects,
    required this.itsObjects
  }) : super(key: key);

  final List<ObjectModel> otherObjects;
  final List<ObjectModel> itsObjects;
  final ValueSetter<ObjectModel> onNewObjectHandler;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel:
      PartRegionViewModel(otherObjects, itsObjects, onNewObjectHandler),
    );
  }
}

class _View extends StatelessView<PartRegionViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, PartRegionViewModel vm) {

    return Listener(
      onPointerDown: (e) {
        vm.top = e.localPosition.dy;
        vm.bottom = e.localPosition.dy;
        vm.left = e.localPosition.dx;
        vm.right = e.localPosition.dx;

        vm.isPainting = true;
      },
      onPointerMove: (e) {
        if (vm.isPainting) {
          vm.right = e.localPosition.dx;
          vm.bottom = e.localPosition.dy;
        }
      },
      onPointerUp: (e) async {
        vm.isPainting = false;
        final part = ObjectModel(
            0,
            const Uuid().v4(),
            vm.right > vm.left ? vm.left : vm.right,
            vm.right > vm.left ? vm.right : vm.left,
            vm.top > vm.bottom ? vm.bottom : vm.top,
            vm.top > vm.bottom ? vm.top : vm.bottom,
            ""
        );
        vm.onNewObjectHandler(part);
        vm.top = 0.0;
        vm.left = 0.0;
        vm.right = 0.0;
        vm.bottom = 0.0;
      },
      child: Stack(children: [
        Positioned(child: Listener(

        )),
        ...vm.otherObjects.map((item) {
          return Positioned(
            top: item.top-30,
            left: item.left,
            child: ExploredPartRegion(
              curObject: item,
              isMine: false,
              isActive: vm.curObject!=null&&item.id==vm.curObject!.id?true:false,
              onObjectClickCaller: vm.onObjectClickHandler,
            ),
          );
        }).toList(),
        ...vm.itsObjects.map((item) {
          return Positioned(
            top: item.top-40,
            left: item.left,
            child: ExploredPartRegion(
              curObject: item,
              isMine: true,
              isActive:vm.curObject!=null&&item.id==vm.curObject!.id?true:false,
              onObjectClickCaller: vm.onObjectClickHandler,
            ),
          );
        }).toList(),
        CustomPaint(
          painter: RectanglePainter(
              object:ObjectModel(
                  0,
                  "",
                  vm.left,
                  vm.right,
                  vm.top,
                  vm.bottom,
                  ""),isMine: false,isActive: false),
        ),
      ]),
    );
  }
}
