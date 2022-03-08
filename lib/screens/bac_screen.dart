import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({Key? key}) : super(key: key);

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  static const platform = MethodChannel('samples.volnetiks.dev/ecoledirecte');

  @override
  Widget build(BuildContext context) {
    platform.invokeMethod("");
    return Container();
  }
}
