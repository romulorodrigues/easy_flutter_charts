## 1.2.1

### Changed

- Updated screenshots in the README and documentation to reflect the latest UI changes and chart improvements.

## 1.2.0

### Added

- New `AreaChart` component for visualizing data with smooth filled curves and multiple series support.

## 1.1.0

### Added

- New `RadialBarChart` component for visualizing data in radial bar chart format.

## 1.0.11

### Added

- Support for the `lineTooltipBuilder` function with access to `LineChartSeries` in addition to `LineChartData`, allowing for richer and more customizable tooltips.

## 1.0.10

### Changed

- Dynamic positioning of the `tooltip` based on the actual height in the LineChart.

## 1.0.9

### Added

- Added `yMin` and `yMax` parameters in `LineChart` to allow manual definition of the minimum and maximum values of the Y-axis.

## 1.0.8

### Changed

- Default color of the X and Y axis labels set to black when no style is provided.

### Added

- Top margin of 8px added to X-axis labels for better visual spacing.

## 1.0.7

### Changed

- The `LineChart` tooltip now automatically adapts to the content, including:
  - Multi-line labels;
  - Long texts with automatic line breaks;
  - Automatic vertical expansion without overflow;
  - Maximum width limitation for better responsiveness.
- Improved readability and style of the content displayed in the tooltip.

## 1.0.6

### Added

- Support for multi-line labels on the X-axis in the `LineChart`.
- You can now pass a list of `String` as an item in the `xAxis`, and each line will be displayed vertically stacked (one text below the other).
  ```dart
  xAxis: [
    'Jan',
    ['Fev', '2024'],
    'Mar',
    ['Abr', 'Completo']
  ]
  ```

## 1.0.5

### Updated

- Updated LineChart image in the README.
- Replaced `Container` with `SizedBox` to add visual spacing as recommended by the linter.
- Adjusted string interpolation to follow best practices (`'$var'` → `${var}` when necessary).
- Used `super.key` in constructors to simplify key passing.

## 1.0.4

### Added

- Full support for custom `xAxis` usage in the `LineChart`.
- The `xAxis` property is now **required** in the `LineChart` to ensure consistency in the displayed data.

## 1.0.3

- Reduced the description in `pubspec.yaml`.
- Added `repository:` field in `pubspec.yaml`.
- Replaced `withOpacity(0.2)` with `Color.fromRGBO(128, 128, 128, 0.2)` to remove deprecated API warning.

## 1.0.2

### Added

- Example with images in the README.

## 1.0.1

- README update.

## 1.0.0

- First release.

## 0.0.1

- TODO: Describe initial release.
