import 'dart:async';

import 'package:bac_note/extensions/hex_color.dart';
import 'package:bac_note/extensions/string.dart';
import 'package:bac_note/models/cours.dart';
import 'package:bac_note/widgets/date_tile.dart';
import 'package:bac_note/widgets/grade_tile.dart';
import 'package:bac_note/widgets/grades_chart.dart';
import 'package:bac_note/widgets/schedule_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  static const platform = MethodChannel('samples.volnetiks.dev/ecoledirecte');

  List<Cours> classes = [];

  int selectedIndex = 0;

  @override
  void initState() {
    getScheduleFromEcoleDirecte(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                itemCount: 7,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Center(
                    child: GestureDetector(
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
                          getScheduleFromEcoleDirecte(index);
                        });
                      },
                    ),
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
            child: classes.isNotEmpty &&
                    classes[0].text.toLowerCase() != "congés"
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        itemCount: classes.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ScheduleTile(cours: classes[index]);
                        },
                        staggeredTileBuilder: (int index) {
                          return StaggeredTile.fit(2);
                        }),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text('Aucun cours',
                            style: TextStyle(fontSize: 17, color: Colors.grey))
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> getScheduleFromEcoleDirecte(int index) async {
    try {
      DateTime time = DateTime.now().add(Duration(days: index));
      print(DateFormat('dd-MM-yyyy').format(time));
      String coursString = await platform.invokeMethod('getEmploiDuTempsOn',
          {'date': DateFormat('yyyy-MM-dd hh:mm').format(time)});
      if (coursString.isNotEmpty) {
        List body = jsonDecode(coursString);
        List<Cours> cours = [];
        for (int i = 0; i < body.length; i++) {
          Cours cour = Cours.fromJSON(body[i]);
          cours.add(cour);
        }

        cours.sort((Cours cours1, Cours cours2) =>
            cours1.startDate.compareTo(cours2.startDate));

        setState(() {
          classes = cours;
        });
      }
    } on PlatformException catch (e) {
      print("errror");
    }
  }
}
