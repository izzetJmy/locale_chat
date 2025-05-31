// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/login_card.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/comopnents/my_snackbar.dart';
import 'package:locale_chat/comopnents/pin_put.dart';
import 'package:locale_chat/constants/languages_keys.dart';
import 'package:locale_chat/helper/localization_extention.dart';
import 'package:locale_chat/pages/auth_pages/reset_password.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:provider/provider.dart';

class SentCodePage extends StatefulWidget {
  const SentCodePage({super.key});

  @override
  State<SentCodePage> createState() => _SentCodePageState();
}

class _SentCodePageState extends State<SentCodePage> {
  final List<TextEditingController> controllerList =
      List.generate(6, (index) => TextEditingController());
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
                          LocaleKeys.forgotPasswordEnterEmailForReset
                              .locale(context),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff828282),
                              fontSize: size.height * 0.024),
                        ),
                        const PinPut(),
                        MyButton(
                          button: _isLoading
                              ? MyCircularProgressIndicator(
                                  height: 20,
                                  width: 20,
                                  progressIndicatorColor: Colors.white,
                                )
                              : Text(
                                  LocaleKeys.forgotPasswordVerify
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
                            setState(() {
                              _isLoading = true;
                            });
                            await authChangeNotifier.verifyOtp();
                            if (authChangeNotifier.isOtpVerified) {
                              MySanckbar.mySnackbar(
                                  context,
                                  LocaleKeys.errorsAuthOtpIsVerified
                                      .locale(context),
                                  2);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ResetPasswordPage(),
                                ),
                              );
                            } else {
                              MySanckbar.mySnackbar(
                                  context,
                                  LocaleKeys.errorsAuthInvalidOtp
                                      .locale(context),
                                  2);
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          buttonText:
                              LocaleKeys.forgotPasswordVerify.locale(context),
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.028,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
