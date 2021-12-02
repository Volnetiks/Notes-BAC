import 'package:flutter/material.dart';

class GradesScreen extends StatefulWidget {
  final grade;
  const GradesScreen({Key? key, required this.grade}) : super(key: key);

  @override
  _GradesScreenState createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  var mention = "";

  @override
  Widget build(BuildContext context) {
    final grade = widget.grade;

    if (grade < 10.0) {
      mention = "Bac non acquis.";
    } else if (grade < 12.0) {
      mention = "Aucune mention.";
    } else if (grade < 14.0) {
      mention = "Mention assez bien.";
    } else if (grade < 16.0) {
      mention = "Mention bien.";
    } else {
      mention = "Mention très bien.";
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Note finale du bac 2022",
            style: TextStyle(color: Theme.of(context).primaryColor)),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.grade.toStringAsFixed(2),
                style: TextStyle(fontSize: 55)),
            SizedBox(
              height: 20,
            ),
            Text(mention, style: TextStyle(fontSize: 25))
          ],
        ),
      ),
    );
  }
}
