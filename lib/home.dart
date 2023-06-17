import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivatech/colors.dart';
import 'package:vivatech/login.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  logout(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setBool("isLogin", false);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                logout(context);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
          child: Center(
        child: Text("Welcome Home Page"),
      )),
    );
  }
}
