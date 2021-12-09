import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
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
                  child: TextField(
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
                        hintStyle: TextStyle(fontSize: 17, color: Colors.grey)),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
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
                        hintStyle: TextStyle(fontSize: 17, color: Colors.grey)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
