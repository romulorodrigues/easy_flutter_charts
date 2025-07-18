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
  final String Function(LineChartSeries serie, LineChartData data)?
      lineTooltipBuilder;
  final double dotRadius;
  final double strokeWidth;
  final List<dynamic> xAxis;
  final double? yMin;
  final double? yMax;

  const LineChart({
    super.key,
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
    this.dotRadius = 4.0,
    this.strokeWidth = 2.0,
    required this.xAxis,
    this.yMin,
    this.yMax,
  });

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  Offset? _tapPosition;
  List<({LineChartSeries serie, LineChartData point})> _selectedPoints = [];

  final GlobalKey _tooltipKey = GlobalKey();
  double tooltipWidth = 160.0;
  double tooltipHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_tooltipKey.currentContext != null) {
        final box = _tooltipKey.currentContext!.findRenderObject() as RenderBox;
        final height = box.size.height;
        if (tooltipHeight != height) {
          setState(() {
            tooltipHeight = height;
          });
        }
      }
    });

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
              return MouseRegion(
                onHover: (event) {
                  final localPosition =
                      (context.findRenderObject() as RenderBox)
                          .globalToLocal(event.position);
                  setState(() {
                    _tapPosition = localPosition;
                    _selectedPoints = _detectTappedPoints(
                      localPosition,
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );
                  });
                },
                onExit: (_) {
                  setState(() {
                    _selectedPoints.clear();
                    _tapPosition = null;
                  });
                },
                child: GestureDetector(
                  onTapDown: (details) {
                    setState(() {
                      _tapPosition = details.localPosition;
                      _selectedPoints = _detectTappedPoints(
                        details.localPosition,
                        constraints.maxWidth,
                        constraints.maxHeight,
                      );
                    });

                    if (_selectedPoints.isNotEmpty &&
                        widget.onPointTap != null) {
                      widget.onPointTap!(_selectedPoints.first.point);
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
                          dotRadius: widget.dotRadius,
                          strokeWidth: widget.strokeWidth,
                          xAxis: widget.xAxis,
                          yMax: widget.yMax,
                          yMin: widget.yMin,
                        ),
                      ),
                      if (_selectedPoints.isNotEmpty && _tapPosition != null)
                        Positioned(
                          left: () {
                            final dx = _tapPosition!.dx;
                            final maxLeft =
                                constraints.maxWidth.toDouble() - tooltipWidth;
                            if (dx + tooltipWidth > constraints.maxWidth) {
                              return maxLeft;
                            }
                            if (dx < 0) return 0.0;
                            return dx;
                          }(),
                          top: () {
                            final dy = _tapPosition!.dy;
                            final eixoXY =
                                constraints.maxHeight - widget.xAxisMargin;
                            final maxTop = eixoXY - tooltipHeight;
                            // valor mínimo para não sair do topo da tela
                            const minTop = 0.0;
                            final proposedTop = dy - tooltipHeight;
                            if (proposedTop < minTop) return minTop;
                            if (proposedTop > maxTop) return maxTop;

                            return proposedTop;
                          }(),
                          child: Material(
                            color: Colors.transparent,
                            child: SizedBox(
                              width: tooltipWidth,
                              child: _getGroupedTooltip(_selectedPoints),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.series.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 8,
              children: widget.series.map((s) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: s.color,
                        shape: BoxShape.rectangle,
                      ),
                    ),
                    Text(
                      s.name,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _getGroupedTooltip(
    List<({LineChartSeries serie, LineChartData point})> points,
  ) {
    final labelText = points.first.point.label.toString();

    return Container(
      key: _tooltipKey,
      constraints: const BoxConstraints(maxWidth: 200),
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
            softWrap: true,
          ),
          const SizedBox(height: 6),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 6),
          ...points.map((e) {
            final custom = widget.lineTooltipBuilder?.call(e.serie, e.point);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(right: 6, top: 2),
                  decoration: BoxDecoration(
                    color: e.serie.color,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    custom ??
                        '${e.serie.name}: ${e.point.value.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 12),
                    softWrap: true,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  List<({LineChartSeries serie, LineChartData point})> _detectTappedPoints(
      Offset position, double width, double height) {
    final result = <({LineChartSeries serie, LineChartData point})>[];
    final chartHeight = height - widget.xAxisMargin;
    final chartWidth = width - widget.yAxisMargin;

    final xLabels = widget.xAxis;
    final xStep =
        xLabels.length > 1 ? chartWidth / (xLabels.length - 1) : chartWidth;

    final yValues = widget.series.expand((s) => s.data).map((p) => p.value);
    if (yValues.isEmpty) return result;

    final dataYMin = yValues.reduce((a, b) => a < b ? a : b);
    final dataYMax = yValues.reduce((a, b) => a > b ? a : b);

    final yMin = widget.yMin ?? dataYMin;
    final yMax = widget.yMax ?? dataYMax;
    final yRange = yMax - yMin == 0 ? 1 : yMax - yMin;

    for (final serie in widget.series) {
      // Limita até o comprimento de xAxis OU da série (o menor entre os dois)
      final length = [
        xLabels.length,
        serie.data.length,
      ].reduce((a, b) => a < b ? a : b);

      for (int i = 0; i < length; i++) {
        final x = widget.yAxisMargin + xStep * i;
        final y =
            chartHeight - ((serie.data[i].value - yMin) / yRange) * chartHeight;

        final pointPos = Offset(x, y);
        if ((position - pointPos).distance < 12) {
          result.add((serie: serie, point: serie.data[i]));
        }
      }
    }

    return result;
  }
}
