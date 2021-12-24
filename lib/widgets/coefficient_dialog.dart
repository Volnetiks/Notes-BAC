import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:bac_note/extensions/hex_color.dart';
import 'package:bac_note/models/grade.dart';

class CoefficientDialog extends StatefulWidget {
  final Grade grade;

  const CoefficientDialog({
    Key? key,
    required this.grade,
  }) : super(key: key);

  @override
  _CoefficientDialogState createState() => _CoefficientDialogState();
}

class _CoefficientDialogState extends State<CoefficientDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  DateFormat format = DateFormat.Hm();

  late TextEditingController _textEditingController;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();

    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController = TextEditingController(
        text: widget.grade.grade == -1 ? "" : widget.grade.grade.toString());

    return Dialog(
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: 200,
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.grade.name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 5,
                ),
                Text("Evaluation date",
                    style: TextStyle(color: Theme.of(context).disabledColor)),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.grading_rounded,
                      color: HexColor.fromHex("#868fca"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Note actuelle",
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).primaryColor)),
                        const SizedBox(height: 2),
                        Text(
                            widget.grade.grade == -1
                                ? "Note non obtenue"
                                : widget.grade.grade.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).disabledColor))
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.grading_rounded,
                      color: HexColor.fromHex("#868fca"),
                    ),
                    // ignore: prefer_const_constructors
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 150,
                      height: 25,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _textEditingController,
                        onChanged: (val) {
                          widget.grade.grade =
                              double.parse(val.isEmpty ? "0.0" : val);
                        },
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: const InputDecoration(
                          hintText: 'Note',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.school_outlined,
                      color: HexColor.fromHex("#868fca"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Professeur",
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).primaryColor)),
                        const SizedBox(height: 2),
                        Text("Bientôt",
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).disabledColor))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
