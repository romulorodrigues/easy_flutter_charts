import 'package:flutter/material.dart';
import '../models/line_chart_series.dart';

class LineChartPainter extends CustomPainter {
  final List<LineChartSeries> series;
  final double spacing;
  final TextStyle? xAxisLabelStyle;
  final TextStyle? yAxisLabelStyle;
  final String Function(double value)? yAxisLabelFormatter;
  final String Function(dynamic label)? xAxisLabelFormatter;
  final double yAxisMargin;
  final double xAxisMargin;
  final bool showDots;
  final bool showGrid;
  final double dotRadius;
  final double strokeWidth;
  final List<dynamic> xAxis;

  LineChartPainter({
    required this.series,
    required this.spacing,
    this.xAxisLabelStyle,
    this.yAxisLabelStyle,
    this.yAxisLabelFormatter,
    this.xAxisLabelFormatter,
    this.yAxisMargin = 30,
    this.xAxisMargin = 30,
    this.showDots = true,
    this.showGrid = true,
    this.dotRadius = 4.0,
    this.strokeWidth = 2.0,
    required this.xAxis,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke;
    final double chartWidth = size.width - yAxisMargin;
    final double chartHeight = size.height - xAxisMargin;

    final allPoints = series.expand((s) => s.data).toList();
    final yValues = allPoints.map((d) => d.value);
    final yMax =
        yValues.isEmpty ? 1.0 : yValues.reduce((a, b) => a > b ? a : b);
    final yMin =
        yValues.isEmpty ? 0.0 : yValues.reduce((a, b) => a < b ? a : b);
    final yRange = yMax - yMin == 0 ? 1 : yMax - yMin;

    final xLabels = xAxis;
    final pointsPerSeries = xLabels.length;
    final double xStep =
        pointsPerSeries > 1 ? chartWidth / (pointsPerSeries - 1) : chartWidth;

    // Desenha linhas de grade e rótulos Y
    for (int i = 0; i <= 5; i++) {
      final y = chartHeight - (chartHeight / 5) * i;
      final yValue = yMin + (yRange / 5) * i;

      if (showGrid) {
        final gridPaint = Paint()
          ..color = Colors.grey[300]!
          ..strokeWidth = 1;
        canvas.drawLine(
          Offset(yAxisMargin, y),
          Offset(size.width, y),
          gridPaint,
        );
      }

      final label =
          yAxisLabelFormatter?.call(yValue) ?? yValue.toStringAsFixed(1);
      final tp = TextPainter(
        text: TextSpan(text: label, style: yAxisLabelStyle),
        textAlign: TextAlign.right,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(yAxisMargin - tp.width - 4, y - tp.height / 2));
    }

    // Desenha as séries
    for (final s in series) {
      paint.color = s.color;
      paint.strokeWidth = strokeWidth;

      final points = <Offset>[];
      final length =
          [pointsPerSeries, s.data.length].reduce((a, b) => a < b ? a : b);

      for (int i = 0; i < length; i++) {
        final x = yAxisMargin + (xStep * i);
        final y =
            chartHeight - ((s.data[i].value - yMin) / yRange) * chartHeight;
        points.add(Offset(x, y));

        if (showDots) {
          final dotPaint = Paint()..color = s.color;
          canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
        }
      }

      if (points.length >= 2) {
        final path = Path()..moveTo(points[0].dx, points[0].dy);
        for (int i = 1; i < points.length; i++) {
          path.lineTo(points[i].dx, points[i].dy);
        }
        canvas.drawPath(path, paint);
      }
    }

    // Rótulos do eixo X
    for (int i = 0; i < xAxis.length; i++) {
      final rawLabel = xAxis[i];
      final formatted =
          xAxisLabelFormatter?.call(rawLabel) ?? rawLabel.toString();
      final x = yAxisMargin + (xStep * i);

      final List<String> lines = rawLabel is List
          ? rawLabel.map((e) => e.toString()).toList()
          : [formatted];

      double totalHeight = 0;
      final textPainters = <TextPainter>[];

      for (final line in lines) {
        final tp = TextPainter(
          text: TextSpan(text: line, style: xAxisLabelStyle),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        totalHeight += tp.height;
        textPainters.add(tp);
      }

      double currentY = chartHeight + 4;
      for (final tp in textPainters) {
        tp.paint(canvas, Offset(x - tp.width / 2, currentY));
        currentY += tp.height;
      }
    }
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) {
    return oldDelegate.series != series || oldDelegate.xAxis != xAxis;
  }
}
