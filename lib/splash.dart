import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivatech/firebaseLocalNotification.dart';

import 'home.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? ''),
        content: Text(body ?? ''),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {},
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseNotification().setUpFirebase(onDidReceiveLocalNotification);
    checkLogin();
  }

  checkLogin() async {
    // precacheImage(widget.logo, context);
    try {
      // Fluttertoast.showToast(msg: "inside", toastLength: Toast.LENGTH_LONG);

      SharedPreferences pref = await SharedPreferences.getInstance();
      bool prefData = pref.getBool("isLogin") ?? false;
      Future.delayed(const Duration(seconds: 4), () async {
        print('object $prefData');
        if (prefData) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LoginScreen(),
            ),
          );
        }
      });
    } catch (e) {
      // Fluttertoast.showToast(msg: e);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [SizedBox(child: Text('Loading...'))],
        ),
      )),
    );
  }
}
