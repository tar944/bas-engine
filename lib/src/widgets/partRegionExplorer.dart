import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'exploredPartRegion.dart';
import 'newRectanglePainter.dart';

class PartRegionExplorer extends HookWidget {
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
    print('other object size => ${otherObjects.length}');
    print('its objects size => ${itsObjects.length}');
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
      ...otherObjects.map((item) {
        return Positioned(
          top: item.top,
          left: item.left,
          child: ExploredPartRegion(
            curObject: item,
            isMine: true,
          ),
        );
      }).toList(),
      ...itsObjects.map((item) {
        return Positioned(
          top: item.top,
          left: item.left,
          child: ExploredPartRegion(
            curObject: item,
            isMine: false,
          ),
        );
      }).toList(),
    ]);
  }
}
