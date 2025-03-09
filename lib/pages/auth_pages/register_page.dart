// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/login_card.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/comopnents/my_snackbar.dart';
import 'package:locale_chat/comopnents/my_text_field.dart';
import 'package:locale_chat/model/user_model.dart';
import 'package:locale_chat/pages/auth_pages/email_verification_page.dart';
import 'package:locale_chat/pages/auth_pages/login_page.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscureText = true;
  bool _obscureTextAgain = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/login_image.png'),
          ),
        ),
        child: Consumer<AuthChangeNotifier>(
          builder: (context, authChangeNotifier, child) {
            return SizedBox(
              height: size.height,
              width: size.width,
              child: Form(
                key: _formKey,
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
                        column: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Text(
                                'REGISTER',
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
                            MyTextField(
                              controller: confirmPasswordController,
                              prefixIcon: const Icon(CupertinoIcons.lock),
                              hintText: 'Confirm Password',
                              obscureText: _obscureTextAgain,
                              suffixIcon: IconButton(
                                highlightColor: Colors.transparent,
                                onPressed: () {
                                  setState(() {
                                    _obscureTextAgain = !_obscureTextAgain;
                                  });
                                },
                                icon: _obscureTextAgain
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                              ),
                              validatorFunction: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter password';
                                }
                                if (value != passwordController.text) {
                                  return 'two passwords must be the same';
                                }
                                return null;
                              },
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
                                        'Register',
                                        style: TextStyle(
                                            fontSize: size.height * 0.028,
                                            color: Colors.white,
                                            fontFamily: 'Roboto'),
                                      ),
                                width: size.width * 0.5,
                                height: size.height * 0.05,
                                buttonColor: Color(0xffAAD9BB),
                                onPressed: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    //User sign up
                                    UserModel? user =
                                        await authChangeNotifier.register(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                    //Firebase Auth Exception Control
                                    authChangeNotifier
                                            .getFirebaseAuthErrors(
                                                'firebaseAuthRegister')
                                            .isNotEmpty
                                        ? MySanckbar.mySnackbar(
                                            context,
                                            authChangeNotifier
                                                .getFirebaseAuthErrors(
                                                    'firebaseAuthRegister')
                                                .first
                                                .message,
                                            2)
                                        : user != null &&
                                                FirebaseAuth
                                                        .instance.currentUser !=
                                                    null
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EmailVerificationPage(),
                                                ),
                                              )
                                            : null;
                                  }
                                  setState(
                                    () {
                                      _isLoading = false;
                                    },
                                  );
                                },
                                buttonText: 'Register',
                                textStyle: TextStyle(
                                    fontSize: size.height * 0.028,
                                    color: Colors.white,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already you have acoount ',
                                  style: TextStyle(
                                      color: Color(0xffB7B7B7),
                                      fontSize: size.height * 0.015),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Sign In',
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
                    SizedBox(
                      height: size.height * 0.06,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
