import 'dart:math';

import 'package:flutter/material.dart';
import '../models/pie_chart_data.dart';
import '../painters/pie_chart_painter.dart';
import '../models/legend_position.dart';

class PieChart extends StatefulWidget {
  final List<PieChartData> data;
  final String? title;
  final TextStyle? titleStyle;
  final double aspectRatio;
  final LegendPosition legendPosition;
  final String Function(PieChartData data)? pieTooltipBuilder;

  const PieChart({
    super.key,
    required this.data,
    this.title,
    this.titleStyle,
    this.aspectRatio = 3.0,
    this.legendPosition = LegendPosition.bottom,
    this.pieTooltipBuilder,
  });
  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  int? hoveredIndex;
  Offset? mousePosition;

  Widget _buildLegend({required bool isHorizontal}) {
    final legendItems = widget.data.map((item) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 12, height: 12, color: item.color),
            const SizedBox(width: 6),
            Text(item.label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      );
    }).toList();

    return isHorizontal
        ? Wrap(
            spacing: 12,
            runSpacing: 8,
            children: legendItems,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: legendItems,
          );
  }

  @override
  Widget build(BuildContext context) {
    final chart = AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return MouseRegion(
            onHover: (event) {
              setState(() {
                mousePosition = event.localPosition;
                hoveredIndex = _detectTouchedIndex(
                    event.localPosition, constraints.biggest);
              });
            },
            onExit: (_) => setState(() => hoveredIndex = null),
            child: CustomPaint(
              size: constraints.biggest,
              painter: PieChartPainter(widget.data, touchedIndex: hoveredIndex),
            ),
          );
        },
      ),
    );

    final isHorizontalLegend = widget.legendPosition == LegendPosition.top ||
        widget.legendPosition == LegendPosition.bottom;

    final legend = _buildLegend(isHorizontal: isHorizontalLegend);

    Widget layout;
    switch (widget.legendPosition) {
      case LegendPosition.top:
        layout = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.title != null)
              Text(widget.title!, style: widget.titleStyle),
            const SizedBox(height: 12),
            legend,
            const SizedBox(height: 8),
            chart,
          ],
        );
        break;
      case LegendPosition.bottom:
        layout = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.title != null)
              Text(widget.title!, style: widget.titleStyle),
            const SizedBox(height: 12),
            chart,
            const SizedBox(height: 8),
            legend,
          ],
        );
        break;
    }

    return Stack(
      children: [
        layout,
        if (hoveredIndex != null && mousePosition != null)
          Positioned(
            left: mousePosition!.dx + 10,
            top: mousePosition!.dy + 10,
            child: _buildTooltip(
              (widget.pieTooltipBuilder ??
                  _defaultTooltip)(widget.data[hoveredIndex!]),
            ),
          ),
      ],
    );
  }

  Widget _buildTooltip(String content) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          content,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  String _defaultTooltip(PieChartData data) {
    final total = widget.data.fold<double>(0, (sum, item) => sum + item.value);
    final percentage = (data.value / total * 100).toStringAsFixed(1);
    return '${data.label}: $percentage%';
  }

  int? _detectTouchedIndex(Offset position, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;
    final distanceFromCenter = sqrt(dx * dx + dy * dy);
    final radius = min(size.width, size.height) / 2;

    if (distanceFromCenter > radius) return null;

    // ângulo do ponto (de 0 a 2π)
    final angle = (atan2(dy, dx) + 2 * pi) % (2 * pi);

    final total = widget.data.fold<double>(0, (sum, item) => sum + item.value);
    double startAngle = -pi / 2; // começa no topo

    for (int i = 0; i < widget.data.length; i++) {
      final sweep = (widget.data[i].value / total) * 2 * pi;
      final endAngle = startAngle + sweep;

      // normaliza para 0..2π
      final normalizedStart = (startAngle + 2 * pi) % (2 * pi);
      final normalizedEnd = (endAngle + 2 * pi) % (2 * pi);

      final isWithin = normalizedStart < normalizedEnd
          ? angle >= normalizedStart && angle < normalizedEnd
          : angle >= normalizedStart || angle < normalizedEnd;

      if (isWithin) {
        return i;
      }

      startAngle = endAngle;
    }

    return null;
  }
}
