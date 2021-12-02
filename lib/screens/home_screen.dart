import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentIndex = 0;

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
    );
  }
}
