# easy_flutter_charts

## 📦 Instalação

Adicione o `easy_flutter_charts` ao seu `pubspec.yaml`:

```yaml
dependencies:
  easy_flutter_charts:
    git:
      url: https://github.com/romulorodrigues/easy_flutter_charts.git
```

## BarChart

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
| `barTooltipBuilder`   | `String Function(BarChartData)?`  | Função para construir o texto do tooltip exibido ao tocar na barra.    |
| `yAxisMargin`         | `double`                          | Margem esquerda para exibição dos rótulos do eixo Y (padrão: `30`).    |
| `xAxisMargin`         | `double`                          | Margem inferior para os rótulos do eixo X (padrão: `30`).              |

## LineChart

| Propriedade           | Tipo                              | Descrição                                                                                                               |
| --------------------- | --------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `series`              | `List<LineChartSeries>`           | Lista de séries (linhas) a serem desenhadas no gráfico. Cada série representa uma linha com seus próprios pontos e cor. |
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
| `lineTooltipBuilder`  | `String Function(LineChartData)?` | Função que retorna o conteúdo do tooltip ao tocar em um ponto.                                                          |
| `dotRadius`           | `double`                          | Define o raio dos pontos visíveis (se `showDots` for `true`) (padrão: `4.0`).                                           |
| `strokeWidth`         | `double`                          | Espessura da linha desenhada no gráfico (padrão: `2.0`).                                                                |
