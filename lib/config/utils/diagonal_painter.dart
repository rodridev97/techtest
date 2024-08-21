import 'package:flutter/material.dart';

class DiagonalPainter extends CustomPainter {
  DiagonalPainter({super.repaint, required this.context});

  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(0, size.height);
    path.close();

    paint.color = Theme.of(context)
        .colorScheme
        .primary
        .withOpacity(0.7); // Cambia el color a tu preferencia
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
