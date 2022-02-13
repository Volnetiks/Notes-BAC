import 'dart:convert';

import 'package:bac_note/log/logdna.dart';
import 'package:bac_note/log/models/dna_line.dart';
import 'package:bac_note/models/grade.dart';
import 'package:bac_note/widgets/coefficient_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:bac_note/utils/platform_utils.dart' as platform_utils;
import '../utils/secrets.dart' as secrets;

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

  double bacNote = -1.0;

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
            child: grades.isNotEmpty
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
                                percent: bacNote * 5 / 100,
                                center: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(bacNote.toStringAsFixed(2),
                                        style: const TextStyle(fontSize: 30)),
                                    Text(getMention(bacNote),
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).disabledColor,
                                            fontSize: 17))
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
                                              coefficient: coefficients[index],
                                              grade: grades
                                                      .asMap()
                                                      .containsKey(index)
                                                  ? double.parse(grades[index]
                                                      .toStringAsFixed(2))
                                                  : -1.0),
                                          updateGrade: updateGrade,
                                        );
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
    try {
      String averagesJSON = await platform.invokeMethod('getAverageGrades');

      Map<String, dynamic> averagesData = jsonDecode(averagesJSON);
      List averages = averagesData["data"];

      LogDNA logDNA = LogDNA(
          apiKey: secrets.logDNAApiKey,
          hostName: "bac_note",
          appName: "AppBAC");

      String deviceInfo = await platform_utils.getOSVersionAndModel();

      logDNA.log(DnaLine(
          timestamp: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
          line: deviceInfo,
          level: DnaLevel.debug,
          env: DnaEnv.production,
          app: "AppBAC"));

      logDNA.log(DnaLine(
          timestamp: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
          line: averages.toString(),
          level: DnaLevel.error,
          env: DnaEnv.production));

      for (var i = 0; i < 9; i++) {
        names[i] =
            averages[i]["matiere"].toLowerCase().toString().toTitleCase();
        grades.insert(i, averages[i]["moyenne"].toDouble());
      }

      if (averages.length > 9) {
        for (var i = 9; i < averages.length; i++) {
          names.insert(
              i, averages[i]["matiere"].toLowerCase().toString().toTitleCase());
          coefficients.insert(i, 2);
          grades.insert(i, averages[i]["moyenne"].toDouble());
        }
      }

      double totalGrades = 0.0;
      double totalCoefficients = 0.0;

      for (int i = 0; i < grades.length; i++) {
        totalGrades += grades[i] * coefficients[i];
        totalCoefficients += coefficients[i];
      }

      setState(() {
        bacNote = totalGrades / totalCoefficients;
      });
    } catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
    }
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

  Future<void> updateGrade(AverageGrade averageGrade) async {
    int indexForValues =
        names.indexWhere((element) => element == averageGrade.name);

    coefficients[indexForValues] = averageGrade.coefficient;

    double totalGrades = 0.0;
    double totalCoefficients = 0.0;

    for (int i = 0; i < grades.length; i++) {
      totalGrades += grades[i] * coefficients[i];
      totalCoefficients += coefficients[i];
    }

    setState(() {
      bacNote = totalGrades / totalCoefficients;
    });
  }
}
