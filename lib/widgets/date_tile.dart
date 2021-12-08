import 'package:flutter/material.dart';

class DateTile extends StatefulWidget {
  const DateTile({Key? key}) : super(key: key);

  @override
  _DateTileState createState() => _DateTileState();
}

class _DateTileState extends State<DateTile> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).unselectedWidgetColor.withOpacity(0.4),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 1500),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Theme.of(context).unselectedWidgetColor.withOpacity(0.4),
            border: Border.all(
                color:
                    Theme.of(context).unselectedWidgetColor.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(8)),
        child: SizedBox(
          width: 75,
          height: 100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Thu",
                    style: TextStyle(
                        fontSize: 15, color: Theme.of(context).disabledColor)),
                SizedBox(
                  height: 5,
                ),
                Text("6",
                    style: TextStyle(
                        fontSize: 25,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
