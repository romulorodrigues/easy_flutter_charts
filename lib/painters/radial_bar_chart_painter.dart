import 'dart:math';

import 'package:flutter/material.dart';

import '../models/radial_bar_chart_data.dart';

class RadialBarChartPainter extends CustomPainter {
  final List<RadialBarData> data;
  final int? touchedIndex;

  RadialBarChartPainter(this.data, this.touchedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.fold<double>(0, (sum, item) => sum + item.value);
    final radius = min(size.width, size.height) / 2.2;
    final center = Offset(size.width / 2, size.height / 2);
    double startAngle = -pi / 2;

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final sweepAngle = (item.value / total) * 2 * pi;

      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = i == touchedIndex ? 36 : 30
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant RadialBarChartPainter oldDelegate) =>
      oldDelegate.touchedIndex != touchedIndex || oldDelegate.data != data;
}
