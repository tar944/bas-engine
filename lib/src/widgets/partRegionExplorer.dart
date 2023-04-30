import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../models/rectangleModel.dart';
import 'exploredPartRegion.dart';
import 'newRectanglePainter.dart';

class PartRegionExplorer extends HookWidget {
  PartRegionExplorer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allRectangles = useState([]);

    onNewRectangleHandler(RectangleModel newRec) {
      print('new rectangle created');
      allRectangles.value = [...allRectangles.value..add(newRec)];
    }

    return Stack(children: [
      Positioned(
        top: 0.0,
        bottom: 0.0,
        right: 0.0,
        left: 0.0,
        child: NewRectanglePainter(
          onNewListener: onNewRectangleHandler,
        ),
      ),
      ...allRectangles.value.map((item) {
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
