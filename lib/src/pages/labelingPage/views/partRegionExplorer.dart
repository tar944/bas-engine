import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/partRegionViewModel.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';
import 'exploredPartRegion.dart';
import 'newRectanglePainter.dart';


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

    return Stack(children: [
      Positioned(
        top: 0.0,
        bottom: 0.0,
        right: 0.0,
        left: 0.0,
        child: NewRectanglePainter(
          kind: 'part',
          onNewListener: vm.onNewRectangleHandler,
        ),
      ),
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
    ]);
  }
}
