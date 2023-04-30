import 'package:flutter/material.dart';
import '../models/rectangleModel.dart';

class RectanglePainter extends CustomPainter {
  RectangleModel? rectangle;

  RectanglePainter(this.rectangle);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = rectangle!.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Rect rect = Rect.fromLTRB(rectangle!.left!, rectangle!.top!, rectangle!.right!, rectangle!.bottom!);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
