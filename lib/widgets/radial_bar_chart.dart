import 'dart:math';

import 'package:flutter/material.dart';

import '../models/radial_bar_chart_data.dart';
import '../painters/radial_bar_chart_painter.dart';

enum LegendPosition {
  top,
  bottom,
}

class RadialBarChart extends StatefulWidget {
  final List<RadialBarData> data;
  final LegendPosition legendPosition;
  final String Function(RadialBarData data)? centerTextBuilder;
  final TextStyle? centerTextStyle;
  final double aspectRatio;

  const RadialBarChart({
    super.key,
    required this.data,
    this.legendPosition = LegendPosition.bottom,
    this.centerTextBuilder,
    this.centerTextStyle,
    this.aspectRatio = 2.0,
  });

  @override
  State<RadialBarChart> createState() => _RadialBarChartState();
}

class _RadialBarChartState extends State<RadialBarChart> {
  int? touchedIndex;
  Offset? localPosition;

  void _handleTouch(Offset position, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;
    final distance = sqrt(dx * dx + dy * dy);
    final radius = min(size.width, size.height) / 2.2;

    if (distance > radius + 15 || distance < radius - 15) {
      setState(() {
        touchedIndex = null;
        localPosition = null;
      });
      return;
    }

    final angle = (atan2(dy, dx) + 2 * pi) % (2 * pi);
    final total = widget.data.fold(0.0, (sum, e) => sum + e.value);
    double startAngle = -pi / 2;
    for (int i = 0; i < widget.data.length; i++) {
      final sweep = (widget.data[i].value / total) * 2 * pi;
      final endAngle = startAngle + sweep;

      // Corrigir para lidar com arcos que cruzam o 0 (2π)
      final normalizedStart = (startAngle + 2 * pi) % (2 * pi);
      final normalizedEnd = (endAngle + 2 * pi) % (2 * pi);
      final normalizedAngle = angle;

      bool isInArc;
      if (normalizedEnd < normalizedStart) {
        // Arco cruza o 0 radianos
        isInArc = normalizedAngle >= normalizedStart ||
            normalizedAngle <= normalizedEnd;
      } else {
        isInArc = normalizedAngle >= normalizedStart &&
            normalizedAngle <= normalizedEnd;
      }

      if (isInArc) {
        setState(() {
          touchedIndex = i;
          localPosition = position;
        });
        return;
      }

      startAngle = endAngle;
    }

    setState(() {
      touchedIndex = null;
      localPosition = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalValue =
              widget.data.fold<double>(0, (sum, item) => sum + item.value);

          final chart = LayoutBuilder(
            builder: (context, _) {
              return GestureDetector(
                onPanDown: (details) => _handleTouch(
                  details.localPosition,
                  context.size!,
                ),
                onTapDown: (details) => _handleTouch(
                  details.localPosition,
                  context.size!,
                ),
                child: MouseRegion(
                  onHover: (event) => _handleTouch(
                    event.localPosition,
                    context.size!,
                  ),
                  onExit: (_) => setState(() {
                    touchedIndex = null;
                    localPosition = null;
                  }),
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: RadialBarChartPainter(widget.data, touchedIndex),
                  ),
                ),
              );
            },
          );

          const double legendItemWidth = 80;

          final legend = Center(
            child: SizedBox(
              width: legendItemWidth * 4, // fixa 4 colunas
              child: Wrap(
                alignment: WrapAlignment.start,
                runSpacing: 8,
                spacing: 0,
                children: widget.data.map((item) {
                  return SizedBox(
                    width: legendItemWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: item.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          item.label,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );

          final chartWithCenter = Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                chart,
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: Text(
                    touchedIndex != null
                        ? widget.centerTextBuilder
                                ?.call(widget.data[touchedIndex!]) ??
                            '${widget.data[touchedIndex!].label}\n${widget.data[touchedIndex!].value}'
                        : 'Total\n$totalValue',
                    style: widget.centerTextStyle?.copyWith(
                          color: touchedIndex != null
                              ? (widget.centerTextStyle?.color ??
                                  widget.data[touchedIndex!].color)
                              : (widget.centerTextStyle?.color ??
                                  Colors.black87),
                        ) ??
                        TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: touchedIndex != null
                              ? widget.data[touchedIndex!].color
                              : Colors.black87,
                        ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          );

          return Column(
            children: widget.legendPosition == LegendPosition.top
                ? [legend, const SizedBox(height: 8), chartWithCenter]
                : [chartWithCenter, const SizedBox(height: 8), legend],
          );
        },
      ),
    );
  }
}
