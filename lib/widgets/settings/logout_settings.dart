import 'package:bac_note/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogOutSettingsItem extends StatefulWidget {
  const LogOutSettingsItem({Key? key}) : super(key: key);

  @override
  _LogOutSettingsItemState createState() => _LogOutSettingsItemState();
}

class _LogOutSettingsItemState extends State<LogOutSettingsItem> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 1500),
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).unselectedWidgetColor),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(Icons.logout,
                    color: Theme.of(context).primaryColor, size: 35),
              ),
            ),
            const SizedBox(width: 18),
            const Text("Se déconnecter", style: TextStyle(fontSize: 15)),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).unselectedWidgetColor,
                    borderRadius: BorderRadius.circular(10)),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    if (sharedPreferences.containsKey("username")) {
                      sharedPreferences.clear();
                    }
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (Route<dynamic> route) => false);
                  },
                ),
              ),
            )
          ],
        ));
  }
}
