// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/login_card.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/comopnents/my_snackbar.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/languages_keys.dart';
import 'package:locale_chat/helper/localization_extention.dart';
import 'package:locale_chat/pages/auth_pages/login_page.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:provider/provider.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      MySanckbar.mySnackbar(
          context, LocaleKeys.errorsAuthEmailVerified.locale(context), 2);

      timer?.cancel();

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/login_image.png'),
            ),
          ),
          child: Consumer<AuthChangeNotifier>(
            builder: (BuildContext context,
                AuthChangeNotifier authChangeNotifier, Widget? child) {
              return SizedBox(
                height: size.height,
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyLoginCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      column: Column(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: backgroundColor, shape: BoxShape.circle),
                            child: const Icon(
                              Icons.email,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            LocaleKeys.emailVerificationCheckEmail
                                .locale(context),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: LocaleKeys.emailVerificationEmailSent
                                      .locale(context),
                                  style: const TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                    text: FirebaseAuth
                                        .instance.currentUser?.email,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black))
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: MyCircularProgressIndicator(),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyButton(
                                width: size.width * 0.3,
                                height: size.height * 0.05,
                                buttonColor: Colors.red.shade400,
                                buttonText: LocaleKeys.emailVerificationBack
                                    .locale(context),
                                textStyle: TextStyle(
                                    fontSize: size.height * 0.028,
                                    color: Colors.white,
                                    fontFamily: 'Roboto'),
                                onPressed: () async {
                                  await authChangeNotifier.signOut();
                                  Navigator.pop(context);
                                },
                              ),
                              const SizedBox(width: 15),
                              MyButton(
                                width: size.width * 0.3,
                                height: size.height * 0.05,
                                buttonColor: buttonColor,
                                buttonText: LocaleKeys.emailVerificationResend
                                    .locale(context),
                                textStyle: TextStyle(
                                    fontSize: size.height * 0.028,
                                    color: Colors.white,
                                    fontFamily: 'Roboto'),
                                onPressed: () async {
                                  await authChangeNotifier.autehntiacate();
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
