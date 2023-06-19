import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivatech/colors.dart';
import 'package:vivatech/firebaseLocalNotification.dart';
import 'package:vivatech/home.dart';
import 'package:vivatech/snackbar.dart';

import 'button.dart';
import 'inputfield.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  void registerUser(String email, String password, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
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
        // showSnackBar('Welcome back!', context);
        FirebaseNotification()
            .showNotification('Welcome', 'Registration successful!');
      }
      // Registration success, show welcome back push notification
    } on FirebaseAuthException catch (e) {
      // Registration failed, handle error
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'The email address is already in use.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        default:
          errorMessage = 'Registration failed. Please try again later.';
          break;
      }
      showSnackBar(errorMessage, context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

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
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "assets/images/register.png",
                  width: size.width / 1.2,
                  height: size.height / 4,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    Text(
                      "Hey There",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Create an Account",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const SizedBox(height: 15),
                    InputField(
                      size: 50,
                      hint: "Email",
                      controller: emailController,
                      borderRadius: 15,
                      icon: Icons.mail_outline,
                      validator: MultiValidator([
                        EmailValidator(
                          errorText: 'Please enter valid email',
                        ),
                        RequiredValidator(errorText: 'Email required')
                      ]),
                      color: Colors.grey.shade100,
                    ),
                    const SizedBox(height: 15),
                    InputField(
                      size: 50,
                      password: true,
                      hint: "Password",
                      validator: MultiValidator([
                        RequiredValidator(
                          errorText: 'Password required',
                        ),
                      ]),
                      controller: passwordController,
                      borderRadius: 15,
                      icon: Icons.lock_outline,
                      color: Colors.grey.shade100,
                    ),
                    const SizedBox(height: 15),
                    InputField(
                      size: 50,
                      password: true,
                      controller: confirmpasswordController,
                      hint: "Confirm Password",
                      validator: MultiValidator([
                        RequiredValidator(
                          errorText: 'Confirm Password required',
                        ),
                      ]),
                      borderRadius: 15,
                      icon: Icons.lock_outline,
                      color: Colors.grey.shade100,
                    ),
                    const SizedBox(height: 30),
                    MyButton(
                      title: isLoading ? 'Loading...' : "Register",
                      fontSize: 14,
                      sizeHieght: 50,
                      color: secondaryColor,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          if (confirmpasswordController.text ==
                              passwordController.text) {
                            registerUser(emailController.text,
                                passwordController.text, context);
                          } else {
                            showSnackBar("Passwords doesn't match", context);
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 12),
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
                    const SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        text: "Already have an account?",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: " Login",
                            style: TextStyle(
                              fontSize: 14,
                              color: primaryColor,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pop();
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
        ),
      ),
    );
  }
}
