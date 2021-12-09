import 'package:bac_note/extensions/hex_color.dart';
import 'package:bac_note/models/grade.dart';
import 'package:bac_note/widgets/date_tile.dart';
import 'package:bac_note/widgets/grade_tile.dart';
import 'package:bac_note/widgets/grades_chart.dart';
import 'package:bac_note/widgets/schedule_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  static const platform = MethodChannel('samples.volnetiks.dev/ecoledirecte');

  List<Grade> grades = [
    Grade.fromResultOutOf20("Maths", "Chapter 5", DateTime(2010, 11, 9), 20),
    Grade.fromResultOutOf20("History", "Chapter 1", DateTime(2010, 8, 9), 20),
    Grade.fromResult("French", "Reading Test 3", DateTime(2010, 8, 9), 90),
    Grade.fromResult("English", "New Zealand", DateTime(2010, 9, 9), 10),
    Grade.fromResult("Polish", "Verbs", DateTime(2010, 12, 9), 70),
    Grade.fromResult("IT", "Network", DateTime.now(), 40),
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    getScheduleFromEcoleDirecte();

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20),
            child: Text("Date",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Theme.of(context).primaryColor)),
          ),
          SizedBox(
            height: 175,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
              child: StaggeredGridView.countBuilder(
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
                itemCount: grades.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Material(
                        borderRadius: BorderRadius.circular(8),
                        color: selectedIndex == index
                            ? Theme.of(context).buttonColor
                            : Theme.of(context)
                                .unselectedWidgetColor
                                .withOpacity(0.4),
                        child: DateTile(
                          days: index,
                        )),
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  );
                },
                staggeredTileBuilder: (int index) {
                  return StaggeredTile.count(2, 1.5);
                },
                crossAxisCount: 2,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("Prochain cours",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  itemCount: grades.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ScheduleTile();
                  },
                  staggeredTileBuilder: (int index) {
                    return StaggeredTile.fit(2);
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getScheduleFromEcoleDirecte() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    print(batteryLevel);
  }
}
