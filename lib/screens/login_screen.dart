import 'package:bac_note/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const platform = MethodChannel('samples.volnetiks.dev/ecoledirecte');

  TextEditingController usernameController = TextEditingController();

  TextEditingController passwdController = TextEditingController();

  bool isChecked = false;

  bool showError = false;

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
          physics: const NeverScrollableScrollPhysics(),
          child: Stack(children: [
            Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text("Connectez-vous",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 15,
                    ),
                    Text("Utiliser vos identifiants école directe",
                        style: TextStyle(
                            color: Theme.of(context).disabledColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 15,
                    ),
                    Image.asset(
                      "assets/logo_ndta.png",
                      width: 200,
                    ),
                    showError
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                  "Une erreur s'est produite, veuillez vérifier vos identifiants ou réessayer plus tard",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.red.shade400)),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : const SizedBox(
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
                            contentPadding: const EdgeInsets.only(left: 20),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            hintText: "Identifiant",
                            hintStyle: const TextStyle(
                                fontSize: 17, color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(height: 15),
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
                            contentPadding: const EdgeInsets.only(left: 20),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            hintText: "Mot de passe",
                            hintStyle: const TextStyle(
                                fontSize: 17, color: Colors.grey)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    connect();
                    if (isChecked) {
                      saveIdsToPreferences();
                    }
                  },
                  child: const Text("Connexion"),
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
                    const Text("Se souvenir de moi")
                  ],
                )
              ],
            )
          ]),
        ),
      ),
    );
  }

  Future<void> connect() async {
    if (passwdController.text.isNotEmpty && passwdController.text.isNotEmpty) {
      try {
        String value = await platform.invokeMethod("connect", {
          "username": usernameController.text.toString(),
          "password": passwdController.text.toString()
        });
        if (value == "") {
          setState(() {
            showError = true;
            passwdController.text = "";
          });
        } else {
          Navigator.of(context).pushReplacement(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const HomePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              }));
        }
      } catch (exception, stackTrace) {
        await Sentry.captureException(exception, stackTrace: stackTrace);
      }
    }
  }

  Future<void> saveIdsToPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("username", usernameController.text);
    sharedPreferences.setString("password", passwdController.text);
  }

  Future<void> checkForIds() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey("username")) {
      usernameController.text = sharedPreferences.getString("username")!;
      passwdController.text = sharedPreferences.getString("password")!;
      connect();
    }
  }
}
