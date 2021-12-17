import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class GradeScreen extends StatefulWidget {
  const GradeScreen({Key? key}) : super(key: key);

  @override
  _GradeScreenState createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradeScreen> {
  Map<String, double> dataMap = {
    "Histoire-Geographie": 6,
    "LVA": 6,
    "LVB": 6,
    "Enseignement scientifique": 6,
    "Enseignement de spécialité de 1re": 8,
    "EPS": 6,
    "EMC": 2,
    "Spécialité 1": 16,
    "Spécialité 2": 16,
    "Oral de français": 5,
    "Ecrit de français": 5,
    "Philosophie": 8,
    "Grand Oral": 10,
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: PieChart(
        dataMap: dataMap,
        initialAngleInDegree: 0,
        animationDuration: Duration(milliseconds: 1000),
        chartType: ChartType.ring,
        chartRadius: MediaQuery.of(context).size.width / 3.2,
        ringStrokeWidth: 32,
        chartLegendSpacing: 32,
        chartValuesOptions: const ChartValuesOptions(
          showChartValuesOutside: true,
          showChartValueBackground: false,
          showChartValues: false,
          chartValueStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        legendOptions: const LegendOptions(
            showLegendsInRow: false,
            showLegends: false,
            legendShape: BoxShape.circle,
            legendPosition: LegendPosition.right,
            legendTextStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}
