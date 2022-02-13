import 'package:bac_note/extensions/string.dart';
import 'package:bac_note/models/grade.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GradeDialog extends StatefulWidget {
  final Note grade;

  const GradeDialog({Key? key, required this.grade}) : super(key: key);

  @override
  _GradeDialogState createState() => _GradeDialogState();
}

class _GradeDialogState extends State<GradeDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    scaleAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _animationController.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    widget.grade.devoir
                        .toLowerCase()
                        .replaceAll("_", " ")
                        .capitalize(),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 5,
                ),
                Text(widget.grade.libelleMatiere.toLowerCase().capitalize()),
                const SizedBox(
                  height: 5,
                ),
                Text(
                    "Évaluation du ${DateFormat('yMMMd', 'fr_FR').format(widget.grade.date)}",
                    style: TextStyle(color: Theme.of(context).disabledColor))
              ],
            )),
      ),
    );
  }
}
