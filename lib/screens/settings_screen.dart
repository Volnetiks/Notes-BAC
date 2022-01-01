import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bac_note/extensions/string.dart';
import 'package:bac_note/widgets/custom_switch.dart';
import 'package:bac_note/widgets/settings_item.dart';
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
            SizedBox(
              height: 50,
            ),
            Text("Paramètres",
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
                    child: Icon(Icons.face,
                        color: Theme.of(context).primaryColor, size: 85),
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
            const SettingsItem()
          ],
        ),
      ),
    ));

    // return Scaffold(
    //   body: Container(
    //     color: Theme.of(context).unselectedWidgetColor,
    //     child: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           CustomSwitch(
    //             activeColor: Colors.black,
    //             inactiveColor: Colors.white,
    //             inactiveTextColor: Colors.black,
    //             offIcon: const Icon(Icons.light_mode, color: Colors.black),
    //             onIcon: const Icon(Icons.mode_night, color: Colors.white),
    //             onCircleColor: Colors.black,
    //             offCircleColor: Colors.transparent,
    //             activeText: "Dark",
    //             inactiveText: "Light",
    //             value: value,
    //             onChanged: (bool value) {
    //               final mode = AdaptiveTheme.of(context).mode;
    //               if (mode == AdaptiveThemeMode.light) {
    //                 AdaptiveTheme.of(context).setDark();
    //               } else {
    //                 AdaptiveTheme.of(context).setLight();
    //               }
    //             },
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  Future<void> getStudentNameWithClass() async {
    String name = await platform.invokeMethod("getStudentName");
    String studentClassInvoke = await platform.invokeMethod("getStudentClass");
    setState(() {
      studentName = name;
      studentClass = studentClassInvoke.toLowerCase().capitalize();
    });
  }
}
