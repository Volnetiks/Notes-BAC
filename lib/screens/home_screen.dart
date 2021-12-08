import 'package:bac_note/models/grade.dart';
import 'package:bac_note/screens/schedule_screen.dart';
import 'package:bac_note/widgets/grade_tile.dart';
import 'package:bac_note/widgets/grades_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
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
              child: Text("Zeroth",
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
            Tab(
              child: Text("First",
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
            Tab(
              child: Text("Second",
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ];

          final TabController tabController = DefaultTabController.of(context)!;

          return Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  title: Column(
                    children: [
                      Text("Student name",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      Text(
                        "Notre Dame De Toutes Aides",
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
                HomeScreenWidget()
              ]));
        },
      ),
    );
  }
}

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  List<Grade> grades = [
    Grade.fromResultOutOf20("Maths", "Chapter 5", DateTime(2010, 11, 9), 20),
    Grade.fromResultOutOf20("History", "Chapter 1", DateTime(2010, 8, 9), 20),
    Grade.fromResult("French", "Reading Test 3", DateTime(2010, 8, 9), 90),
    Grade.fromResult("English", "New Zealand", DateTime(2010, 9, 9), 10),
    Grade.fromResult("Polish", "Verbs", DateTime(2010, 12, 9), 70),
    Grade.fromResult("IT", "Network", DateTime.now(), 40),
  ];

  String dropdownValue = 'Récentes';

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
                child: Text("Dernières notes",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
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
                    items: ['Plus ancienne', "Récentes", "Notes"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Flexible(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    itemCount: grades.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      switch (dropdownValue) {
                        case 'Plus ancienne':
                          grades.sort((a, b) => a.date.compareTo(b.date));
                          break;

                        case 'Récentes':
                          grades.sort((a, b) => b.date.compareTo(a.date));
                          break;

                        case 'Notes':
                          grades.sort((a, b) =>
                              b.resultOutOf20.compareTo(a.resultOutOf20));
                          break;

                        default:
                          grades.sort((a, b) => a.date.compareTo(b.date));
                          break;
                      }

                      return GradeTile(
                        grade: grades[index],
                      );
                    },
                    staggeredTileBuilder: (int index) {
                      return StaggeredTile.fit(2);
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
