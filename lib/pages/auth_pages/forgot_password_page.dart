// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/login_card.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/comopnents/my_snackbar.dart';
import 'package:locale_chat/comopnents/my_text_field.dart';
import 'package:locale_chat/pages/auth_pages/sent_code_page.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false;

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

            return Column(
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
                          'Enter the email you want to change your password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff828282),
                              fontSize: size.height * 0.024),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: MyTextField(
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
                        ),
                        MyButton(
                          button: _isLoading
                              ? MyCircularProgressIndicator(
                                  height: 20,
                                  width: 20,
                                  progressIndicatorColor: Colors.white,
                                )
                              : Text(
                                  'Sent Code',
                                  style: TextStyle(
                                      fontSize: size.height * 0.028,
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold),
                                ),
                          width: size.width * 0.5,
                          height: size.height * 0.05,
                          buttonColor: const Color(0xffAAD9BB),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            FocusScope.of(context).unfocus();

                            authChangeNotifier.otpEmailController =
                                emailController.text.trim();
                            await authChangeNotifier.sendOtp();
                            if (firebaseAuthErrors.isNotEmpty) {
                              MySanckbar.mySnackbar(
                                  context, firebaseAuthErrors.first.message, 2);
                            }
                            MySanckbar.mySnackbar(
                                context, 'OTP has been send', 2);

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SentCodePage(),
                              ),
                            );
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          buttonText: 'Sent Code',
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
            );
          },
        ),
      ),
    );
  }
}
