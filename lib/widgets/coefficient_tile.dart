import 'package:flutter/material.dart';

import 'package:bac_note/models/grade.dart';

class CoefficientTile extends StatefulWidget {
  final AverageGrade averageGrade;

  const CoefficientTile({Key? key, required this.averageGrade})
      : super(key: key);

  @override
  _CoefficientTileState createState() => _CoefficientTileState();
}

class _CoefficientTileState extends State<CoefficientTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1500),
        padding: const EdgeInsets.all(15),
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
                  widget.averageGrade.name,
                  style: TextStyle(
                      fontSize: 12, color: Theme.of(context).disabledColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Note: ",
                        style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold)),
                    Text(widget.averageGrade.grade.toString(),
                        style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold))
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text("Coefficient:",
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold)),
                Text(widget.averageGrade.coefficient.toString(),
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
