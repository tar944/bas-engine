import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:flutter/material.dart';

class RectanglePainter extends CustomPainter {
  ObjectModel? object;

  RectanglePainter(this.object);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Rect rect = Rect.fromLTRB(object!.left, object!.top, object!.right, object!.bottom);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
