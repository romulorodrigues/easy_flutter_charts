import 'package:flutter/material.dart';
import 'dart:math';
import '../models/area_chart_series.dart';

class AreaChartPainter extends CustomPainter {
  final List<AreaChartSeries> series;
  final List<dynamic> xAxis;
  final int? touchedIndex;
  final TextStyle? xAxisLabelStyle;
  final String Function(dynamic label)? xAxisLabelFormatter;
  final TextStyle? yAxisLabelStyle;
  final String Function(double value)? yAxisLabelFormatter;
  final bool showGrid;
  final double yAxisMargin;
  final double xAxisMargin;

  AreaChartPainter(
    this.series, {
    required this.xAxis,
    this.touchedIndex,
    this.xAxisLabelStyle,
    this.xAxisLabelFormatter,
    this.yAxisLabelStyle,
    this.yAxisLabelFormatter,
    this.showGrid = true,
    this.yAxisMargin = 40,
    this.xAxisMargin = 30,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final chartWidth = size.width - yAxisMargin;
    final chartHeight = size.height - xAxisMargin;

    final maxY = series.expand((s) => s.data).map((e) => e.value).reduce(max);
    final stepX = chartWidth / (xAxis.length - 1);
    final stepY = chartHeight / 5;
    final valueStep = maxY / 5;

    final yTextPainter = TextPainter(
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    );

    final paint = Paint()..style = PaintingStyle.fill;

    // Desenha linhas de grade e rótulos do eixo Y
    for (int i = 0; i <= 5; i++) {
      final y = stepY * i;
      final value = maxY - valueStep * i;
      final posY = y;

      if (showGrid) {
        final gridPaint = Paint()
          ..color = Colors.grey.shade300
          ..strokeWidth = 1;
        canvas.drawLine(
          Offset(yAxisMargin, posY),
          Offset(size.width, posY),
          gridPaint,
        );
      }

      final formatted = yAxisLabelFormatter != null
          ? yAxisLabelFormatter!(value)
          : value.toStringAsFixed(0);

      yTextPainter.text = TextSpan(
        text: formatted,
        style: yAxisLabelStyle ??
            const TextStyle(fontSize: 10, color: Colors.black),
      );

      yTextPainter.layout();
      canvas.save();
      canvas.translate(
        yAxisMargin - 6,
        posY - yTextPainter.height / 2,
      );
      yTextPainter.paint(canvas, Offset(-yTextPainter.width, 0));
      canvas.restore();
    }

    // Desenha as séries
    for (final serie in series) {
      final path = Path()..moveTo(yAxisMargin, chartHeight);
      final points = <Offset>[];

      for (int i = 0; i < serie.data.length; i++) {
        final x = yAxisMargin + stepX * i;
        final yValue = serie.data[i].value / maxY;
        final y = chartHeight - (yValue * chartHeight);
        points.add(Offset(x, y));
        path.lineTo(x, y);
      }

      final lastPoint = points.last;
      path.lineTo(lastPoint.dx, chartHeight);
      path.close();

      canvas.drawPath(
        path,
        paint..color = serie.color.withOpacity(0.3),
      );

      final strokePaint = Paint()
        ..color = serie.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final borderPath = Path();
      for (int i = 0; i < points.length; i++) {
        if (i == 0) {
          borderPath.moveTo(points[i].dx, points[i].dy);
        } else {
          borderPath.lineTo(points[i].dx, points[i].dy);
        }
      }

      canvas.drawPath(borderPath, strokePaint);

      if (touchedIndex != null && touchedIndex! < points.length) {
        final dotPaint = Paint()..color = serie.color;
        canvas.drawCircle(points[touchedIndex!], 4, dotPaint);
      }
    }

    // Desenhar labels do eixo X
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < xAxis.length; i++) {
      final label = xAxisLabelFormatter != null
          ? xAxisLabelFormatter!(xAxis[i])
          : xAxis[i].toString();

      textPainter.text = TextSpan(
        text: label,
        style: xAxisLabelStyle ??
            const TextStyle(fontSize: 10, color: Colors.black),
      );

      textPainter.layout();

      final offset = Offset(
        yAxisMargin + stepX * i - textPainter.width / 2,
        chartHeight + 10,
      );

      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant AreaChartPainter oldDelegate) {
    return oldDelegate.series != series ||
        oldDelegate.touchedIndex != touchedIndex ||
        oldDelegate.xAxis != xAxis;
  }
}
