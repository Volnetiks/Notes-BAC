import 'package:bac_note/extensions/string.dart';
import 'package:bac_note/models/grade.dart';
import 'package:bac_note/models/note.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';

class GradeTile extends StatefulWidget {
  final Note grade;
  const GradeTile({required this.grade});

  @override
  _GradeTileState createState() => _GradeTileState();
}

class _GradeTileState extends State<GradeTile> {
  @override
  Widget build(BuildContext context) {
    Note grade = widget.grade;

    initializeDateFormatting('fr_FR', null);

    return AnimatedContainer(
      duration: Duration(milliseconds: 1500),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Theme.of(context).unselectedWidgetColor.withOpacity(0.2),
          border: Border.all(
              color: Theme.of(context).disabledColor.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                    grade.devoir.toLowerCase().capitalize().replaceAll("_", ""),
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
            grade.codeMatiere,
            overflow: TextOverflow.ellipsis,
            maxLines: 10,
            style: TextStyle(color: Colors.grey, height: 1.3, fontSize: 12),
          ),
          SizedBox(
            height: 5,
          ),
          Row(children: [
            Text(
              grade.date,
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
            Flexible(fit: FlexFit.tight, child: SizedBox()),
            Text(
              grade.note.toStringAsFixed(2),
              style: TextStyle(
                  color: grade.note > (grade.noteSur / 2)
                      ? Colors.blue
                      : Colors.red[400],
                  fontSize: 11),
            ),
            LinearPercentIndicator(
              width: 80.0,
              lineHeight: 4.0,
              percent: grade.note / grade.noteSur,
              progressColor: grade.note > (grade.noteSur / 2)
                  ? Colors.blue
                  : Colors.red[500],
            )
          ])
        ],
      ),
    );
  }
}
