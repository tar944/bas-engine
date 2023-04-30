import 'package:flutter/material.dart';

import '../models/rectangleModel.dart';



class RectanglePainter extends CustomPainter {
  List<RectangleModel> allRectangles;

  RectanglePainter(this.allRectangles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var e in allRectangles) {
      Paint paint = Paint()
        ..color = e.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;

      Rect rect = Rect.fromLTRB(e.left!, e.top!, e.right!, e.bottom!);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;

  }
}
