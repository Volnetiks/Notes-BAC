import 'dart:convert';

import 'package:bac_note/extensions/string.dart';
import 'package:bac_note/log/logdna.dart';
import 'package:bac_note/log/models/dna_line.dart';
import 'package:bac_note/models/note.dart';
import 'package:bac_note/screens/schedule_screen.dart';
import 'package:bac_note/screens/settings_screen.dart';
import 'package:bac_note/utils/platform_utils.dart' as platform_utils;
import 'package:bac_note/widgets/grade_tile.dart';
import 'package:bac_note/widgets/grades_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'grades_screen.dart';

import '../utils/secrets.dart' as secrets;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String studentName = "";
  String schoolName = "";

  static const platform = MethodChannel('samples.volnetiks.dev/ecoledirecte');

  @override
  void initState() {
    getStudentName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Builder(
        builder: (BuildContext context) {
          List<Tab> tabs = <Tab>[
            Tab(
              child: Text("Notes",
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
            Tab(
              child: Text("EDT",
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
            Tab(
              child: Text("BAC",
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ];

          return Scaffold(
              appBar: AppBar(
                  leading: IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SettingsScreen();
                        }));
                      },
                      icon: const Icon(Icons.settings)),
                  centerTitle: true,
                  title: Column(
                    children: [
                      Text(studentName,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      Text(
                        schoolName.toString().toTitleCase(),
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).disabledColor),
                      )
                    ],
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  backgroundColor: Theme.of(context).unselectedWidgetColor,
                  bottom: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: tabs,
                  )),
              body: const TabBarView(children: [
                HomeScreenWidget(),
                ScheduleScreen(),
                GradesScreen()
              ]));
        },
      ),
    );
  }

  Future<void> getStudentName() async {
    String name = await platform.invokeMethod("getStudentName");
    String nomEtablissement =
        await platform.invokeMethod('getNomEtablissement');
    setState(() {
      studentName = name;
      schoolName = nomEtablissement;
    });
  }
}

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  List<Note> grades = [];

  String dropdownValue = 'R??centes';

  static const platform = MethodChannel('samples.volnetiks.dev/ecoledirecte');

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          GradesChart(grades: grades),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("Derni??res notes",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 20,
                    elevation: 16,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).unselectedWidgetColor,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: ['Plus ancienne', "R??centes", "Notes"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Flexible(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AlignedGridView.count(
                    crossAxisCount: 1,
                    mainAxisSpacing: 20,
                    itemCount: grades.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      switch (dropdownValue) {
                        case 'Plus ancienne':
                          grades.sort((a, b) => a.date.compareTo(b.date));
                          break;

                        case 'R??centes':
                          grades.sort((a, b) => b.date.compareTo(a.date));
                          break;

                        case 'Notes':
                          grades.sort((a, b) => b.note.compareTo(a.note));
                          break;

                        default:
                          grades.sort((a, b) => a.date.compareTo(b.date));
                          break;
                      }

                      return GradeTile(
                        grade: grades[index],
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getNotes() async {
    // LOG DNA
    LogDNA logDNA = LogDNA(
        apiKey: secrets.logDNAApiKey, hostName: "bac_note", appName: "AppBAC");

    String noteJSON = await platform.invokeMethod('getNotes');

    List<Note> tempGrades = [];

    try {
      List notes = jsonDecode(noteJSON);

      String deviceInfo = await platform_utils.getOSVersionAndModel();

      logDNA.log(DnaLine(
          timestamp: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
          line: deviceInfo,
          level: DnaLevel.debug,
          env: DnaEnv.production,
          app: "AppBAC"));

      logDNA.log(DnaLine(
          timestamp: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
          line: notes.toString(),
          level: DnaLevel.debug,
          env: DnaEnv.production,
          app: "AppBAC"));

      for (var i = 0; i < notes.length; i++) {
        Note note = Note.fromJSON(notes[i]);
        logDNA.log(DnaLine(
            timestamp: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
            line: jsonEncode(note.toJSON()),
            level: DnaLevel.debug,
            env: DnaEnv.production,
            app: "AppBAC"));
        tempGrades.add(note);
      }

      logDNA.log(DnaLine(
          timestamp: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
          line: deviceInfo,
          level: DnaLevel.debug,
          env: DnaEnv.production,
          app: "AppBAC"));

      setState(() {
        grades = tempGrades;
      });
    } catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
    }
  }
}
