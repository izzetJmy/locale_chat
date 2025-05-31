// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
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

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late AuthChangeNotifier authChangeNotifier;
  @override
  void initState() {
    super.initState();
    authChangeNotifier =
        Provider.of<AuthChangeNotifier>(context, listen: false);

    // Build aşamasından sonra çalışması için Future.microtask kullanıyoruz
    Future.microtask(() => _initializePasswordReset());
  }

  Future<void> _initializePasswordReset() async {
    if (!mounted) return;

    try {
      debugPrint(authChangeNotifier.otpEmailController);
      await authChangeNotifier.updatePassword(
          email: authChangeNotifier.otpEmailController);

      if (!mounted) return;
      MySanckbar.mySnackbar(
          context, LocaleKeys.resetPasswordLinkSent.locale(context), 2);
    } catch (e) {
      if (!mounted) return;
      MySanckbar.mySnackbar(context, e.toString(), 2);
    } finally {
      if (!mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/login_image.png'),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: MyLoginCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                column: Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      LocaleKeys.resetPasswordCheckEmail.locale(context),
                      style: TextStyle(
                        color: defaultTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    MyCircularProgressIndicator(
                      progressIndicatorColor: defaultTextColor,
                    ),
                    SizedBox(height: size.height * 0.02),
                    MyButton(
                      width: size.width * 0.5,
                      height: size.height * 0.05,
                      buttonColor: const Color(0xffAAD9BB),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      // onPressed: () async {
                      //   if (_formKey.currentState!.validate()) {
                      //     await authChangeNotifier.updatePassword(
                      //         email: authChangeNotifier.otpEmailController);

                      //     if (firebaseAuthErrors.isNotEmpty) {
                      //       MySanckbar.mySnackbar(
                      //           context, firebaseAuthErrors.first.message, 2);
                      //     } else {
                      //       if (authChangeNotifier.state ==
                      //           AsyncChangeNotifierState.idle) {
                      //         MySanckbar.mySnackbar(
                      //             context,
                      //             LocaleKeys
                      //                 .errorsAuthPasswordChangedToSuccessful
                      //                 .locale(context),
                      //             2);
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => LoginPage(),
                      //           ),
                      //         );
                      //       }
                      //     }
                      //   }
                      // },
                      buttonText:
                          LocaleKeys.resetPasswordBackToLogin.locale(context),
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
      ),
    );
  }
}
