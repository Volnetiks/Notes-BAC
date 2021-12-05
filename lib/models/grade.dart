import 'package:flutter/material.dart';

class Grade {
  late String name;
  late String grade_class;
  late DateTime date;
  late int result;
  late double resultOutOf20;

  Grade(
      {required this.name,
      required this.grade_class,
      required this.date,
      required this.result,
      required this.resultOutOf20});

  factory Grade.fromResultOutOf20(
      String name, String grade_class, DateTime time, double result) {
    return Grade(
        name: name,
        grade_class: grade_class,
        date: time,
        result: (result * 5).round(),
        resultOutOf20: result);
  }

  factory Grade.fromResult(
      String name, String grade_class, DateTime time, int result) {
    return Grade(
        name: name,
        grade_class: grade_class,
        date: time,
        result: result,
        resultOutOf20: result / 10 * 2);
  }
}
