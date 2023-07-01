import 'package:flutter/material.dart';

class BookmarkClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    final path = Path();
    final double borderRadius = 10.0; // Adjust the border radius as desired

    path.lineTo(0.0, size.height);
    path.lineTo(size.width * 0.4, size.height);
    path.lineTo(size.width * 0.5, size.height * 0.8);
    path.lineTo(size.width * 0.6, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, borderRadius);
    path.arcToPoint(
      Offset(size.width, 0.0),
      clockwise: false,
    );
    path.lineTo(borderRadius, 0.0);
    path.arcToPoint(
      Offset(0.0, borderRadius),
      radius: Radius.circular(borderRadius),
      clockwise: false,
    );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
