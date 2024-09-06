// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_build_context_synchronously, prefer_const_constructors_in_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/login_card.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/comopnents/my_divider.dart';
import 'package:locale_chat/comopnents/my_snackbar.dart';
import 'package:locale_chat/comopnents/my_text_field.dart';
import 'package:locale_chat/model/user_model.dart';
import 'package:locale_chat/pages/auth_pages/forgot_password_page.dart';
import 'package:locale_chat/pages/auth_pages/register_page.dart';
import 'package:locale_chat/pages/control_page.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false, //klavye
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/login_image.png'),
          ),
        ),
        child: Consumer<AuthChangeNotifier>(
          builder: (context, authChangeNotifier, child) {
            var firebaseAuthErrors = authChangeNotifier.getFirebaseAuthErrors();
            return SizedBox(
              height: size.height,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'WELCOME',
                    style: TextStyle(
                        fontSize: size.height * 0.05,
                        fontFamily: 'Roboto',
                        color: const Color(0xff424242)),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.08),
                    child: MyLoginCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      column: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                    fontSize: size.height * 0.04,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff828282)),
                              ),
                            ),
                            MyTextField(
                              controller: emailController,
                              prefixIcon: const Icon(CupertinoIcons.mail),
                              hintText: 'Email',
                              obscureText: false,
                              validatorFunction: (value) {
                                if (value != null) {
                                  if (value.length > 5 &&
                                      value.contains('@') &&
                                      value.endsWith('.com')) {
                                    return null;
                                  }
                                  return 'Enter valid email';
                                }
                                return null;
                              },
                            ),
                            MyTextField(
                              controller: passwordController,
                              prefixIcon: const Icon(CupertinoIcons.lock),
                              hintText: 'Password',
                              obscureText: _obscureText,
                              suffixIcon: IconButton(
                                highlightColor: Colors.transparent,
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: _obscureText
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                              ),
                              validatorFunction: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter password';
                                }
                                if (value.length < 6) {
                                  return 'Enter 6 digit password';
                                }
                                return null;
                              },
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ForgotPasswordPage(),
                                  ));
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      color: Color(0xffB7B7B7),
                                      fontSize: size.height * 0.020),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MyButton(
                                button: _isLoading
                                    ? MyCircularProgressIndicator(
                                        height: 20,
                                        width: 20,
                                        progressIndicatorColor: Colors.white,
                                      )
                                    : Text(
                                        'Login',
                                        style: TextStyle(
                                            fontSize: size.height * 0.028,
                                            color: Colors.white,
                                            fontFamily: 'Roboto'),
                                      ),
                                width: size.width * 0.5,
                                height: size.height * 0.05,
                                buttonColor: Color(0xffAAD9BB),
                                buttonText: 'Login',
                                textStyle: TextStyle(
                                    fontSize: size.height * 0.028,
                                    color: Colors.white,
                                    fontFamily: 'Roboto'),
                                onPressed: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  FocusScope.of(context).unfocus();

                                  if (_formKey.currentState!.validate()) {
                                    //User Login
                                    UserModel? user =
                                        await authChangeNotifier.signIn(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    );
                                    //Firebase Auth Exception Control
                                    if (firebaseAuthErrors.isNotEmpty) {
                                      MySanckbar.mySnackbar(context,
                                          firebaseAuthErrors.first.message, 2);
                                    }
                                    if (user != null) {
                                      bool isVerified = FirebaseAuth
                                          .instance.currentUser!.emailVerified;
                                      if (isVerified) {
                                        MySanckbar.mySnackbar(
                                            context, 'Login succesfull', 1);
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ControlPage()),
                                        );
                                      } else {
                                        MySanckbar.mySnackbar(context,
                                            'Please verify your email', 2);
                                        authChangeNotifier.signOut();
                                      }
                                    }
                                  }
                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an account? ',
                                  style: TextStyle(
                                      color: Color(0xffB7B7B7),
                                      fontSize: size.height * 0.015),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => RegisterPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        color: Color(0xff00A3FF),
                                        fontSize: size.height * 0.015),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      MyDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          signIn_container(
                            size,
                            'google_icon',
                            () async {
                              UserModel? user =
                                  await authChangeNotifier.authWithGoogle();
                              if (firebaseAuthErrors.isNotEmpty) {
                                MySanckbar.mySnackbar(context,
                                    firebaseAuthErrors.first.message, 2);
                                if (user != null) {
                                  MySanckbar.mySnackbar(
                                      context, 'Google login succesfull', 1);
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ControlPage()),
                                  );
                                }
                              }
                            },
                          ),
                          signIn_container(
                            size,
                            'facebook_icon',
                            () async {
                              UserModel? user =
                                  await authChangeNotifier.authWithFacebook();
                              if (firebaseAuthErrors.isNotEmpty) {
                                MySanckbar.mySnackbar(context,
                                    firebaseAuthErrors.first.message, 2);
                                if (user != null) {
                                  MySanckbar.mySnackbar(
                                      context, 'Facebook login succesfull', 1);
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ControlPage()),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  InkWell signIn_container(Size size, String iconName, Function() onTap) {
    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        margin:
            const EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 17),
        padding: const EdgeInsets.all(10),
        height: size.height * 0.07,
        width: size.width * 0.15,
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
              blurStyle: BlurStyle.inner,
              color: Colors.black,
              blurRadius: 20,
              spreadRadius: 1),
        ], borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Image(
          fit: BoxFit.fill,
          color: const Color(0xff939393),
          image: AssetImage('assets/images/$iconName.png'),
        ),
      ),
    );
  }
}
