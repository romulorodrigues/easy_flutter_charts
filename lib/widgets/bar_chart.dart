import 'package:flutter/material.dart';
import '../models/bar_chart_data.dart';
import '../painters/bar_chart_painter.dart';

class BarChart extends StatefulWidget {
  final List<BarChartData> data;
  final double spacing;
  final String? title;
  final TextStyle? titleStyle;
  final TextStyle? xAxisLabelStyle;
  final TextStyle? yAxisLabelStyle;
  final String Function(double value)? yAxisLabelFormatter;
  final String Function(dynamic label)? xAxisLabelFormatter;
  final void Function(BarChartData)? onBarTap;
  final String Function(BarChartData)? barTooltipBuilder;
  final double yAxisMargin;
  final double xAxisMargin;

  const BarChart({
    Key? key,
    required this.data,
    this.spacing = 20,
    this.title,
    this.titleStyle,
    this.xAxisLabelStyle,
    this.yAxisLabelStyle,
    this.yAxisLabelFormatter,
    this.xAxisLabelFormatter,
    this.onBarTap,
    this.barTooltipBuilder,
    this.yAxisMargin = 30,
    this.xAxisMargin = 30,
  }) : super(key: key);

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  Offset? _tapPosition;
  BarChartData? _selectedBar;

  double tooltipWidth = 160.0;
  double tooltipHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.title != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      widget.title!,
                      style: widget.titleStyle ??
                          const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                  ),
                Expanded(
                  child: GestureDetector(
                    onTapDown: (details) {
                      setState(() {
                        _tapPosition = details.localPosition;
                        _selectedBar = _detectTappedBar(
                          details.localPosition,
                          constraints.maxWidth,
                          constraints.maxHeight,
                        );
                      });

                      if (_selectedBar != null && widget.onBarTap != null) {
                        widget.onBarTap!(_selectedBar!);
                      }
                    },
                    child: CustomPaint(
                      size: Size(
                        constraints.maxWidth.toDouble(),
                        constraints.maxHeight.toDouble(),
                      ),
                      painter: BarChartPainter(
                        widget.data,
                        spacing: widget.spacing,
                        xAxisLabelStyle: widget.xAxisLabelStyle,
                        yAxisLabelStyle: widget.yAxisLabelStyle,
                        xAxisLabelFormatter: widget.xAxisLabelFormatter,
                        yAxisLabelFormatter: widget.yAxisLabelFormatter,
                        xAxisMargin: widget.xAxisMargin,
                        yAxisMargin: widget.yAxisMargin,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_selectedBar != null && _tapPosition != null)
              Positioned(
                left: () {
                  final dx = _tapPosition!.dx;
                  final maxLeft =
                      constraints.maxWidth.toDouble() - tooltipWidth;
                  if (dx + tooltipWidth > constraints.maxWidth) return maxLeft;
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
                  child: Container(
                    width: tooltipWidth,
                    child: _getDefaultTooltip(_selectedBar!),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _getDefaultTooltip(BarChartData bar) {
    // Caso o usuário tenha definido um builder personalizado
    if (widget.barTooltipBuilder != null) {
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
          widget.barTooltipBuilder!(bar),
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      );
    }

    // Caso contrário, usa o padrão
    final label = bar.label;
    late final String labelText;

    if (label is List<String>) {
      labelText = label.join(' ');
    } else if (label is String) {
      labelText = label;
    } else {
      labelText = label.toString();
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
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: bar.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${bar.value}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BarChartData? _detectTappedBar(Offset position, double width, double height) {
    final double yAxisX = 40;
    final double xAxisY = height - 30;
    final double availableWidth = width - yAxisX - widget.spacing;
    final double totalSpacing = widget.spacing * (widget.data.length + 1);
    final double barWidth =
        (availableWidth - totalSpacing) / widget.data.length;
    final double finalBarWidth = barWidth < 8 ? 8 : barWidth;
    final maxValue =
        widget.data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    double x = yAxisX + widget.spacing;

    for (var item in widget.data) {
      final double barHeight =
          maxValue == 0 ? 0 : (item.value / maxValue) * (xAxisY - 10);

      Rect barRect = Rect.fromLTWH(
        x,
        xAxisY - barHeight,
        finalBarWidth,
        barHeight,
      );

      if (barRect.inflate(15).contains(position)) {
        return item;
      }

      x += finalBarWidth + widget.spacing;
    }

    return null;
  }
}
