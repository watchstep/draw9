import 'package:flutter/material.dart';
import 'package:app/model/drawing_mode.dart';

class DrawingInfo {
  final List<Offset> points;
  final Color color;
  final double size;
  final DrawingMode mode;

  DrawingInfo({
    required this.points,
    this.color = Colors.black,
    required this.size,
    this.mode = DrawingMode.pen,
  });

  Map<String, dynamic> toMap() {
    List<Map> pointsMap = points.map((e) => {'dx': e.dx, 'dy': e.dy}).toList();
    return {
      'points': pointsMap,
      'color': color,
      'width': size,
      'mode': mode.toString().split('.')[1],
    };
  }
}
