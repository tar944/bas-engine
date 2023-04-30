import 'package:bas_dataset_generator_engine/src/widgets/rectanglePainter.dart';
import 'package:flutter/material.dart';

import '../items/flyoutPageItemDelete.dart';
import '../items/flyoutPageItemEdit.dart';
import '../models/rectangleModel.dart';
import 'editBottomRectangle.dart';

class MyRectangle extends StatefulWidget {
  @override
  _MyRectangleState createState() => _MyRectangleState();
}


class _MyRectangleState extends State<MyRectangle> {
  List<RectangleModel> allRectangles = [];
  bool isPainting = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) {
        setState(() {
          allRectangles.add(RectangleModel(e.localPosition.dx,
              e.localPosition.dx, e.localPosition.dy, e.localPosition.dy));
          isPainting = true;
        });
      },
      onPointerMove: (e) {
        if (isPainting) {
          setState(() {
            allRectangles[allRectangles.length - 1].right = e.localPosition.dx;
            allRectangles[allRectangles.length - 1].bottom = e.localPosition.dy;
          });
        }
      },
      onPointerUp: (e) {
        isPainting = false;
      },
      child: CustomPaint(
        painter: RectanglePainter(allRectangles),
        child: Stack(
          children: allRectangles.map((e) {
            return Positioned(
              left: e.right!-60,
              top: e.bottom!+10,
              child: EditBottomRectangle(),
            );
          }).toList(),
        ),
      ),
    );
  }
}


