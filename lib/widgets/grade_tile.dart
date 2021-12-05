import 'package:bac_note/models/grade.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';

class GradeTile extends StatefulWidget {
  final Grade grade;
  const GradeTile({required this.grade});

  @override
  _GradeTileState createState() => _GradeTileState();
}

class _GradeTileState extends State<GradeTile> {
  @override
  Widget build(BuildContext context) {
    Grade grade = widget.grade;

    initializeDateFormatting('fr_FR', null);

    return AnimatedContainer(
      duration: Duration(milliseconds: 1500),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Theme.of(context).unselectedWidgetColor.withOpacity(0.4),
          border: Border.all(color: Theme.of(context).disabledColor),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(grade.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor)),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            grade.grade_class,
            overflow: TextOverflow.ellipsis,
            maxLines: 10,
            style: TextStyle(color: Colors.grey, height: 1.3, fontSize: 12),
          ),
          SizedBox(
            height: 5,
          ),
          Row(children: [
            Text(
              DateFormat('yMMMd', 'fr_FR').format(grade.date),
              // grade.date.toString(),
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
            Flexible(fit: FlexFit.tight, child: SizedBox()),
            Text(
              grade.result.toString() + '%',
              style: TextStyle(
                  color: grade.result > 50 ? Colors.blue : Colors.red[400],
                  fontSize: 11),
            ),
            LinearPercentIndicator(
              width: 70.0,
              lineHeight: 4.0,
              percent: grade.result / 100,
              progressColor: grade.result > 50 ? Colors.blue : Colors.red[500],
            )
          ])
        ],
      ),
    );
  }
}
