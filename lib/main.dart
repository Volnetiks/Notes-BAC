import 'package:bac_note/extensions/hex_color.dart';
import 'package:bac_note/screens/home_screen.dart';
import 'package:bac_note/screens/login_screen.dart';
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
        buttonColor: HexColor.fromHex("#5fa2c0"),
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
        buttonColor: HexColor.fromHex("#28a5d5"),
        disabledColor: Colors.grey.shade500,
        fontFamily: 'SFUI',
      ),
      home: LoginPage(),
    );
  }
}
