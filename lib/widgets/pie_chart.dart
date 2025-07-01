import 'dart:math';

import 'package:flutter/material.dart';
import '../models/pie_chart_data.dart';
import '../painters/pie_chart_painter.dart';

enum LegendPosition { top, bottom }

class PieChart extends StatefulWidget {
  final List<PieChartData> data;
  final String? title;
  final TextStyle? titleStyle;
  final double aspectRatio;
  final LegendPosition legendPosition;
  final String Function(PieChartData data)? pieTooltipBuilder;

  const PieChart({
    Key? key,
    required this.data,
    this.title,
    this.titleStyle,
    this.aspectRatio = 1.0,
    this.legendPosition = LegendPosition.bottom,
    this.pieTooltipBuilder,
  }) : super(key: key);
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
            const SizedBox(height: 8),
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

    // Se estiver fora do círculo, ignora
    if (distanceFromCenter > radius) return null;

    final angle = (atan2(dy, dx) + 2 * pi) % (2 * pi);
    final total = widget.data.fold<double>(0, (sum, item) => sum + item.value);
    double startAngle = -pi / 2;

    for (int i = 0; i < widget.data.length; i++) {
      final sweep = (widget.data[i].value / total) * 2 * pi;
      if (angle >= startAngle && angle < startAngle + sweep) {
        return i;
      }
      startAngle += sweep;
    }

    return null;
  }
}
