import 'dart:convert';

import 'package:bac_note/models/grade.dart';
import 'package:bac_note/widgets/coefficient_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:bac_note/extensions/string.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({Key? key}) : super(key: key);

  @override
  _GradesScreenState createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  static const platform = MethodChannel('samples.volnetiks.dev/ecoledirecte');

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

  List<double> grades = [];

  @override
  void initState() {
    getAverageGrades();
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
        body: SafeArea(
            child: grades.length > 0
                ? SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SafeArea(
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
                                percent: 0.8,
                                center: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("note"),
                                    Text("mention bien",
                                        style: TextStyle(
                                          color:
                                              Theme.of(context).disabledColor,
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: names.length,
                                      itemBuilder: (context, index) {
                                        return CoefficientTile(
                                            averageGrade: AverageGrade(
                                                name: names[index],
                                                coefficient:
                                                    coefficients[index],
                                                grade: grades
                                                        .asMap()
                                                        .containsKey(index)
                                                    ? double.parse(grades[index]
                                                        .toStringAsFixed(2))
                                                    : -1.0));
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
                    )))
                : Center(
                    child: Text(
                      "Aucun résultat.",
                      style: TextStyle(
                          fontSize: 25, color: Theme.of(context).disabledColor),
                    ),
                  )));
  }

  Future<void> getAverageGrades() async {
    String averagesJSON = await platform.invokeMethod('getAverageGrades');

    Map<String, dynamic> averagesData = jsonDecode(averagesJSON);
    List averages = averagesData["data"];
    for (var i = 0; i < 9; i++) {
      names[i] = averages[i]["matiere"].toLowerCase().toString().toTitleCase();
      grades.insert(i, averages[i]["moyenne"].toDouble());
    }

    if (averages.length > 9) {
      print(averages.length);
      for (var i = 9; i < averages.length; i++) {
        names.insert(
            i, averages[i]["matiere"].toLowerCase().toString().toTitleCase());
        coefficients.insert(i, 2);
        grades.insert(i, averages[i]["moyenne"].toDouble());
      }
    }

    for (var name in names) {
      print(name);
    }

    for (var grade in grades) {
      print(grade);
    }

    setState(() {});

    try {
      // List averages = jsonDecode(averagesJSON);
      // averages.removeWhere((element) =>
      //     element["discipline"] == "Enseignement Général" ||
      //     element["discipline"] == "Enseignements de spécialité" ||
      //     element["discipline"] == "Matières facultatives");

      // List<String> uniqueAverages = averages
      //     .map<String>(
      //         (c) => (c as Map<String, dynamic>)['discipline'] as String)
      //     .toSet()
      //     .toList();

      // List<String> uniqueGrades = averages
      //     .map<String>(
      //         (c) => (c as Map<String, dynamic>)['discipline'] as String)
      //     .toSet()
      //     .toList();

      // for (var i = 0; i < 9; i++) {
      //   names[i] = uniqueAverages[i].toLowerCase().toTitleCase();
      // }

      // if (uniqueAverages.length > 9) {
      //   for (var i = 9; i < uniqueAverages.length; i++) {
      //     names.insert(i, uniqueAverages[i].toLowerCase().toTitleCase());
      //     coefficients.insert(i, 2);
      //   }
      // }

      // for (var i = 0; i < averages.length; i++) {
      //   int indexForDiscipline =
      //       names.indexWhere((element) => element == averages[i]["discipline"]);

      //   Iterable values = averages.where((element) =>
      //       element["disciplineId"] == averages[i]["disciplineId"]);

      //   values.forEach((element) {
      //     print(element);
      //   });
      //   print("----------------");

      //   setState(() {});
      // }
    } catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
    }
  }
}