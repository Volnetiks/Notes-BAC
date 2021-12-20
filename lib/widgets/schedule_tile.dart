import 'package:bac_note/extensions/hex_color.dart';
import 'package:bac_note/extensions/string.dart';
import 'package:bac_note/models/cours.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'class_dialog.dart';

class ScheduleTile extends StatefulWidget {
  final Cours cours;

  ScheduleTile({required this.cours});

  @override
  _ScheduleTileState createState() => _ScheduleTileState();
}

class _ScheduleTileState extends State<ScheduleTile> {
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fr_FR', null);

    DateFormat format = new DateFormat.Hm();

    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => ClassDialog(
                  cours: widget.cours,
                ));
      },
      child: AnimatedContainer(
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
                  child: Text(widget.cours.text.toLowerCase().capitalize(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor)),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(children: [
              Text(
                widget.cours.prof,
                style: TextStyle(color: Colors.grey, height: 1.3, fontSize: 12),
              ),
              Flexible(fit: FlexFit.tight, child: SizedBox()),
              Text(
                widget.cours.isAnnule
                    ? "Cours annulé."
                    : format.format(widget.cours.startDate) +
                        " - " +
                        format.format(widget.cours.endDate),
                style: TextStyle(
                    color: widget.cours.isAnnule
                        ? Colors.red.shade400
                        : HexColor.fromHex("#868fca"),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ]),
            SizedBox(
              height: 5,
            ),
            Text(widget.cours.salle,
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
                style: TextStyle(color: Colors.grey, fontSize: 11))
          ],
        ),
      ),
    );
  }
}
