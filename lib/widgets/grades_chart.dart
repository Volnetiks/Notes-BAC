import 'package:bac_note/extensions/hex_color.dart';
import 'package:bac_note/models/grade.dart';
import 'package:bac_note/models/note.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GradesChart extends StatefulWidget {
  final List<Note> grades;

  const GradesChart({required this.grades});

  @override
  _GradesChartState createState() => _GradesChartState();
}

class _GradesChartState extends State<GradesChart> {
  @override
  Widget build(BuildContext context) {
    List<FlSpot> values = [];
    List<Note> grades = widget.grades;

    grades.sort((a, b) => a.date.compareTo(b.date));

    List<Color> gradientColors = [
      HexColor.fromHex("#28a5d5").withOpacity(0.3),
      HexColor.fromHex("#5fa2c0").withOpacity(0.3),
      Theme.of(context).scaffoldBackgroundColor.withOpacity(0)
    ];

    double averageGrade = 0;
    double lowestGrade = 20;

    for (int i = 0; i < grades.length; i++) {
      values.add(FlSpot(11 / (grades.length - 1) * i, grades[i].note));

      averageGrade += (grades[i].note);
      if (lowestGrade > grades[i].note) {
        lowestGrade = grades[i].note;
      }
    }

    averageGrade /= grades.length;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 13),
          child: Text(
              "Note moyenne: " +
                  (averageGrade.isNaN
                      ? "Aucune notes"
                      : averageGrade.toStringAsFixed(2)),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Theme.of(context).primaryColor)),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: AspectRatio(
            aspectRatio: 1.70,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  color: Theme.of(context).scaffoldBackgroundColor),
              child: Padding(
                padding: EdgeInsets.only(right: 18, top: 24, bottom: 12),
                child: LineChart(mainData(values, lowestGrade, gradientColors)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData(
      List<FlSpot> values, double lowestGrade, List<Color> gradientColors) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
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
          border: Border(
            bottom: BorderSide(color: const Color(0xff37434d), width: 1),
          )),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 21,
      lineBarsData: [
        LineChartBarData(
          spots: values,
          isCurved: true,
          colors: [HexColor.fromHex("#28a5d5"), HexColor.fromHex("#5fa2c0")],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            applyCutOffY: true,
            cutOffY: lowestGrade,
            show: true,
            gradientFrom: Offset(1, 0),
            gradientTo: Offset(1, 1),
            gradientColorStops: [0.15],
            colors: gradientColors,
          ),
        ),
      ],
    );
  }
}
