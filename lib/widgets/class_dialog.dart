import 'package:bac_note/extensions/hex_color.dart';
import 'package:bac_note/extensions/string.dart';
import 'package:bac_note/models/cours.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassDialog extends StatefulWidget {
  final Cours cours;

  const ClassDialog({required this.cours});

  @override
  _ClassDialogState createState() => _ClassDialogState();
}

class _ClassDialogState extends State<ClassDialog>
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
    DateFormat dayFormat = DateFormat.EEEE("FR_fr");

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
                    Text(widget.cours.text.toLowerCase().capitalize(),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                        DateTime.now().day == widget.cours.startDate.day
                            ? "Aujourd'hui"
                            : dayFormat
                                .format(widget.cours.startDate)
                                .capitalize(),
                        style:
                            TextStyle(color: Theme.of(context).disabledColor)),
                    SizedBox(
                      height: 5,
                    ),
                    widget.cours.isAnnule
                        ? Text(
                            "Cours annulé.",
                            style: TextStyle(color: Colors.red.shade400),
                          )
                        : RichText(
                            text: TextSpan(
                                text: 'De ',
                                style: TextStyle(
                                    color: Theme.of(context).disabledColor),
                                children: [
                                TextSpan(
                                    text: format
                                        .format(widget.cours.startDate)
                                        .replaceAll(":", "h"),
                                    style: TextStyle(
                                        color: HexColor.fromHex("#868fca"))),
                                TextSpan(text: ' à '),
                                TextSpan(
                                    text: format
                                        .format(widget.cours.endDate)
                                        .replaceAll(":", "h"),
                                    style: TextStyle(
                                        color: HexColor.fromHex("#868fca"))),
                              ])),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: HexColor.fromHex("#868fca"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.cours.salle,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColor)),
                            SizedBox(height: 2),
                            Text("Salle",
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
                          Icons.school_outlined,
                          color: HexColor.fromHex("#868fca"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.cours.prof,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColor)),
                            SizedBox(height: 2),
                            Text("Professeur",
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
                          Icons.work_outline_rounded,
                          color: HexColor.fromHex("#868fca"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Bientôt",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColor)),
                            SizedBox(height: 2),
                            Text("Devoir à faire",
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
