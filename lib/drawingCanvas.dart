
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawingCanvas extends CustomPainter{
  final pointsList;
  final Color accentColor;
  final sliderValue;
  DrawingCanvas(this.pointsList, this.accentColor, this.sliderValue): super();

  @override
  void paint(Canvas canvas, Size size) {
    //final recorder = PictureRecorder();
    //final canvas = Canvas(recorder, Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    var paint = Paint()
    ..color = accentColor
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..strokeWidth = sliderValue;

    for (var i = 0; i < pointsList.length; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i], pointsList[i +1], paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [pointsList[i]], paint);
      }
    }

    //final picture = recorder.endRecording();
    //final img = picture.toImage(size.width.toInt(), size.height.toInt());
  
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return true;
    //return oldDelegate.pointsList != pointsList;
  }
}