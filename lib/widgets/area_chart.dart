import 'package:flutter/material.dart';
import '../models/area_chart_data.dart';
import '../models/area_chart_series.dart';
import '../models/legend_position.dart';
import '../painters/area_chart_painter.dart';

class AreaChart extends StatefulWidget {
  final List<AreaChartSeries> series;
  final List<dynamic> xAxis;
  final String? title;
  final TextStyle? titleStyle;
  final double xAxisMargin;
  final double yAxisMargin;
  final String Function(AreaChartSeries serie, AreaChartData data)?
      tooltipBuilder;
  final TextStyle? xAxisLabelStyle;
  final String Function(dynamic label)? xAxisLabelFormatter;
  final TextStyle? yAxisLabelStyle;
  final String Function(double value)? yAxisLabelFormatter;
  final LegendPosition? legendPosition;

  const AreaChart({
    Key? key,
    required this.series,
    required this.xAxis,
    this.title,
    this.titleStyle,
    this.xAxisMargin = 30,
    this.yAxisMargin = 30,
    this.tooltipBuilder,
    this.xAxisLabelStyle,
    this.xAxisLabelFormatter,
    this.yAxisLabelStyle,
    this.yAxisLabelFormatter,
    this.legendPosition = LegendPosition.bottom,
  }) : super(key: key);

  @override
  State<AreaChart> createState() => _AreaChartState();
}

class _AreaChartState extends State<AreaChart> {
  final GlobalKey _tooltipKey = GlobalKey();

  Offset? _tapPosition;
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    final legend = _buildLegend();

    return Column(
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(widget.title!, style: widget.titleStyle),
          ),
        const SizedBox(
          height: 10,
        ),
        if (widget.legendPosition == LegendPosition.top) ...[
          legend,
          const SizedBox(
            height: 20,
          ),
        ],
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const tooltipWidth = 160.0;
              const tooltipHeight = 80.0;

              return MouseRegion(
                onHover: (event) {
                  final box = context.findRenderObject() as RenderBox;
                  final local = box.globalToLocal(event.position);
                  final index = _getTouchedIndex(local);
                  setState(() {
                    touchedIndex = index;
                    _tapPosition = local;
                  });
                },
                onExit: (_) => setState(() {
                  touchedIndex = null;
                  _tapPosition = null;
                }),
                child: GestureDetector(
                  onTapDown: (details) {
                    final box = context.findRenderObject() as RenderBox;
                    final local = box.globalToLocal(details.globalPosition);
                    final index = _getTouchedIndex(local);
                    setState(() {
                      touchedIndex = index;
                      _tapPosition = local;
                    });
                  },
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size.infinite,
                        painter: AreaChartPainter(
                          widget.series,
                          xAxis: widget.xAxis,
                          touchedIndex: touchedIndex,
                          xAxisLabelStyle: widget.xAxisLabelStyle,
                          xAxisLabelFormatter: widget.xAxisLabelFormatter,
                          yAxisLabelStyle: widget.yAxisLabelStyle,
                          yAxisLabelFormatter: widget.yAxisLabelFormatter,
                          xAxisMargin: widget.xAxisMargin,
                          yAxisMargin: widget.yAxisMargin,
                        ),
                      ),
                      if (touchedIndex != null && _tapPosition != null)
                        Builder(builder: (_) {
                          final points = widget.series
                              .where(
                                  (serie) => touchedIndex! < serie.data.length)
                              .map((serie) => (
                                    serie: serie,
                                    point: serie.data[touchedIndex!],
                                  ))
                              .toList();

                          if (points.isEmpty) return const SizedBox.shrink();

                          final dx = _tapPosition!.dx;
                          final dy = _tapPosition!.dy;

                          final maxLeft = constraints.maxWidth - tooltipWidth;
                          final maxTop = constraints.maxHeight -
                              widget.xAxisMargin -
                              tooltipHeight;

                          final left = () {
                            if (dx + tooltipWidth > constraints.maxWidth)
                              return maxLeft;
                            if (dx < 0) return 0.0;
                            return dx;
                          }();

                          final top = () {
                            final proposedTop = dy - tooltipHeight;
                            if (proposedTop < 0.0) return 0.0;
                            if (proposedTop > maxTop) return maxTop;
                            return proposedTop;
                          }();

                          return Positioned(
                            left: left,
                            top: top,
                            child: Material(
                              color: Colors.transparent,
                              child: SizedBox(
                                width: tooltipWidth,
                                child: _getGroupedTooltip(points),
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        if (widget.legendPosition == LegendPosition.bottom) legend,
      ],
    );
  }

  int? _getTouchedIndex(Offset localPosition) {
    final width = context.size?.width ?? 0;
    final step = width / (widget.xAxis.length - 1);
    final index = (localPosition.dx / step).round();

    if (index >= 0 && index < widget.xAxis.length) {
      return index;
    }
    return null;
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 24,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: widget.series.map((serie) {
        return IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: serie.color,
                  shape: BoxShape.circle,
                ),
              ),
              Flexible(
                child: Text(
                  serie.name,
                  style: const TextStyle(fontSize: 12),
                  softWrap: true,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _getGroupedTooltip(
      List<({AreaChartSeries serie, AreaChartData point})> points) {
    final labelText =
        points.isNotEmpty ? points.first.point.label?.toString() ?? '' : '';

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
            final custom = widget.tooltipBuilder?.call(e.serie, e.point);
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
}
