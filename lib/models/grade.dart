import 'package:flutter/material.dart';

class Grade {
  late String name;
  late String grade_class;
  late DateTime date;
  late int result;

  Grade(
      {required this.name,
      required this.grade_class,
      required this.date,
      required this.result});
}
