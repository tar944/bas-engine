import 'package:bas_dataset_generator_engine/src/data/models/regionDataModel.dart';
import 'package:flutter/material.dart';

class RectanglePainter extends CustomPainter {
  RegionDataModel? rectangle;

  RectanglePainter(this.rectangle);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Rect rect = Rect.fromLTRB(rectangle!.left, rectangle!.top, rectangle!.right, rectangle!.bottom);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
