import 'package:bac_note/extensions/string.dart';
import 'package:bac_note/models/cours.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticIn);

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
                    Text(widget.cours.text.toLowerCase().capitalize()),
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
