import 'package:flutter/material.dart' show CustomClipper, Path, Size;

class CurveClipPath extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.002, size.height * 0.465,
        size.width * 0.04, size.height * 0.45);
    path.lineTo(size.width * 0.45, size.height * 0.28);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.26,
        size.width * 0.55, size.height * 0.28);
    path.lineTo(size.width * 0.96, size.height * 0.45);
    path.quadraticBezierTo(
        size.width * 0.998, size.height * 0.465, size.width, size.height * 0.5);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}
