
import 'package:flutter/material.dart';

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = Colors.deepOrange;
    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Rect.fromLTWH(50, 50, size.width, size.height);
    // draw the circle with center having radius 75.0
    canvas.drawRect(center, paint);

  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return null;
  }
}