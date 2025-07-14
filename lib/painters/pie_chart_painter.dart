import 'dart:math';
import 'package:flutter/material.dart';
import '../models/pie_chart_data.dart';

class PieChartPainter extends CustomPainter {
  final List<PieChartData> data;
  final int? touchedIndex;

  PieChartPainter(this.data, {this.touchedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.fold<double>(0, (sum, item) => sum + item.value);
    double startAngle = -pi / 2;
    final radius = min(size.width, size.height) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final sweepAngle = (item.value / total) * 2 * pi;
      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.fill;

      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);

      // Texto percentual
      final labelAngle = startAngle + sweepAngle / 2;
      final percentage = '${((item.value / total) * 100).toStringAsFixed(1)}%';
      final offset = Offset(
        center.dx + cos(labelAngle) * radius * 0.5,
        center.dy + sin(labelAngle) * radius * 0.5,
      );

      textPainter.text = TextSpan(
        text: percentage,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
      textPainter.layout();
      final labelOffset = Offset(
        offset.dx - textPainter.width / 2,
        offset.dy - textPainter.height / 2,
      );
      textPainter.paint(canvas, labelOffset);

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant PieChartPainter oldDelegate) => true;
}
