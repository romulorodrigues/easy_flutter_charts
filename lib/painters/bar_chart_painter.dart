import 'package:flutter/material.dart';
import '../models/bar_chart_data.dart';

class BarChartPainter extends CustomPainter {
  final List<BarChartData> data;
  final double spacing;
  final TextStyle? yAxisLabelStyle;
  final TextStyle? xAxisLabelStyle;
  final String Function(double value)? yAxisLabelFormatter;
  final String Function(dynamic label)? xAxisLabelFormatter;
  final double? yAxisMargin;
  final double? xAxisMargin;

  BarChartPainter(
    this.data, {
    this.spacing = 20,
    this.yAxisLabelStyle,
    this.xAxisLabelStyle,
    this.yAxisLabelFormatter,
    this.xAxisLabelFormatter,
    this.yAxisMargin = 30,
    this.xAxisMargin = 30,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Pincel para desenhar as barras
    final paint = Paint()..style = PaintingStyle.fill;

    // Pincel para os eixos X e Y
    final axisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    // Altura e largura total do gráfico (área disponível)
    final double chartHeight = size.height;
    final double chartWidth = size.width;

    // Quantidade de divisões do eixo Y (linhas de referência)
    const int divisions = 5;
    const double topMargin = 10;

    // Calcula altura do maior texto do eixo Y
    double yMargin = yAxisMargin ??
        (() {
          final textPainter = TextPainter(
            textAlign: TextAlign.right,
            textDirection: TextDirection.ltr,
          );
          double maxWidth = 0;
          final maxValue =
              data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
          final double step = maxValue / divisions;
          for (int i = 0; i <= divisions; i++) {
            final label = yAxisLabelFormatter != null
                ? yAxisLabelFormatter!(step * i)
                : (step * i).round().toString();
            textPainter.text = TextSpan(
              text: label,
              style: yAxisLabelStyle ?? const TextStyle(fontSize: 10),
            );
            textPainter.layout();
            if (textPainter.width > maxWidth) maxWidth = textPainter.width;
          }
          return maxWidth + topMargin;
        })();

    double xMargin = xAxisMargin ??
        (() {
          final textPainter = TextPainter(
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          );
          double maxHeight = 0;
          for (var item in data) {
            final labels = item.label is List ? item.label : [item.label];
            for (var label in labels) {
              final text = xAxisLabelFormatter != null
                  ? xAxisLabelFormatter!(label)
                  : label.toString();
              textPainter.text = TextSpan(
                text: text,
                style: xAxisLabelStyle ?? const TextStyle(fontSize: 12),
              );
              textPainter.layout();
              maxHeight += textPainter.height;
            }
          }
          return maxHeight + topMargin;
        })();

    final double yAxisX = yMargin;
    final double xAxisY = chartHeight - xMargin;

    // Largura disponível para as barras (descontando margem e espaçamento)
    final double availableWidth = chartWidth - yAxisX - spacing;

    // Espaço total entre as barras
    final double totalSpacing = spacing * (data.length + 1);

    // Largura inicial de cada barra
    final double barWidth = (availableWidth - totalSpacing) / data.length;

    // Largura mínima para não deixar a barra muito fina
    final double minBarWidth = 8;
    final double finalBarWidth =
        barWidth < minBarWidth ? minBarWidth : barWidth;

    // Desenha o eixo Y (linha vertical)
    canvas.drawLine(
      Offset(yAxisX, 0),
      Offset(yAxisX, xAxisY),
      axisPaint,
    );

    // Desenha o eixo X (linha horizontal)
    canvas.drawLine(
      Offset(yAxisX, xAxisY),
      Offset(chartWidth, xAxisY),
      axisPaint,
    );

    // Encontra o maior valor entre as barras (para escalar)
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    // Objeto para desenhar texto (usado nos labels)
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Posição horizontal inicial para desenhar a primeira barra
    double x = yAxisX + spacing;

    // Pincel para desenhar a grade (linhas de fundo)
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    // Linhas horizontais (grade do eixo Y)
    for (int i = 0; i <= divisions; i++) {
      final double y = xAxisY - ((i * (xAxisY - topMargin)) / divisions);
      canvas.drawLine(
        Offset(yAxisX, y),
        Offset(chartWidth, y),
        gridPaint,
      );
    }

    // Linhas verticais (grade atrás das barras)
    double xGrid = yAxisX + spacing;
    for (var _ in data) {
      canvas.drawLine(
        Offset(xGrid + (finalBarWidth / 2), 0),
        Offset(xGrid + (finalBarWidth / 2), xAxisY),
        gridPaint,
      );
      xGrid += finalBarWidth + spacing;
    }

    // Desenha cada barra
    for (var item in data) {
      // Calcula altura proporcional da barra com base no valor e altura máxima
      final barHeight =
          maxValue == 0 ? 0 : (item.value / maxValue) * (xAxisY - topMargin);

      // Desenha o retângulo da barra
      paint.color = item.color;
      canvas.drawRect(
        Rect.fromLTWH(
          x.toDouble(),
          (xAxisY - barHeight).toDouble(),
          finalBarWidth.toDouble(),
          barHeight.toDouble(),
        ),
        paint,
      );

      // Renderização do label
      if (item.label is String) {
        final labelText = xAxisLabelFormatter != null
            ? xAxisLabelFormatter!(item.label)
            : item.label.toString();

        textPainter.text = TextSpan(
          text: labelText,
          style: xAxisLabelStyle ??
              const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
        );

        textPainter.layout(maxWidth: finalBarWidth);

        // Desenha o texto centralizado abaixo da barra
        textPainter.paint(
          canvas,
          Offset(
            x + (finalBarWidth / 2) - (textPainter.width / 2),
            xAxisY + 5,
          ),
        );
      } else if (item.label is List<String>) {
        double labelY = xAxisY + 5;
        for (String line in item.label) {
          final labelText = xAxisLabelFormatter != null
              ? xAxisLabelFormatter!(line)
              : line.toString();
          textPainter.text = TextSpan(
            text: labelText,
            style: xAxisLabelStyle ??
                const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
          );
          textPainter.layout(maxWidth: finalBarWidth);

          // Desenha cada linha abaixo da outra
          textPainter.paint(
            canvas,
            Offset(
              x + (finalBarWidth / 2) - (textPainter.width / 2),
              labelY,
            ),
          );
          labelY += textPainter.height;
        }
      }

      // Avança a posição para a próxima barra
      x += finalBarWidth + spacing;
    }

    // Desenha os valores de referência no eixo Y
    final double step = maxValue / divisions;
    for (int i = 0; i <= divisions; i++) {
      final double y = xAxisY - ((i * (xAxisY - topMargin)) / divisions);
      final label = yAxisLabelFormatter != null
          ? yAxisLabelFormatter!(step * i)
          : (step * i).round().toString();

      textPainter.text = TextSpan(
        text: label,
        style: yAxisLabelStyle ??
            const TextStyle(
              color: Colors.black,
              fontSize: 10,
            ),
      );
      textPainter.layout();

      // Desenha o número no lado esquerdo do gráfico
      textPainter.paint(canvas, Offset(0, y - textPainter.height / 2));

      // Traço pequeno na linha do eixo Y (marca de divisão)
      canvas.drawLine(
        Offset(yAxisX - 4, y),
        Offset(yAxisX, y),
        axisPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
