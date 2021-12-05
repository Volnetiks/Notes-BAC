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
        date: DateTime.now(),
        grade_class: "Maths",
        name: "Chapter 5",
        result: 80),
    Grade(
        date: DateTime.now(),
        grade_class: "History",
        name: "Chapter 1",
        result: 75),
    Grade(
        date: DateTime.now(),
        grade_class: "French",
        name: "Reading Test 3",
        result: 30),
    Grade(
        date: DateTime.now(),
        grade_class: "English",
        name: "New Zealand",
        result: 90),
    Grade(date: DateTime.now(), grade_class: "IT", name: "Network", result: 40),
  ];

  @override
  Widget build(BuildContext context) {
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
                  crossAxisSpacing: 5,
                  itemCount: grades.length,
                  shrinkWrap: true,
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
