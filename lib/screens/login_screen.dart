import 'package:bac_note/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const platform = MethodChannel('samples.volnetiks.dev/ecoledirecte');

  TextEditingController usernameController = TextEditingController();

  TextEditingController passwdController = TextEditingController();

  bool isChecked = false;

  @override
  void initState() {
    checkForIds();
    super.initState();
  }

  @override
  void dispose() {
    passwdController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text("Connectez-vous",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 15,
                  ),
                  Image.asset(
                    "assets/logo_ndta.png",
                    width: 200,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      controller: usernameController,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                          disabledBorder: InputBorder.none,
                          filled: true,
                          fillColor: Theme.of(context).unselectedWidgetColor,
                          contentPadding: EdgeInsets.only(left: 20),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          hintText: "Identifiant",
                          hintStyle:
                              TextStyle(fontSize: 17, color: Colors.grey)),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: true,
                      controller: passwdController,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                          disabledBorder: InputBorder.none,
                          filled: true,
                          fillColor: Theme.of(context).unselectedWidgetColor,
                          contentPadding: EdgeInsets.only(left: 20),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          hintText: "Mot de passe",
                          hintStyle:
                              TextStyle(fontSize: 17, color: Colors.grey)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  connect();
                  if (isChecked) {
                    saveIdsToPreferences();
                  }
                },
                child: Text("Connexion"),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor.withOpacity(0.6)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: isChecked,
                    fillColor: MaterialStateProperty.resolveWith(
                        (states) => Theme.of(context).unselectedWidgetColor),
                    checkColor: Theme.of(context).primaryColor,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  Text("Se souvenir de moi")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> connect() async {
    if (passwdController.text.isNotEmpty && passwdController.text.isNotEmpty) {
      print("connection text");
      String name = await platform.invokeMethod("connect", {
        "username": usernameController.text.toString(),
        "password": passwdController.text.toString()
      });
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          }));
    }
  }

  Future<void> saveIdsToPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("username", usernameController.text);
    sharedPreferences.setString("password", passwdController.text);
  }

  Future<void> checkForIds() async {
    print("test");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey("username")) {
      usernameController.text = sharedPreferences.getString("username")!;
      passwdController.text = sharedPreferences.getString("password")!;
      connect();
    }
  }
}
