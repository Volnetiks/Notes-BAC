import 'package:bac_note/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'grades_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark().copyWith(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
        buttonColor: Color.fromRGBO(112, 237, 238, 5),
        unselectedWidgetColor: Color.fromRGBO(46, 46, 46, 6),
        disabledColor: Color.fromRGBO(182, 182, 182, 50),
        brightness: Brightness.light,
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'SFUI'),
      ),
      theme: ThemeData(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        brightness: Brightness.light,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.purple,
        ),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.black,
        unselectedWidgetColor: Color.fromRGBO(235, 235, 235, 1),
        buttonColor: Colors.lightBlueAccent,
        disabledColor: Colors.grey.shade300,
        fontFamily: 'SFUI',
      ),
      home: const HomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var classes = [
    "Histoire-Géographie",
    "LVA (Anglais)",
    "LVB (Allemand/Espagnol)",
    "Enseignement scientifique",
    "Enseignement de spécialités de 1re",
    "EPS",
    "EMC",
    "Enseignement de spécialité 1 en Tle",
    "Enseignement de spécialité 2 en Tle",
    "Oral anticipé de français",
    "Écrit anticipé de français",
    "Philosophie",
    "Grand Oral"
  ];

  List<double?> grades = [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null
  ];

  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  Future<void> getSavedValues() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    for (int i = 0; i < 13; i++) {
      if (sharedPreferences.containsKey(classes[i])) {
        print(classes[i]);
        TextEditingController textEditingController = controllers[i];
        var grade = sharedPreferences.getDouble(classes[i])!;
        textEditingController.text = grade.toStringAsFixed(2);
        grades[i] = grade;
      }
    }
  }

  @override
  void initState() {
    getSavedValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Entrer vos moyennes (1ere/Terminale)",
          style: TextStyle(fontSize: 15, color: Theme.of(context).primaryColor),
        ),
      ),
      body: Center(
        child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: CustomScrollView(
              slivers: [
                SliverFixedExtentList(
                  itemExtent: 70.0,
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: TextField(
                          controller: controllers[index],
                          onChanged: (value) {
                            final grade = double.tryParse(value);

                            if (grade != null) {
                              grades[index] = grade;
                            }
                          },
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).disabledColor,
                                    width: 0.7),
                              ),
                              hintText: classes[index].toString()),
                          keyboardType: TextInputType.number,
                        ));
                  }, childCount: 13),
                )
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).buttonColor,
        onPressed: () async {
          // SAVES DATA
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();

          var coefficients = [6, 6, 6, 6, 8, 6, 2, 16, 16, 5, 5, 8, 10];
          var bacTotalGrade = 0.0;
          var totalOfCoefficients = 0;
          int index = 0;
          for (int i = 0; i < 13; i++) {
            if (grades[i] != null) {
              print(classes[i]);
              sharedPreferences.setDouble(classes[i], grades[i]!);
              bacTotalGrade += grades[i]! * coefficients[i];
              totalOfCoefficients += coefficients[i];
            }
          }

          var finalBacNote = bacTotalGrade / totalOfCoefficients;
          if (!finalBacNote.isNaN) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return GradesScreen(
                  grade: finalBacNote,
                );
              }),
            );
          }
        },
        child: Center(
          child: Icon(Icons.play_arrow, color: Theme.of(context).primaryColor),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
