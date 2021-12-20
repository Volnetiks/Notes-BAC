import 'dart:convert';

import 'package:bac_note/models/note.dart';
import 'package:bac_note/widgets/coefficient_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class GradeScreen extends StatefulWidget {
  const GradeScreen({Key? key}) : super(key: key);

  @override
  _GradeScreenState createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradeScreen> {
  // TODO: Redesign the whole page

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

  double grade = -1;

  static const platform = MethodChannel('samples.volnetiks.dev/ecoledirecte');

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: grade == -1
          ? Center(
              child: Text(
                "Aucun résultat.",
                style: TextStyle(
                    fontSize: 25, color: Theme.of(context).disabledColor),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    CircularPercentIndicator(
                      radius: 250.0,
                      lineWidth: 17.0,
                      animation: true,
                      animationDuration: 700,
                      percent: grade * 5 / 100,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(grade.toStringAsFixed(2),
                              style: const TextStyle(fontSize: 40)),
                          Text("Mention bien",
                              style: TextStyle(
                                color: Theme.of(context).disabledColor,
                              ))
                        ],
                      ),
                      startAngle: 180,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.green.shade500,
                      backgroundColor: Theme.of(context).unselectedWidgetColor,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Flexible(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: StaggeredGridView.countBuilder(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 12,
                              itemCount: dataMap.length,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return CoefficientTile(
                                    name: dataMap.keys.elementAt(index),
                                    coefficient:
                                        dataMap.values.elementAt(index));
                              },
                              staggeredTileBuilder: (int index) {
                                return StaggeredTile.fit(1);
                              }),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
    );
  }

  Future<void> getNotes() async {
    double totalCoefficients = 0;
    double totalGrade = 0;
    String noteJSON = await platform.invokeMethod('getAverage');
    List averages = jsonDecode(noteJSON);
    for (int i = 0; i < averages.length; i++) {
      totalCoefficients += int.parse(averages[i]["coef"]) + 1;
      totalGrade +=
          double.parse(averages[i]["note"].toString().replaceAll(",", "."));
    }

    setState(() {
      grade = totalGrade / totalCoefficients;
    });
  }
}
