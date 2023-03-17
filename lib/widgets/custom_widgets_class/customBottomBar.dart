import 'package:flutter/material.dart';

class CustomCurveBottomBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height * 0.08);
    path.quadraticBezierTo(
        size.width * 0.01, size.height * 0.01, size.width * 0.04, 0);
    path.lineTo(size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.375, size.height * 0.01,
        size.width * 0.4, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.5, size.height * 1.1,
        size.width * 0.6, size.height * 0.2);
    path.quadraticBezierTo(
        size.width * 0.625, size.height * 0.01, size.width * 0.65, 0);
    path.lineTo(size.width * 0.96, 0);
    path.quadraticBezierTo(
        size.width * 0.99, size.height * 0.01, size.width, size.height * 0.08);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height * 0.08);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
