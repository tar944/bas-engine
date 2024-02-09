import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'exploredPartRegion.dart';
import 'newRectanglePainter.dart';

class PartRegionExplorer extends HookWidget {
  const PartRegionExplorer( {
    Key? key,
    required this.onNewObjectHandler,
    required this.allObjects,
  }) : super(key: key);

  final List<ObjectModel> allObjects;
  final ValueSetter<ObjectModel> onNewObjectHandler;

  @override
  Widget build(BuildContext context) {

    onNewRectangleHandler(ObjectModel newObject) async{
      onNewObjectHandler(newObject);
    }
    return Stack(children: [
      Positioned(
        top: 0.0,
        bottom: 0.0,
        right: 0.0,
        left: 0.0,
        child: NewRectanglePainter(
          kind: 'part',
          onNewListener: onNewRectangleHandler,
        ),
      ),
      ...allObjects.map((item) {
        return Positioned(
          top: item.top,
          left: item.left,
          child: ExploredPartRegion(
            curObject: item,
          ),
        );
      }).toList(),
    ]);
  }
}
