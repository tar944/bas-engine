import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:flutter/material.dart';

class RectanglePainter extends CustomPainter {
  ObjectModel? object;
  Color color;
  bool isActive;
  RectanglePainter({required this.object,required this.color,required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    Rect rect = Rect.fromLTRB(object!.left, object!.top, object!.right, object!.bottom);
    canvas.drawRect(rect, paint);
    if(isActive){
      paint = Paint()
        ..color = color.withOpacity(0.2)
        ..style =PaintingStyle.fill
        ..strokeWidth = 2.0;

      rect = Rect.fromLTRB(object!.left, object!.top, object!.right, object!.bottom);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
