import 'package:flutter/material.dart';
import 'area_chart_data.dart';

class AreaChartSeries {
  final String name;
  final Color color;
  final List<AreaChartData> data;

  AreaChartSeries({
    required this.name,
    required this.color,
    required this.data,
  });
}
