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
    Grade(
        date: DateTime(2010, 11, 9),
        grade_class: "Maths",
        name: "Chapter 5",
        result: 100),
    Grade(
        date: DateTime(2010, 8, 9),
        grade_class: "History",
        name: "Chapter 1",
        result: 100),
    Grade(
        date: DateTime(2010, 6, 9),
        grade_class: "French",
        name: "Reading Test 3",
        result: 90),
    Grade(
        date: DateTime(2010, 9, 9),
        grade_class: "English",
        name: "New Zealand",
        result: 10),
    Grade(
        date: DateTime(2010, 12, 9),
        grade_class: "Polish",
        name: "Verbs",
        result: 70),
    Grade(date: DateTime.now(), grade_class: "IT", name: "Network", result: 40),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: GradesChart(grades: grades),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 250,
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
        ],
      ),
    );
  }
}
