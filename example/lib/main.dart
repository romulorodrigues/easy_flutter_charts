import 'package:easy_flutter_charts/models/area_chart_series.dart';
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
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Exemplos de Gráficos'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Bar Chart'),
              Tab(text: 'Line Chart'),
              Tab(text: 'Pie Chart'),
              Tab(text: 'Radial Chart'),
              Tab(text: 'Area Chart'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BarChartTab(),
            LineChartTab(),
            PieChartTab(),
            RadialBarChartTab(),
            AreaChartTab(),
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
          // yAxisLabelFormatter: (v) => 'R\$ ${v.toStringAsFixed(2)}',
          // xAxisLabelFormatter: (label) => label.toString().toUpperCase(),
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
        height: 400,
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
                LineChartData(label: 'Segunda', value: 30),
                LineChartData(label: 'Terça', value: 32),
                LineChartData(label: 'Quarta', value: 31),
                LineChartData(label: 'Quinta', value: 33),
                LineChartData(label: 'Sexta', value: 29),
              ],
            ),
            LineChartSeries(
              name: 'Média',
              color: Colors.orange,
              data: [
                LineChartData(label: 'Segunda', value: 27),
                LineChartData(label: 'Terça', value: 25),
                LineChartData(label: 'Quarta', value: 21),
                LineChartData(label: 'Quinta', value: 29),
              ],
            ),
            LineChartSeries(
              name: 'Mínima',
              color: Colors.blue,
              data: [
                LineChartData(label: 'Segunda', value: 20),
                LineChartData(label: 'Terça', value: 21),
                LineChartData(label: 'Quarta', value: 19),
              ],
            ),
          ],
          yAxisLabelFormatter: (v) => '${v.toStringAsFixed(0)}°C',
          yAxisLabelStyle: TextStyle(fontSize: 10),
          xAxisLabelFormatter: (label) => label.toString(),
          xAxisLabelStyle: TextStyle(fontSize: 10),
          showDots: true,
          showGrid: true,
          xAxis: [
            'Segunda',
            'Terça',
            ['Quarta', 'feira'],
            ['Quinta', 'feira'],
            ['Sexta', 'feira']
          ],
          // lineTooltipBuilder: (serie, point) =>
          //     '${serie.name}: ${point.label}: ${point.value} °C',
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
        titleStyle: const TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        data: [
          PieChartData(label: 'Brasil', value: 60, color: Colors.green),
          PieChartData(label: 'Alemanha', value: 76, color: Colors.blue),
          PieChartData(label: 'Japão', value: 90, color: Colors.red),
          PieChartData(label: 'EUA', value: 150, color: Colors.orange),
        ],
        aspectRatio: 3,
        pieTooltipBuilder: (data) =>
            '${data.label}: ${data.value.toStringAsFixed(1)} unidades',
      ),
    );
  }
}

class RadialBarChartTab extends StatelessWidget {
  const RadialBarChartTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RadialBarChart(
        data: [
          RadialBarData(value: 40, color: Colors.blue, label: 'Azul'),
          RadialBarData(value: 30, color: Colors.green, label: 'Verde'),
          RadialBarData(value: 20, color: Colors.orange, label: 'Laranja'),
          RadialBarData(value: 60, color: Colors.red, label: 'Vermelho'),
        ],
        centerTextBuilder: (data) => '${data.label}\n${data.value} unidades',
        centerTextStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        aspectRatio: 1.5,
      ),
    );
  }
}

class AreaChartTab extends StatelessWidget {
  const AreaChartTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300,
        width: 380,
        child: AreaChart(
          title: 'Lucro Mensal por Região',
          titleStyle: TextStyle(fontWeight: FontWeight.bold),
          xAxis: ['Jan', 'Fev', 'Mar', 'Abr', 'Mai'],
          xAxisLabelStyle: const TextStyle(fontSize: 10, color: Colors.black),
          xAxisLabelFormatter: (label) => label.toString().toUpperCase(),
          series: [
            AreaChartSeries(
              name: 'Norte',
              color: Colors.blue,
              data: [
                AreaChartData(label: 'Janeiro', value: 10),
                AreaChartData(label: 'Fevereiro', value: 45.5),
                AreaChartData(label: 'Março', value: 55.5),
                AreaChartData(label: 'Abril', value: 7),
                AreaChartData(label: 'Maio', value: 10)
              ],
            ),
            AreaChartSeries(
              name: 'Sul',
              color: Colors.green,
              data: [
                AreaChartData(label: 'Janeiro', value: 20),
                AreaChartData(label: 'Fevereiro', value: 23),
                AreaChartData(label: 'Março', value: 32),
                AreaChartData(label: 'Abril', value: 12),
                AreaChartData(label: 'Maio', value: 20)
              ],
            ),
            AreaChartSeries(
              name: 'Nordeste',
              color: Colors.red,
              data: [
                AreaChartData(label: 'Janeiro', value: 30),
                AreaChartData(label: 'Fevereiro', value: 43),
                AreaChartData(label: 'Março', value: 52),
                AreaChartData(label: 'Abril', value: 62),
                AreaChartData(label: 'Maio', value: 30)
              ],
            ),
          ],
          // tooltipBuilder: (serie, data) =>
          //     '${serie.name} - ${data.label}: R\$ ${data.value.toStringAsFixed(2)}',
        ),
      ),
    );
  }
}
