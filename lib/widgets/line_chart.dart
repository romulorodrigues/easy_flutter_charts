import 'package:flutter/material.dart';
import '../models/line_chart_series.dart';
import '../models/line_chart_data.dart';
import '../painters/line_chart_painter.dart';

class LineChart extends StatefulWidget {
  final List<LineChartSeries> series;
  final double spacing;
  final String? title;
  final TextStyle? titleStyle;
  final TextStyle? xAxisLabelStyle;
  final TextStyle? yAxisLabelStyle;
  final String Function(double value)? yAxisLabelFormatter;
  final String Function(dynamic label)? xAxisLabelFormatter;
  final void Function(LineChartData)? onPointTap;
  final double yAxisMargin;
  final double xAxisMargin;
  final bool showDots;
  final bool showGrid;
  final String Function(LineChartData)? lineTooltipBuilder;

  const LineChart({
    Key? key,
    required this.series,
    this.spacing = 20,
    this.title,
    this.titleStyle,
    this.xAxisLabelStyle,
    this.yAxisLabelStyle,
    this.yAxisLabelFormatter,
    this.xAxisLabelFormatter,
    this.onPointTap,
    this.yAxisMargin = 30,
    this.xAxisMargin = 30,
    this.showDots = true,
    this.showGrid = true,
    this.lineTooltipBuilder,
  }) : super(key: key);

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  Offset? _tapPosition;
  LineChartData? _selectedPoint;

  double tooltipWidth = 160.0;
  double tooltipHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              widget.title!,
              style: widget.titleStyle ??
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    _tapPosition = details.localPosition;
                    _selectedPoint = _detectTappedPoint(
                      details.localPosition,
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );
                  });

                  if (_selectedPoint != null && widget.onPointTap != null) {
                    widget.onPointTap!(_selectedPoint!);
                  }
                },
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size.infinite,
                      painter: LineChartPainter(
                        series: widget.series,
                        spacing: widget.spacing,
                        xAxisLabelStyle: widget.xAxisLabelStyle,
                        yAxisLabelStyle: widget.yAxisLabelStyle,
                        yAxisLabelFormatter: widget.yAxisLabelFormatter,
                        xAxisLabelFormatter: widget.xAxisLabelFormatter,
                        yAxisMargin: widget.yAxisMargin,
                        xAxisMargin: widget.xAxisMargin,
                        showDots: widget.showDots,
                        showGrid: widget.showGrid,
                      ),
                    ),
                    if (_selectedPoint != null && _tapPosition != null)
                      Positioned(
                        left: () {
                          final dx = _tapPosition!.dx;
                          final maxLeft =
                              constraints.maxWidth.toDouble() - tooltipWidth;
                          if (dx + tooltipWidth > constraints.maxWidth)
                            return maxLeft;
                          if (dx < 0) return 0.0;
                          return dx;
                        }(),
                        top: () {
                          final dy = _tapPosition!.dy;
                          final top = dy - tooltipHeight;
                          return top < 0 ? 0.0 : top;
                        }(),
                        child: Material(
                          color: Colors.transparent,
                          child: SizedBox(
                            width: tooltipWidth,
                            child: _getDefaultTooltip(_selectedPoint!),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _getDefaultTooltip(LineChartData point) {
    final label = point.label;
    final labelText =
        (label is List<String>) ? label.join(' ') : label.toString();

    // Custom
    if (widget.lineTooltipBuilder != null) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          widget.lineTooltipBuilder!(point),
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            labelText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 6),
          Text(
            '${point.value}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  LineChartData? _detectTappedPoint(
      Offset position, double width, double height) {
    final allPoints = widget.series.expand((s) => s.data).toList();
    final yValues = allPoints.map((d) => d.value);
    final yMax =
        yValues.isEmpty ? 1.0 : yValues.reduce((a, b) => a > b ? a : b);
    final yMin =
        yValues.isEmpty ? 0.0 : yValues.reduce((a, b) => a < b ? a : b);
    final yRange = yMax - yMin == 0 ? 1 : yMax - yMin;
    final chartHeight = height - widget.xAxisMargin;
    final chartWidth = width - widget.yAxisMargin;

    for (final series in widget.series) {
      final points = series.data;
      final double xStep =
          points.length > 1 ? chartWidth / (points.length - 1) : chartWidth;

      for (int i = 0; i < points.length; i++) {
        final x = widget.yAxisMargin + xStep * i;
        final y =
            chartHeight - ((points[i].value - yMin) / yRange) * chartHeight;

        if ((Offset(x, y) - position).distance < 12) {
          return points[i];
        }
      }
    }

    return null;
  }
}
