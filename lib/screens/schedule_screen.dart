import 'dart:async';

import 'package:bac_note/extensions/hex_color.dart';
import 'package:bac_note/models/cours.dart';
import 'package:bac_note/widgets/date_tile.dart';
import 'package:bac_note/widgets/schedule_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  static const platform = MethodChannel('samples.volnetiks.dev/ecoledirecte');

  List<Cours> classes = [];

  ScrollController scrollController = ScrollController();
  late AutoScrollController _autoScrollController;

  int selectedIndex = 0;
  int scrollIndex = 0;
  int dateItems = 7;

  @override
  void initState() {
    getScheduleFromEcoleDirecte(0);
    super.initState();
    _autoScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          dateItems += 7;
        });
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _autoScrollController.scrollToIndex(scrollIndex,
          preferPosition: AutoScrollPosition.begin);
    });

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
              child: AlignedGridView.count(
                controller: scrollController,
                crossAxisCount: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
                itemCount: dateItems,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Center(
                    child: GestureDetector(
                      child: Material(
                          borderRadius: BorderRadius.circular(8),
                          color: selectedIndex == index
                              ? HexColor.fromHex("#5fa2c0")
                              : Theme.of(context)
                                  .unselectedWidgetColor
                                  .withOpacity(0.4),
                          child: DateTile(
                            days: index,
                          )),
                      onTap: () {
                        setState(() {
                          scrollIndex = 0;
                          selectedIndex = index;
                          getScheduleFromEcoleDirecte(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("Prochain cours",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: classes.isNotEmpty &&
                    classes[0].text.toLowerCase() != "congés"
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AlignedGridView.count(
                        controller: _autoScrollController,
                        crossAxisCount: 1,
                        mainAxisSpacing: 20,
                        itemCount: classes.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return AutoScrollTag(
                              child: ScheduleTile(cours: classes[index]),
                              controller: _autoScrollController,
                              index: index,
                              key: ValueKey(index));
                        }),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
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
      String coursString = await platform.invokeMethod('getEmploiDuTempsOn',
          {'date': DateFormat('yyyy-MM-dd hh:mm').format(time)});
      if (coursString.isNotEmpty) {
        List body = jsonDecode(coursString);
        List<DateTime> dates = [];
        List<Cours> cours = [];
        for (int i = 0; i < body.length; i++) {
          Cours cour = Cours.fromJSON(body[i]);
          cours.add(cour);

          dates.add(cour.startDate);
          dates.add(cour.endDate);
        }

        int index = 0;

        if (dates.isNotEmpty) {
          cours.sort((Cours cours1, Cours cours2) =>
              cours1.startDate.compareTo(cours2.startDate));

          dates.sort((DateTime dateTime1, DateTime dateTime2) =>
              dateTime1.compareTo(dateTime2));

          DateTime closestDate = dates.reduce((a, b) =>
              a.difference(DateTime.now()).abs() <
                      b.difference(DateTime.now()).abs()
                  ? a
                  : b);

          index = (dates.indexOf(closestDate) / 2).truncate();
        }

        setState(() {
          scrollIndex = index;
          classes = cours;
        });
      }
    } catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
    }
  }
}
