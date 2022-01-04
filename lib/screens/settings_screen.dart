import 'dart:io';

import 'package:bac_note/extensions/string.dart';
import 'package:bac_note/widgets/settings/logout_settings.dart';
import 'package:bac_note/widgets/settings/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const platform = MethodChannel('samples.volnetiks.dev/ecoledirecte');

  String studentName = "Prénom de l'élève";
  String studentClass = "Classe";
  String studentIconURL = "";

  @override
  void initState() {
    super.initState();
    getStudentNameWithClass();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text("Paramètres",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 35,
            ),
            const Text("Élève", style: TextStyle(fontSize: 25)),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).unselectedWidgetColor),
                    child: studentIconURL == ""
                        ? Icon(Icons.face,
                            color: Theme.of(context).primaryColor, size: 85)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(3000),
                            child: Image.network(
                              studentIconURL,
                              height: 90,
                              alignment: Alignment.topCenter,
                              fit: BoxFit.fitWidth,
                              headers: const {
                                HttpHeaders.refererHeader:
                                    "https://www.ecoledirecte.com/"
                              },
                            ),
                          ),
                  ),
                  const SizedBox(width: 18),
                  Column(children: [
                    Text(studentName, style: const TextStyle(fontSize: 15)),
                    Text(studentClass,
                        style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).disabledColor))
                  ])
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text("Paramètres", style: TextStyle(fontSize: 25)),
            const SizedBox(
              height: 10,
            ),
            const ThemeSettingsItem(),
            const LogOutSettingsItem(),
          ],
        ),
      ),
    ));
  }

  Future<void> getStudentNameWithClass() async {
    String name = await platform.invokeMethod("getStudentName");
    String studentClassInvoke = await platform.invokeMethod("getStudentClass");
    String iconURL = await platform.invokeMethod("getStudentImage");
    print(iconURL);
    setState(() {
      studentName = name;
      studentClass = studentClassInvoke.toLowerCase().capitalize();
      studentIconURL = "https:" + iconURL;
    });
  }
}
