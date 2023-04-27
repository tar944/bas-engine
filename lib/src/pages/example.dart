import 'package:flutter/material.dart';

import '../models/rectangleModel.dart';

class MyRectangle extends StatefulWidget {
  @override
  _MyRectangleState createState() => _MyRectangleState();
}

class _MyRectangleState extends State<MyRectangle> {
  // مشخصات مستطیل
  List<RectangleModel> allRectangles = [];
  bool isPainting = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      // کنترل کردن حرکت موس,
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
      // نمایش مستطیل
      child: CustomPaint(
        painter: RectanglePainter(allRectangles),
        // size: Size(50, 50),
      ),
    );
  }
}

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
