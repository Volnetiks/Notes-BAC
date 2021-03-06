import 'package:flutter/material.dart';

import 'package:bac_note/models/grade.dart';

class CoefficientTile extends StatefulWidget {
  final AverageGrade averageGrade;
  final ValueChanged<AverageGrade> updateGrade;

  const CoefficientTile(
      {Key? key, required this.averageGrade, required this.updateGrade})
      : super(key: key);

  @override
  _CoefficientTileState createState() => _CoefficientTileState();
}

class _CoefficientTileState extends State<CoefficientTile> {
  late TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    _controller =
        TextEditingController(text: widget.averageGrade.coefficient.toString());

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
                    Text(
                        widget.averageGrade.grade == -1
                            ? "Aucune"
                            : widget.averageGrade.grade.toString(),
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
                SizedBox(
                  height: 30,
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    // onChanged: (val) {
                    //   val.isEmpty
                    //       ? widget.averageGrade.coefficient = 0.0
                    //       : widget.averageGrade.coefficient =
                    //           double.tryParse(val.replaceAll(",", ".")) == null
                    //               ? 0.0
                    //               : double.parse(val.replaceAll(",", "."));

                    //   widget.updateGrade(widget.averageGrade);
                    // },
                    onSubmitted: (value) {
                      value.isEmpty
                          ? widget.averageGrade.coefficient = 0.0
                          : widget.averageGrade.coefficient =
                              double.tryParse(value.replaceAll(",", ".")) ==
                                      null
                                  ? 0.0
                                  : double.parse(value.replaceAll(",", "."));

                      widget.updateGrade(widget.averageGrade);
                    },
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: const InputDecoration(
                      hintText: 'Coefficient',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
