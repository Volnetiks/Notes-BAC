import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
    return Container();
  }

  Future<void> getAverageGrades() async {
    String averagesJSON = await platform.invokeMethod('getAverageGrades');
    try {
      List averages = jsonDecode(averagesJSON);
      averages.removeWhere((element) =>
          element["discipline"] == "Enseignement Général" ||
          element["discipline"] == "Enseignements de spécialité" ||
          element["discipline"] == "Matières facultatives");

      List uniqueAverages = averages
          .map<String>(
              (c) => (c as Map<String, dynamic>)['discipline'] as String)
          .toSet()
          .toList();

      for (var i = 0; i < 9; i++) {
        names[i] = uniqueAverages[i];
      }

      if (uniqueAverages.length < 9) {}
    } catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
    }
  }
}
