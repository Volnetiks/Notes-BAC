import 'package:bac_note/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const platform = MethodChannel('samples.volnetiks.dev/ecoledirecte');

  TextEditingController usernameController = TextEditingController();

  TextEditingController passwdController = TextEditingController();

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
                },
                child: Text("Connexion"),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor.withOpacity(0.6)),
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    }
  }
}
