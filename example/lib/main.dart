import 'package:easy_flutter_charts/models/line_chart_series.dart';
import 'package:flutter/material.dart';
import 'package:easy_flutter_charts/easy_flutter_charts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ChartTabsPage(),
    );
  }
}

class ChartTabsPage extends StatelessWidget {
  const ChartTabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Exemplos de Gráficos'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Bar Chart'),
              Tab(text: 'Line Chart'),
              Tab(text: 'Pie Chart'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BarChartTab(),
            LineChartTab(),
            PieChartTab(),
          ],
        ),
      ),
    );
  }
}

class BarChartTab extends StatelessWidget {
  const BarChartTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 400,
        width: 600,
        child: BarChart(
          title: 'Vendas por país',
          titleStyle: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          data: [
            BarChartData(label: 'Alemanha', value: 50, color: Colors.blue),
            BarChartData(label: 'Brasil', value: 80, color: Colors.red),
            BarChartData(label: 'Camarões', value: 30, color: Colors.green),
            BarChartData(label: 'Dinamarca', value: 70, color: Colors.orange),
            BarChartData(
              label: ['Estados', 'Unidos', 'da América'],
              value: 100,
              color: Colors.orange,
            ),
            BarChartData(label: 'China', value: 25.5, color: Colors.green),
          ],
          // yAxisLabelStyle: const TextStyle(fontSize: 10, color: Colors.red),
          // xAxisLabelStyle: const TextStyle(
          //   fontSize: 10,
          //   fontWeight: FontWeight.bold,
          // ),
          yAxisLabelFormatter: (v) => 'R\$ ${v.toStringAsFixed(2)}',
          xAxisLabelFormatter: (label) => label.toString().toUpperCase(),
          // yAxisMargin: 60,
          // onBarTap: (bar) {
          //   print('Barra clicada: ${bar.label}, valor: ${bar.value}');
          // },
          // barTooltipBuilder: (bar) =>
          //     '${bar.label}: ${bar.value.toStringAsFixed(2)}',
        ),
      ),
    );
  }
}

class LineChartTab extends StatelessWidget {
  const LineChartTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300,
        width: 600,
        child: LineChart(
          title: 'Temperatura Diária',
          titleStyle: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          series: [
            LineChartSeries(
              name: 'Máxima',
              color: Colors.red,
              data: [
                LineChartData(label: 'Seg', value: 30),
                LineChartData(label: 'Ter', value: 32),
                LineChartData(label: 'Qua', value: 31),
                LineChartData(label: 'Qui', value: 33),
                LineChartData(label: 'Sex', value: 29),
              ],
            ),
            LineChartSeries(
              name: 'Média',
              color: Colors.orange,
              data: [
                LineChartData(label: 'Seg', value: 27),
                LineChartData(label: 'Ter', value: 25),
                LineChartData(label: 'Qua', value: 21),
                LineChartData(label: 'Qui', value: 23),
                LineChartData(label: 'Sex', value: 29),
              ],
            ),
            LineChartSeries(
              name: 'Mínima',
              color: Colors.blue,
              data: [
                LineChartData(label: 'Seg', value: 20),
                LineChartData(label: 'Ter', value: 21),
                LineChartData(label: 'Qua', value: 19),
                LineChartData(label: 'Qui', value: 22),
                LineChartData(label: 'Sex', value: 29),
              ],
            ),
          ],
          yAxisLabelFormatter: (v) => '${v.toStringAsFixed(0)}°C',
          yAxisLabelStyle: TextStyle(fontSize: 10),
          xAxisLabelFormatter: (label) => label.toString(),
          xAxisLabelStyle: TextStyle(fontSize: 10),
          showDots: true,
          showGrid: true,
          // lineTooltipBuilder: (point) =>
          //     'Dia ${point.label}: ${point.value} °C',
        ),
      ),
    );
  }
}

class PieChartTab extends StatelessWidget {
  const PieChartTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PieChart(
        title: 'Distribuição de Vendas',
        data: [
          PieChartData(label: 'Brasil', value: 60, color: Colors.green),
          PieChartData(label: 'Alemanha', value: 76, color: Colors.blue),
          PieChartData(label: 'Japão', value: 90, color: Colors.red),
          PieChartData(label: 'EUA', value: 150, color: Colors.orange),
        ],
        aspectRatio: 3,
        // legendPosition: LegendPosition.top,
        pieTooltipBuilder: (data) =>
            '${data.label}: ${data.value.toStringAsFixed(1)} unidades',
      ),
    );
  }
}
