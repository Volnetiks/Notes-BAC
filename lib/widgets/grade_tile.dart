import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GradeTile extends StatefulWidget {
  final pourcent;
  const GradeTile({required this.pourcent});

  @override
  _GradeTileState createState() => _GradeTileState();
}

class _GradeTileState extends State<GradeTile> {
  @override
  Widget build(BuildContext context) {
    var pourcent = widget.pourcent;

    return AnimatedContainer(
      duration: Duration(milliseconds: 1500),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Theme.of(context).unselectedWidgetColor.withOpacity(0.4),
          border: Border.all(color: Theme.of(context).disabledColor),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text("Title",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor)),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Text",
            overflow: TextOverflow.ellipsis,
            maxLines: 10,
            style: TextStyle(color: Colors.grey, height: 1.3, fontSize: 12),
          ),
          SizedBox(
            height: 5,
          ),
          Row(children: [
            Text(
              "Date",
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
            Flexible(fit: FlexFit.tight, child: SizedBox()),
            Text(
              '$pourcent%',
              style: TextStyle(
                  color: pourcent > 50 ? Colors.blue : Colors.red[400],
                  fontSize: 11),
            ),
            LinearPercentIndicator(
              width: 70.0,
              lineHeight: 4.0,
              percent: pourcent / 100,
              progressColor: pourcent > 50 ? Colors.blue : Colors.red[500],
            )
          ])
        ],
      ),
    );
  }
}
