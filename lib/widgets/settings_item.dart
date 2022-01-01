import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:bac_note/extensions/string.dart';
import 'package:bac_note/models/note.dart';

import 'custom_switch.dart';

class SettingsItem extends StatefulWidget {
  const SettingsItem({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsItemState createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  @override
  Widget build(BuildContext context) {
    bool value = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;

    return AnimatedContainer(
        duration: const Duration(milliseconds: 1500),
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).unselectedWidgetColor),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(Icons.mode_night,
                    color: Theme.of(context).primaryColor, size: 45),
              ),
            ),
            const SizedBox(width: 18),
            const Text("Mode sombre", style: TextStyle(fontSize: 15)),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 18.0),
              child: CustomSwitch(
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
            )
          ],
        ));
  }
}
