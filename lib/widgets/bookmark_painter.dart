import 'package:CMDb/widgets/bookmark_clipper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';

class BookmarkPainter extends CustomPainter {
  final Color backgroundColor;
  final Color iconColor;

  BookmarkPainter(this.backgroundColor, this.iconColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final path = BookmarkClipper().getClip(size);
    canvas.drawPath(path, paint);

    final iconPainter = TextPainter(
      text: TextSpan(),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    final x = (size.width - iconPainter.width) / 2.0;
    final y = (size.height - iconPainter.height) / 2.0;
    iconPainter.paint(canvas, Offset(x, y));
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
