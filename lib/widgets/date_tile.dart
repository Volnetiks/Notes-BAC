import 'package:bac_note/extensions/string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTile extends StatefulWidget {
  final int days;

  const DateTile({
    Key? key,
    required this.days,
  }) : super(key: key);

  @override
  _DateTileState createState() => _DateTileState();
}

class _DateTileState extends State<DateTile> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1500),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Theme.of(context).unselectedWidgetColor.withOpacity(0.4),
          border: Border.all(
              color: Theme.of(context).unselectedWidgetColor.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: 75,
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  DateFormat('E', 'fr_FR')
                      .format(DateTime.now().add(Duration(days: widget.days)))
                      .capitalize(),
                  style: TextStyle(
                      fontSize: 15, color: Theme.of(context).disabledColor)),
              const SizedBox(
                height: 5,
              ),
              Text(
                  DateFormat("d")
                      .format(DateTime.now().add(Duration(days: widget.days))),
                  style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}
