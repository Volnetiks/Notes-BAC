import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:intl/intl.dart';

import 'package:bac_note/extensions/hex_color.dart';
import 'package:bac_note/extensions/string.dart';
import 'package:bac_note/models/cours.dart';

class ClassDialog extends StatefulWidget {
  final Cours cours;

  const ClassDialog({
    Key? key,
    required this.cours,
  }) : super(key: key);

  @override
  _ClassDialogState createState() => _ClassDialogState();
}

class _ClassDialogState extends State<ClassDialog>
    with SingleTickerProviderStateMixin {
  static const platform = MethodChannel('samples.volnetiks.dev/ecoledirecte');

  late AnimationController controller;
  late Animation<double> scaleAnimation;

  DateFormat format = DateFormat.Hm();

  String work = "Aucun travail";

  @override
  void initState() {
    getWorkToDo();
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
  Widget build(BuildContext context) {
    DateFormat dayFormat = DateFormat.EEEE("FR_fr");

    return Dialog(
      child: ScaleTransition(
          scale: scaleAnimation,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.cours.text.toLowerCase().capitalize(),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 5,
                ),
                Text(
                    DateTime.now().day == widget.cours.startDate.day
                        ? "Aujourd'hui"
                        : dayFormat.format(widget.cours.startDate).capitalize(),
                    style: TextStyle(color: Theme.of(context).disabledColor)),
                const SizedBox(
                  height: 5,
                ),
                widget.cours.isAnnule
                    ? Text(
                        "Cours annulé.",
                        style: TextStyle(color: Colors.red.shade400),
                      )
                    : isOngoing(widget.cours.startDate, widget.cours.endDate)
                        ? Text(
                            "En cours",
                            style:
                                TextStyle(color: HexColor.fromHex("#9faf29")),
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
                                const TextSpan(text: ' à '),
                                TextSpan(
                                    text: format
                                        .format(widget.cours.endDate)
                                        .replaceAll(":", "h"),
                                    style: TextStyle(
                                        color: HexColor.fromHex("#868fca"))),
                              ])),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: HexColor.fromHex("#868fca"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.cours.salle,
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).primaryColor)),
                        const SizedBox(height: 2),
                        Text("Salle",
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
                      Icons.school_outlined,
                      color: HexColor.fromHex("#868fca"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.cours.prof,
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).primaryColor)),
                        const SizedBox(height: 2),
                        Text("Professeur",
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.work_outline_rounded,
                      color: HexColor.fromHex("#868fca"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Devoir à faire",
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).primaryColor)),
                        const SizedBox(height: 2),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.5),
                          child: Text(work,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).disabledColor)),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }

  bool isOngoing(DateTime startDate, DateTime endDate) {
    DateTime now = DateTime.now();
    return startDate.isBefore(now) && endDate.isAfter(now);
  }

  Future<void> getWorkToDo() async {
    String json = await platform.invokeMethod("getWorkToDo",
        {"date": DateFormat('y-MM-dd').format(widget.cours.startDate)});
    Map<String, dynamic> body = jsonDecode(json);
    List<dynamic> matieres = body["data"]["matieres"];
    for (int i = 0; i < matieres.length; i++) {
      if (matieres[i]["matiere"] == widget.cours.text &&
          matieres[i]["aFaire"] != null) {
        Codec<String, String> stringToBase64 = utf8.fuse(base64);
        String workHTML =
            stringToBase64.decode(matieres[i]["aFaire"]["contenu"]);
        var unescape = HtmlUnescape();
        setState(() {
          work = _parseHtmlString(unescape.convert(workHTML));
        });
      }
    }
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }
}
