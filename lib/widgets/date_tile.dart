import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateTile extends StatefulWidget {
  final days;

  const DateTile({required this.days});

  @override
  _DateTileState createState() => _DateTileState();
}

class _DateTileState extends State<DateTile> {
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fr_FR', null);

    return AnimatedContainer(
      duration: Duration(milliseconds: 1500),
      padding: EdgeInsets.all(15),
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
                  DateFormat('E')
                      .format(DateTime.now().add(Duration(days: widget.days))),
                  style: TextStyle(
                      fontSize: 15, color: Theme.of(context).disabledColor)),
              SizedBox(
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
