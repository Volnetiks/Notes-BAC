import 'package:bac_note/models/grade.dart';
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

class _HomePageState extends State<HomePage> {
  var _currentIndex = 0;

  List<Grade> grades = [
    Grade.fromResultOutOf20("Maths", "Chapter 5", DateTime(2010, 11, 9), 20),
    Grade.fromResultOutOf20("History", "Chapter 1", DateTime(2010, 8, 9), 20),
    Grade.fromResult("French", "Reading Test 3", DateTime(2010, 8, 9), 90),
    Grade.fromResult("English", "New Zealand", DateTime(2010, 9, 9), 10),
    Grade.fromResult("Polish", "Verbs", DateTime(2010, 12, 9), 70),
    Grade.fromResult("IT", "Network", DateTime.now(), 40),
  ];

  @override
  Widget build(BuildContext context) {
    grades.sort((a, b) => a.date.compareTo(b.date));

    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.dashboard),
            title: Text("Dashboard"),
            selectedColor: Theme.of(context).primaryColor,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.grade),
            title: Text("Grades"),
            selectedColor: Theme.of(context).primaryColor,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.schedule),
            title: Text("Schedule"),
            selectedColor: Theme.of(context).primaryColor,
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
      body: SafeArea(
        child: Column(
          children: [
            GradesChart(grades: grades),
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
      ),
    );
  }
}
