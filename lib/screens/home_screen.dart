import 'package:bac_note/widgets/grade_tile.dart';
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 5,
                  itemCount: 5,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GradeTile(
                      pourcent: 20 * index,
                      values: [
                        'Exam Name $index',
                        "Class $index",
                        "Date $index"
                      ],
                    );
                  },
                  staggeredTileBuilder: (int index) {
                    return StaggeredTile.fit(2);
                  }),
            ),
            // child: ListView.builder(
            //     physics: NeverScrollableScrollPhysics(),
            //     itemCount: 5,
            //     itemExtent: 100,
            //     itemBuilder: (context, index) {
            //       return GradeItem(
            //         values: ['Chapter $index', 'Class $index', 'Date $index'],
            //       );
            //     }),
          )
        ],
      ),
    );
  }
}
