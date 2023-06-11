import 'package:bas_dataset_generator_engine/src/data/models/regionDataModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'exploredPartRegion.dart';
import 'newRectanglePainter.dart';

class PartRegionExplorer extends HookWidget {
  PartRegionExplorer( {
    Key? key,
    required this.onNewPartHandler,
    required this.allParts,
    required this.screenId,
  }) : super(key: key);

  final List<RegionDataModel> allParts;
  final int screenId;
  final ValueSetter<RegionDataModel> onNewPartHandler;

  @override
  Widget build(BuildContext context) {

    onNewRectangleHandler(RegionDataModel newPart) async{
      onNewPartHandler(newPart);
    }
    return Stack(children: [
      Positioned(
        top: 0.0,
        bottom: 0.0,
        right: 0.0,
        left: 0.0,
        child: NewRectanglePainter(
          kind: 'part',
          screenId: screenId,
          onNewListener: onNewRectangleHandler,
        ),
      ),
      ...allParts.map((item) {
        return Positioned(
          top: item.top,
          left: item.left,
          child: ExploredPartRegion(
            curRectangle: item,
          ),
        );
      }).toList(),
    ]);
  }
}
