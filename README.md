# easy_flutter_charts

easy_flutter_charts é uma biblioteca simples, leve e personalizável para criação de gráficos em Flutter. Ela oferece componentes de gráficos de barras, linhas e pizza, ideais para dashboards, visualizações estatísticas entre outros. Você pode integrar visualizações de dados elegantes e responsivas em poucos minutos.

## 📦 Instalação

Adicione o `easy_flutter_charts` ao seu `pubspec.yaml`:

## BarChart

### Exemplo

![BarChart](https://raw.githubusercontent.com/romulorodrigues/easy_flutter_charts/main/screenshots/bar_chart.jpg)

```yaml
Center(
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
        ),
      ),
    );
```

| Propriedade           | Tipo                              | Descrição                                                              |
| --------------------- | --------------------------------- | ---------------------------------------------------------------------- |
| `data`                | `List<BarChartData>`              | Lista de objetos que representam os dados a serem exibidos no gráfico. |
| `spacing`             | `double`                          | Espaçamento horizontal entre as barras (padrão: `20`).                 |
| `title`               | `String?`                         | Título do gráfico.                                                     |
| `titleStyle`          | `TextStyle?`                      | Estilo do texto do título.                                             |
| `xAxisLabelStyle`     | `TextStyle?`                      | Estilo do texto dos rótulos do eixo X.                                 |
| `yAxisLabelStyle`     | `TextStyle?`                      | Estilo do texto dos rótulos do eixo Y.                                 |
| `yAxisLabelFormatter` | `String Function(double value)?`  | Função para formatar os valores exibidos no eixo Y.                    |
| `xAxisLabelFormatter` | `String Function(dynamic label)?` | Função para formatar os rótulos exibidos no eixo X.                    |
| `onBarTap`            | `void Function(BarChartData)?`    | Callback disparado ao tocar em uma barra específica.                   |
| `barTooltipBuilder`   | `String Function(BarChartData)?`  | Função para personalizar o conteúdo do tooltip ao tocar na barra.      |
| `yAxisMargin`         | `double`                          | Margem esquerda para exibição dos rótulos do eixo Y (padrão: `30`).    |
| `xAxisMargin`         | `double`                          | Margem inferior para os rótulos do eixo X (padrão: `30`).              |

## LineChart

### Exemplo

![LineChart](https://raw.githubusercontent.com/romulorodrigues/easy_flutter_charts/main/screenshots/line_chart.jpg)

```yaml
Center(
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
          xAxis: ['Seg', 'Ter', 'Qua', 'Qui', 'Sex'],
          // lineTooltipBuilder: (point) =>
          //     'Dia ${point.label}: ${point.value} °C',
        ),
      ),
    );
```

| Propriedade           | Tipo                              | Descrição                                                                                                               |
| --------------------- | --------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `series`              | `List<LineChartSeries>`           | Lista de séries (linhas) a serem desenhadas no gráfico. Cada série representa uma linha com seus próprios pontos e cor. |
| `xAxis`               | `List<dynamic>`                   | Obrigatório. Lista de rótulos do eixo X. Define a quantidade de pontos visíveis e seus respectivos rótulos.             |
| `spacing`             | `double`                          | Espaçamento horizontal entre os pontos da linha (padrão: `20`).                                                         |
| `title`               | `String?`                         | Título do gráfico.                                                                                                      |
| `titleStyle`          | `TextStyle?`                      | Estilo do título do gráfico.                                                                                            |
| `xAxisLabelStyle`     | `TextStyle?`                      | Estilo dos rótulos no eixo X.                                                                                           |
| `yAxisLabelStyle`     | `TextStyle?`                      | Estilo dos rótulos no eixo Y.                                                                                           |
| `yAxisLabelFormatter` | `String Function(double value)?`  | Função para formatar os valores do eixo Y.                                                                              |
| `xAxisLabelFormatter` | `String Function(dynamic label)?` | Função para formatar os rótulos do eixo X.                                                                              |
| `onPointTap`          | `void Function(LineChartData)?`   | Callback disparado ao tocar em um ponto da linha.                                                                       |
| `yAxisMargin`         | `double`                          | Margem à esquerda para rótulos do eixo Y (padrão: `30`).                                                                |
| `xAxisMargin`         | `double`                          | Margem inferior para rótulos do eixo X (padrão: `30`).                                                                  |
| `showDots`            | `bool`                            | Exibe ou oculta os pontos nos vértices das linhas (padrão: `true`).                                                     |
| `showGrid`            | `bool`                            | Exibe ou oculta a grade de fundo (padrão: `true`).                                                                      |
| `lineTooltipBuilder`  | `String Function(LineChartData)?` | Função para personalizar o conteúdo do tooltip ao tocar em um ponto.                                                    |
| `dotRadius`           | `double`                          | Define o raio dos pontos visíveis (se `showDots` for `true`) (padrão: `4.0`).                                           |
| `strokeWidth`         | `double`                          | Espessura da linha desenhada no gráfico (padrão: `2.0`).                                                                |

## PieChart

### Exemplo

![PieChart](https://raw.githubusercontent.com/romulorodrigues/easy_flutter_charts/main/screenshots/pie_chart.jpg)

```yaml
Center(
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
```

| Parâmetro           | Tipo                             | Descrição                                                         |
| ------------------- | -------------------------------- | ----------------------------------------------------------------- |
| `data`              | `List<PieChartData>`             | Lista com os dados do gráfico.                                    |
| `title`             | `String?`                        | Título do gráfico.                                                |
| `titleStyle`        | `TextStyle?`                     | Estilo do texto do título.                                        |
| `aspectRatio`       | `double`                         | Relação largura/altura do gráfico. (padrão: `3.0`).               |
| `legendPosition`    | `LegendPosition`                 | Posição da legenda: `top`, `bottom`. (padrão: `bottom`).          |
| `pieTooltipBuilder` | `String Function(PieChartData)?` | Função para personalizar o conteúdo do tooltip ao passar o mouse. |

## 📁 Exemplos

Para exemplos de uso completo com gráficos reais, consulte o diretório /example no repositório.
Lá você encontrará demonstrações práticas de todos os gráficos com suas personalizações e interações.

## 📮 Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir uma issue ou enviar um pull request. 😊

## 📝 Licença

Distribuído sob a licença MIT.
Veja o arquivo LICENSE para mais informações.

## 👨‍💻 Autor

Desenvolvido por Rômulo Rodrigues.
Dúvidas ou sugestões? Abra uma issue.
