import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GradesChart extends StatelessWidget {
  final List<charts.Series<dynamic, DateTime>> seriesList;
  final bool animate;

  const GradesChart(this.seriesList, {this.animate = false});

  factory GradesChart.withSampleData() {
    return GradesChart(
      _createSampleData(),
      animate: false,
    );
  }

  factory GradesChart.withRandomData() {
    return GradesChart(_createRandomData());
  }

  static List<charts.Series<TimeSeriesSales, DateTime>> _createRandomData() {
    final random = Random();

    final data = [
      TimeSeriesSales(DateTime(2017, 9, 19), random.nextInt(100)),
      TimeSeriesSales(DateTime(2017, 9, 26), random.nextInt(100)),
      TimeSeriesSales(DateTime(2017, 10, 3), random.nextInt(100)),
      TimeSeriesSales(DateTime(2017, 10, 10), random.nextInt(100)),
    ];

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      TimeSeriesSales(DateTime(2017, 9, 19), 5),
      TimeSeriesSales(DateTime(2017, 9, 23), 25),
      TimeSeriesSales(DateTime(2017, 9, 24), 40),
      TimeSeriesSales(DateTime(2017, 9, 25), 55),
      TimeSeriesSales(DateTime(2017, 9, 26), 70),
      TimeSeriesSales(DateTime(2017, 9, 27), 85),
      TimeSeriesSales(DateTime(2017, 10, 3), 100),
      TimeSeriesSales(DateTime(2017, 10, 10), 75),
    ];

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
