import 'package:flutter/material.dart';
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

  double grade = 15.68;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 250.0,
                lineWidth: 17.0,
                animation: true,
                animationDuration: 700,
                percent: grade * 5 / 100,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$grade', style: const TextStyle(fontSize: 40)),
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
            ],
          ),
        ],
      ),
    );
  }
}
