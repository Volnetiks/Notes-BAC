import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bac_note/widgets/custom_switch.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    bool value = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;

    return Scaffold(
      body: Container(
        color: Theme.of(context).unselectedWidgetColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomSwitch(
                activeColor: Colors.black,
                inactiveColor: Colors.white,
                inactiveTextColor: Colors.black,
                offIcon: const Icon(Icons.light_mode, color: Colors.black),
                onIcon: const Icon(Icons.mode_night, color: Colors.white),
                onCircleColor: Colors.black,
                offCircleColor: Colors.transparent,
                activeText: "Dark",
                inactiveText: "Light",
                value: value,
                onChanged: (bool value) {
                  final mode = AdaptiveTheme.of(context).mode;
                  if (mode == AdaptiveThemeMode.light) {
                    AdaptiveTheme.of(context).setDark();
                  } else {
                    AdaptiveTheme.of(context).setLight();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
