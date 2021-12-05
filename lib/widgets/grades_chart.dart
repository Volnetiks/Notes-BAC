import 'package:bac_note/extensions/hex_color.dart';
import 'package:bac_note/models/grade.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GradesChart extends StatefulWidget {
  final List<Grade> grades;

  const GradesChart({required this.grades});

  @override
  _GradesChartState createState() => _GradesChartState();
}

class _GradesChartState extends State<GradesChart> {
  List<Color> gradientColors = [
    HexColor.fromHex("#28a5d5"),
    HexColor.fromHex("#5fa2c0"),
  ];

  List<FlSpot> values = [];

  @override
  Widget build(BuildContext context) {
    double averageGrade = 0;

    for (int i = 0; i < widget.grades.length; i++) {
      print(i);
      values.add(FlSpot(11 / (widget.grades.length - 1) * i,
          widget.grades[i].result / 10 * 2));

      averageGrade += (widget.grades[i].result / 10 * 2);
      print(averageGrade);
    }

    averageGrade /= widget.grades.length;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: AspectRatio(
            aspectRatio: 1.70,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  color: Theme.of(context).scaffoldBackgroundColor),
              child: Padding(
                padding:
                    EdgeInsets.only(right: 18, left: 12, top: 24, bottom: 12),
                child: LineChart(mainData()),
              ),
            ),
          ),
        ),
        SizedBox(
            width: 60,
            height: 34,
            child: Text(averageGrade.toStringAsFixed(2))),
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(color: const Color(0xff37434d), strokeWidth: 1);
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) => TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            print(value.toInt());
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 5:
                return '5';
              case 10:
                return '10';
              case 15:
                return '15';
              case 20:
                return '20';
            }
            return '';
          },
          reservedSize: 32,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 20,
      lineBarsData: [
        LineChartBarData(
          spots: values,
          // spots: const [
          //   FlSpot(0, 10),
          //   FlSpot(2.6, 3.5751),
          //   FlSpot(4.9, 15.44),
          //   FlSpot(6.8, 13.44),
          //   FlSpot(8, 9.44),
          //   FlSpot(9.5, 17.44),
          //   FlSpot(11, 6.44),
          // ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
