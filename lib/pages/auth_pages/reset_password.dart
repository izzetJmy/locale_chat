// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/login_card.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_snackbar.dart';
import 'package:locale_chat/comopnents/my_text_field.dart';
import 'package:locale_chat/model/async_change_notifier.dart';
import 'package:locale_chat/pages/auth_pages/login_page.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPsswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/login_image.png'),
          ),
        ),
        child: Consumer<AuthChangeNotifier>(
          builder: (BuildContext context, AuthChangeNotifier authChangeNotifier,
              Widget? child) {
            var firebaseAuthErrors = authChangeNotifier.getFirebaseAuthErrors();
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: MyLoginCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 30),
                      column: Column(
                        children: [
                          Text(
                            'Enter the password you want to update',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff828282),
                                fontSize: size.height * 0.024),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: MyTextField(
                              controller: newPasswordController,
                              prefixIcon: const Icon(CupertinoIcons.lock),
                              hintText: 'New password',
                              obscureText: false,
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.remove_red_eye),
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
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: MyTextField(
                              controller: confirmNewPsswordController,
                              prefixIcon: const Icon(CupertinoIcons.lock),
                              hintText: 'Confirm password',
                              obscureText: false,
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.remove_red_eye),
                              ),
                              validatorFunction: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter password';
                                }
                                if (value != newPasswordController.text) {
                                  return 'two passwords must be the same';
                                }
                                return null;
                              },
                            ),
                          ),
                          MyButton(
                            width: size.width * 0.5,
                            height: size.height * 0.05,
                            buttonColor: const Color(0xffAAD9BB),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await authChangeNotifier.updatePassword(
                                    email:
                                        authChangeNotifier.otpEmailController,
                                    password:
                                        newPasswordController.text.trim());

                                if (firebaseAuthErrors.isNotEmpty) {
                                  MySanckbar.mySnackbar(context,
                                      firebaseAuthErrors.first.message, 2);
                                } else {
                                  if (authChangeNotifier.state ==
                                      AsyncChangeNotifierState.idle) {
                                    MySanckbar.mySnackbar(context,
                                        'Password changed to successful', 2);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            buttonText: 'Update',
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.028,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
