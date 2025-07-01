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
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Exemplos de Gráficos'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Bar'),
              Tab(text: 'Bar 2'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BarChartTab1(),
            BarChartTab2(),
          ],
        ),
      ),
    );
  }
}

class BarChartTab1 extends StatelessWidget {
  const BarChartTab1({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300,
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
          yAxisLabelStyle: const TextStyle(fontSize: 10, color: Colors.red),
          xAxisLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
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

class BarChartTab2 extends StatelessWidget {
  const BarChartTab2({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300,
        width: 600,
        child: BarChart(
          title: 'Vendas',
          titleStyle: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          data: [
            BarChartData(label: 'Jan', value: 50, color: Colors.blue),
            BarChartData(label: 'Fev', value: 80, color: Colors.red),
            BarChartData(label: 'Mar', value: 30, color: Colors.green),
            BarChartData(label: 'Abr', value: 70, color: Colors.orange),
            BarChartData(label: 'Mai', value: 100, color: Colors.orange),
            BarChartData(label: 'Jun', value: 25.5, color: Colors.green),
            BarChartData(label: 'Jul', value: 35.5, color: Colors.green),
            BarChartData(label: 'Ago', value: 65.5, color: Colors.green),
            BarChartData(label: 'Set', value: 95.5, color: Colors.green),
            BarChartData(label: 'Out', value: 28.5, color: Colors.green),
            BarChartData(label: 'Nov', value: 125.5, color: Colors.green),
            BarChartData(label: 'Dez', value: 3.5, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
