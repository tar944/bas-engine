import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:flutter/material.dart';

class RectanglePainter extends CustomPainter {
  ObjectModel? object;
  bool isMine;
  bool isActive;
  RectanglePainter({required this.object,required this.isMine,required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = isMine?Colors.blue:Colors.purpleAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    Rect rect = Rect.fromLTRB(object!.left, object!.top, object!.right, object!.bottom);
    canvas.drawRect(rect, paint);
    if(isActive){
      paint = Paint()
        ..color = isMine?Colors.blue.withOpacity(.3):Colors.purpleAccent.withOpacity(.3)
        ..style =PaintingStyle.fill
        ..strokeWidth = 1.5;

      rect = Rect.fromLTRB(object!.left, object!.top, object!.right, object!.bottom);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
