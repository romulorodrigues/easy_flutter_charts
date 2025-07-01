import 'package:flutter/material.dart';
import 'line_chart_data.dart';

class LineChartSeries {
  final String name;
  final Color color;
  final List<LineChartData> data;

  LineChartSeries({
    required this.name,
    required this.color,
    required this.data,
  });
}
