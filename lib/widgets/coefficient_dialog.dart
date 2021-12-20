import 'package:bac_note/extensions/hex_color.dart';
import 'package:bac_note/extensions/string.dart';
import 'package:bac_note/models/cours.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoefficientDialog extends StatefulWidget {
  @override
  _CoefficientDialogState createState() => _CoefficientDialogState();
}

class _CoefficientDialogState extends State<CoefficientDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  DateFormat format = DateFormat.Hm();

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: SizedBox(
            height: 250,
            width: 250,
            child: Container(
              decoration: ShapeDecoration(
                  color: Theme.of(context).unselectedWidgetColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0))),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Matiere",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Evaluation date",
                        style:
                            TextStyle(color: Theme.of(context).disabledColor)),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.grading_rounded,
                          color: HexColor.fromHex("#868fca"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Note actuelle",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColor)),
                            SizedBox(height: 2),
                            Text("note",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).disabledColor))
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.grading_rounded,
                          color: HexColor.fromHex("#868fca"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 150,
                          height: 25,
                          child: TextField(
                            onChanged: (val) {},
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 10, 20, 10),
                              hintText: 'Note',
                              hintStyle: TextStyle(
                                fontSize: 19,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.school_outlined,
                          color: HexColor.fromHex("#868fca"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Professeur",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColor)),
                            SizedBox(height: 2),
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
        ),
      ),
    );
  }
}
