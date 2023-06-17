import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivatech/button.dart';
import 'package:vivatech/colors.dart';
import 'package:vivatech/firebaseLocalNotification.dart';
import 'package:vivatech/home.dart';
import 'package:vivatech/inputfield.dart';
import 'package:vivatech/register.dart';
import 'package:vivatech/snackbar.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    updateFcmToken();

    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  void loginUser(String email, String password, BuildContext context) async {
    setState(() {
      isloading = true;
    });
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        SharedPreferences pref = await SharedPreferences.getInstance();

        pref.setBool("isLogin", true);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ));
        showSnackBar('Welcome!', context);
      }
    } on FirebaseAuthException catch (e) {
      // Login failed, handle error
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'User not found. Please register.';
          break;
        case 'wrong-password':
          errorMessage = 'Invalid password. Please try again.';
          break;
        default:
          errorMessage = 'Login failed. Please try again later.';
          break;
      }
      showSnackBar(errorMessage, context);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

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

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  String? fcmtoken;
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
          child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Image.asset(
                "assets/images/login.png",
                width: size.width / 1.2,
                height: size.height / 3,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: size.height / 8),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Text(
                    "Welcom Back",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "we are always happy to serve you !!",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 25),
                  InputField(
                    size: 50,
                    hint: "Email",
                    controller: emailController,
                    validator: MultiValidator([
                      EmailValidator(
                        errorText: 'Please enter valid email',
                      ),
                      RequiredValidator(errorText: 'Email required')
                    ]),
                    borderRadius: 15,
                    icon: Icons.mail_outline,
                    color: Colors.grey.shade100,
                  ),
                  const SizedBox(height: 15),
                  InputField(
                    size: 50,
                    password: true,
                    hint: "Password",
                    borderRadius: 15,
                    controller: passwordController,
                    validator: MultiValidator(
                        [RequiredValidator(errorText: 'Password required')]),
                    icon: Icons.lock_outline,
                    color: Colors.grey.shade100,
                  ),
                  const SizedBox(height: 5),
                  const SizedBox(height: 25),
                  MyButton(
                    title: isloading ? 'Loading...' : "Login",
                    fontSize: 14,
                    sizeHieght: 50,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        loginUser(emailController.text, passwordController.text,
                            context);
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey)),
                      Text(
                        " Or ",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  RichText(
                    text: TextSpan(
                      text: "Create a new account?",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: " Register",
                          style: TextStyle(
                            fontSize: 14,
                            color: primaryColor,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ));
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  updateFcmToken() async {
    FirebaseNotification().setUpFirebase(onDidReceiveLocalNotification);

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    fcmtoken = await messaging.getToken();
  }
}
