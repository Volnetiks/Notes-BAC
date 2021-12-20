import 'dart:convert';

import 'package:bac_note/models/grade.dart';
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
  List<double> coefficients = [
    6,
    6,
    6,
    6,
    8,
    6,
    2,
    16,
    16,
    5,
    5,
    8,
    10,
  ];

  List<String> names = [
    "Histoire-Geographie",
    "LVA",
    "LVB",
    "Enseignement scientifique",
    "Enseignement de spécialité de 1re",
    "EPS",
    "EMC",
    "Spécialité 1",
    "Spécialité 2",
    "Oral de français",
    "Ecrit de français",
    "Philosophie",
    "Grand Oral",
  ];

  List<Grade> grades =
      List.filled(13, Grade(coefficient: 0, name: "", grade: 0));

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
      resizeToAvoidBottomInset: false,
      body: grade == -1
          ? Center(
              child: Text(
                "Aucun résultat.",
                style: TextStyle(
                    fontSize: 25, color: Theme.of(context).disabledColor),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Row(
                children: [
                  Column(
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
                        backgroundColor:
                            Theme.of(context).unselectedWidgetColor,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 10),
                          child: StaggeredGridView.countBuilder(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: names.length,
                              itemBuilder: (context, index) {
                                return CoefficientTile(grade: grades[index]);
                              },
                              staggeredTileBuilder: (int index) {
                                return StaggeredTile.fit(1);
                              }),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
    );
  }

  Future<void> getNotes() async {
    double totalCoefficients = 0;
    double totalGrade = 0;
    String noteJSON = await platform.invokeMethod('getAverage');
    List averages = jsonDecode(noteJSON);
    averages.removeWhere((element) =>
        element["discipline"] == "Enseignement Général" ||
        element["discipline"] == "Enseignement de spécialité" ||
        element["discipline"] == "Matières facultatives");
    for (int i = 0; i < 11; i++) {
      names[i] = averages[i]["discipline"];

      totalCoefficients += coefficients[i];
      totalGrade +=
          double.parse(averages[i]["note"].toString().replaceAll(",", ".")) *
              coefficients[i];

      grades[i] = (Grade(
          coefficient: coefficients[i],
          name: names[i],
          grade: double.parse(
              averages[i]["note"].toString().replaceAll(",", "."))));
    }

    setState(() {
      grade = totalGrade / totalCoefficients;
    });
  }
}
