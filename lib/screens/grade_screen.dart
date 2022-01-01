import 'dart:convert';

import 'package:bac_note/models/grade.dart';
import 'package:bac_note/widgets/coefficient_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
    2,
    6,
    6,
    8,
    16,
    16,
    8,
    5,
    5,
    10,
  ];

  List<String> names = [
    "LVA",
    "LVB",
    "Histoire-Geographie",
    "EMC",
    "Enseignement scientifique",
    "EPS",
    "Philosophie",
    "Spécialité 1",
    "Spécialité 2",
    "Enseignement de spécialité de 1re",
    "Oral de français",
    "Ecrit de français",
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

  void updateGrade(Grade newGrade) {
    int index = grades.indexWhere((Grade grade) => grade.name == newGrade.name);

    double totalGrade = 0.0;
    double totalCoefficients = 0.0;

    grades[index] == newGrade;
    for (int i = 0; i < grades.length; i++) {
      if (grades[i].grade != -1.0) {
        totalGrade += (grades[i].grade * grades[i].coefficient);
        totalCoefficients += grades[i].coefficient;
      }
    }

    setState(() {
      grade = totalGrade / totalCoefficients;
    });
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
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  Column(
                    children: [
                      const SizedBox(
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
                            Text(getMention(grade),
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
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          child: StaggeredGridView.countBuilder(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: names.length,
                              itemBuilder: (context, index) {
                                return CoefficientTile(
                                    grade: grades[index],
                                    newGrade: updateGrade);
                              },
                              staggeredTileBuilder: (int index) {
                                return const StaggeredTile.fit(1);
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

  String getMention(double grade) {
    if (grade < 12) {
      return "Aucune mention";
    } else if (grade < 14) {
      return "Mention assez bien";
    } else if (grade < 16) {
      return "Mention bien";
    } else {
      return "Mention très bien";
    }
  }

  Future<void> getNotes() async {
    double totalCoefficients = 0;
    double totalGrade = 0;
    String noteJSON = await platform.invokeMethod('getAverage');
    try {
      List averages = jsonDecode(noteJSON);
      averages.removeWhere((element) =>
          element["discipline"] == "Enseignement Général" ||
          element["discipline"] == "Enseignements de spécialité" ||
          element["discipline"] == "Matières facultatives");
      for (int i = 0; i < averages.length; i++) {
        if (!names.contains(averages[i]["discipline"])) {
          names[i] = averages[i]["discipline"];

          if (double.parse(
                  averages[i]["note"].toString().replaceAll(",", ".")) !=
              -1.0) {
            totalCoefficients += coefficients[i];
            totalGrade += double.parse(
                    averages[i]["note"].toString().replaceAll(",", ".")) *
                coefficients[i];
          }

          grades[i] = (Grade(
              coefficient: coefficients[i],
              name: names[i],
              grade: double.parse(
                  averages[i]["note"].toString().replaceAll(",", "."))));
        } else {
          int index = names
              .indexWhere((element) => element == averages[i]["discipline"]);

          Grade oldGrade = grades[index];
          oldGrade.grade +=
              double.parse(averages[i]["note"].toString().replaceAll(",", "."));
          oldGrade.grade /= 2;
          print(averages[i]["discipline"]);
          print(totalGrade);
          print(totalCoefficients);
        }
      }

      for (int i = 0; i < grades.length; i++) {
        if (grades[i].name == "") {
          grades[i] =
              Grade(coefficient: coefficients[i], name: names[i], grade: -1);
        }
      }

      setState(() {
        grade = totalGrade / totalCoefficients;
      });
    } catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
    }
  }
}
