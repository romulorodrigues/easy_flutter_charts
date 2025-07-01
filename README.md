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

O widget BarChart oferece várias propriedades para personalização:

| Propriedade           | Tipo                              | Descrição                                                              |
| --------------------- | --------------------------------- | ---------------------------------------------------------------------- |
| `data`                | `List<BarChartData>`              | Lista de objetos que representam os dados a serem exibidos no gráfico. |
| `spacing`             | `double`                          | Espaçamento horizontal entre as barras (padrão: `20`).                 |
| `title`               | `String?`                         | Título do gráfico exibido acima das barras.                            |
| `titleStyle`          | `TextStyle?`                      | Estilo do texto do título.                                             |
| `xAxisLabelStyle`     | `TextStyle?`                      | Estilo do texto dos rótulos do eixo X.                                 |
| `yAxisLabelStyle`     | `TextStyle?`                      | Estilo do texto dos rótulos do eixo Y.                                 |
| `yAxisLabelFormatter` | `String Function(double value)?`  | Função para formatar os valores exibidos no eixo Y.                    |
| `xAxisLabelFormatter` | `String Function(dynamic label)?` | Função para formatar os rótulos exibidos no eixo X.                    |
| `onBarTap`            | `void Function(BarChartData)?`    | Callback disparado ao tocar em uma barra específica.                   |
| `barTooltipBuilder`   | `String Function(BarChartData)?`  | Função para construir o texto do tooltip exibido ao tocar na barra.    |
| `yAxisMargin`         | `double`                          | Margem esquerda para exibição dos rótulos do eixo Y (padrão: `30`).    |
| `xAxisMargin`         | `double`                          | Margem inferior para os rótulos do eixo X (padrão: `30`).              |
