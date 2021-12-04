import 'dart:collection';

import 'package:flutter/material.dart';

class GradeItem extends StatefulWidget {
  final List<String> values;

  const GradeItem({required this.values});

  @override
  _GradeItemState createState() => _GradeItemState();
}

class _GradeItemState extends State<GradeItem> {
  @override
  Widget build(BuildContext context) {
    print("item");
    return Container(
      width: 400,
      height: 400,
      child: CustomPaint(
        painter: Painter(context: context, values: widget.values),
      ),
    );
  }
}

class Painter extends CustomPainter {
  BuildContext context;
  List<String> values;

  Painter({required this.context, required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Theme.of(context).unselectedWidgetColor
      ..style = PaintingStyle.fill;
    var width = size.width / 4;
    List<Offset> offsets = [Offset(55, 110), Offset(55, 130), Offset(55, 150)];

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(
              size.width / 2 - (width * 3 / 2),
              100,
              width * 3,
              75,
            ),
            Radius.circular(10.0)),
        paint1);

    for (int i = 0; i < values.length; i++) {
      TextSpan span = new TextSpan(
          style: TextStyle(color: Colors.grey[500]), text: values[i]);
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, offsets[i]);
    }

    // TextSpan span = new TextSpan(
    //     style: new TextStyle(color: Colors.grey[600]),
    //     text: 'Name of the exam');
    // TextSpan span2 = new TextSpan(
    //     style: new TextStyle(color: Colors.grey[600]), text: 'Chapter');
    // TextPainter tp = new TextPainter(
    //     text: span,
    //     textAlign: TextAlign.left,
    //     textDirection: TextDirection.ltr);
    // tp.layout();
    // tp.paint(canvas, new Offset(55.0, 110.0));
    // TextPainter tp2 = new TextPainter(
    //     text: span2,
    //     textAlign: TextAlign.left,
    //     textDirection: TextDirection.ltr);
    // tp2.layout();
    // tp2.paint(canvas, new Offset(55.0, 125.0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
