// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/login_card.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/comopnents/my_snackbar.dart';
import 'package:locale_chat/comopnents/my_text_field.dart';
import 'package:locale_chat/constants/languages_keys.dart';
import 'package:locale_chat/helper/localization_extention.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

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
          builder: (BuildContext context, AuthChangeNotifier authChangeNotifier,
              Widget? child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: MyLoginCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    column: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            LocaleKeys.forgotPasswordEnterEmailForReset
                                .locale(context),
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
                              hintText: LocaleKeys.emailVerificationEmail
                                  .locale(context),
                              obscureText: false,
                              validatorFunction: (value) {
                                if (value == null || value.isEmpty) {
                                  return LocaleKeys.errorsAuthEmailRequired
                                      .locale(context);
                                }
                                // More comprehensive email validation
                                final emailRegex = RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                                if (!emailRegex.hasMatch(value)) {
                                  return LocaleKeys
                                      .errorsAuthEnterAFValidEmailAddress
                                      .locale(context);
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
                                    LocaleKeys.emailVerificationSendCode
                                        .locale(context),
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
                              // Validate form first
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                authChangeNotifier.otpEmailController =
                                    emailController.text.trim();
                                await authChangeNotifier.sendOtp();

                                var firebaseAuthErrors = authChangeNotifier
                                    .getFirebaseAuthErrors('firebaseAuthOTP');

                                if (firebaseAuthErrors.isNotEmpty) {
                                  // Show error message if there are errors
                                  MySanckbar.mySnackbar(context,
                                      firebaseAuthErrors.first.message, 2);
                                } else {
                                  // Only show success message and navigate if no errors
                                  MySanckbar.mySnackbar(
                                      context,
                                      LocaleKeys.errorsAuthOtpHasBeenSent
                                          .locale(context),
                                      2);

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SentCodePage(),
                                    ),
                                  );
                                }
                              } catch (e) {
                                // Handle any unexpected errors
                                MySanckbar.mySnackbar(
                                    context,
                                    LocaleKeys.errorsAuthFailedToSendOtp
                                        .locale(context),
                                    2);
                              } finally {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                            buttonText: LocaleKeys.emailVerificationSendCode
                                .locale(context),
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
