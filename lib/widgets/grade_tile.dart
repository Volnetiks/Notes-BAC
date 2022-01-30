import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:bac_note/extensions/string.dart';
import 'package:bac_note/models/grade.dart';

class GradeTile extends StatefulWidget {
  final Note grade;
  const GradeTile({
    Key? key,
    required this.grade,
  }) : super(key: key);

  @override
  _GradeTileState createState() => _GradeTileState();
}

class _GradeTileState extends State<GradeTile> {
  @override
  Widget build(BuildContext context) {
    Note grade = widget.grade;

    initializeDateFormatting('fr_FR', null);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 1500),
      padding: const EdgeInsets.all(15),
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
          const SizedBox(
            height: 5,
          ),
          Text(
            grade.codeMatiere,
            overflow: TextOverflow.ellipsis,
            maxLines: 10,
            style:
                const TextStyle(color: Colors.grey, height: 1.3, fontSize: 12),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(children: [
            Text(
              DateFormat('yMMMd', 'fr_FR').format(grade.date),
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
            const Flexible(fit: FlexFit.tight, child: SizedBox()),
            Text(
              grade.note == -1.0 ? "" : grade.note.toStringAsFixed(2),
              style: TextStyle(
                  color: grade.note > (grade.noteSur / 2)
                      ? Colors.blue
                      : Colors.red[400],
                  fontSize: 11),
            ),
            grade.note == -1.0
                ? Text("Note non définie",
                    style: TextStyle(color: Theme.of(context).disabledColor))
                : LinearPercentIndicator(
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
