import 'package:flutter/material.dart';

class CurveAppBar extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path path = Path();
    path.lineTo(0, rect.height);
    path.quadraticBezierTo(rect.width * 0.007, rect.height * 1.07,
        rect.width * 0.1, rect.height * 1.1);
    path.lineTo(rect.width * 0.9, rect.height * 1.1);
    path.quadraticBezierTo(
        rect.width * 0.993, rect.height * 1.07, rect.width, rect.height);
    path.lineTo(rect.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }
}
