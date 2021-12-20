import 'package:bac_note/models/grade.dart';
import 'package:bac_note/widgets/coefficient_dialog.dart';
import 'package:flutter/material.dart';

class CoefficientTile extends StatefulWidget {
  final Grade grade;

  const CoefficientTile({required this.grade});

  @override
  _CoefficientTileState createState() => _CoefficientTileState();
}

class _CoefficientTileState extends State<CoefficientTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(context: context, builder: (context) => CoefficientDialog());
      },
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.grade.name,
                  style: TextStyle(
                      fontSize: 12, color: Theme.of(context).disabledColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5,
                ),
                Text("Coefficient ${widget.grade.coefficient}",
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 5,
                ),
                Text("Note actuelle:",
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold)),
                Text(widget.grade.grade.toString(),
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).disabledColor,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
