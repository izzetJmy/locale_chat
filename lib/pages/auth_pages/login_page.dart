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
import 'package:locale_chat/constants/languages_keys.dart';
import 'package:locale_chat/helper/localization_extention.dart';
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
  bool _isGoogleLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false, //klavye
      body: SingleChildScrollView(
        child: Container(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.loginRegisterWelcome.locale(context),
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
                                  LocaleKeys.loginRegisterLogin.locale(context),
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
                                hintText: LocaleKeys.loginRegisterEmail
                                    .locale(context),
                                obscureText: false,
                                validatorFunction: (value) {
                                  if (value != null) {
                                    if (value.length > 5 &&
                                        value.contains('@') &&
                                        value.endsWith('.com')) {
                                      return null;
                                    }
                                    return LocaleKeys
                                        .errorsAuthEnterAFValidEmailAddress
                                        .locale(context);
                                  }
                                  return null;
                                },
                              ),
                              MyTextField(
                                controller: passwordController,
                                prefixIcon: const Icon(CupertinoIcons.lock),
                                hintText: LocaleKeys.loginRegisterPassword
                                    .locale(context),
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
                                    return LocaleKeys.loginRegisterEnterPassword
                                        .locale(context);
                                  }
                                  if (value.length < 6) {
                                    return LocaleKeys
                                        .loginRegisterEnter6DigitPassword
                                        .locale(context);
                                  }
                                  return null;
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    if (mounted) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPasswordPage(),
                                      ));
                                    }
                                  },
                                  child: Text(
                                    LocaleKeys.loginRegisterForgotPassword
                                        .locale(context),
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
                                          LocaleKeys.loginRegisterLogin
                                              .locale(context),
                                          style: TextStyle(
                                              fontSize: size.height * 0.028,
                                              color: Colors.white,
                                              fontFamily: 'Roboto'),
                                        ),
                                  width: size.width * 0.5,
                                  height: size.height * 0.05,
                                  buttonColor: Color(0xffAAD9BB),
                                  buttonText: LocaleKeys.loginRegisterLogin
                                      .locale(context),
                                  textStyle: TextStyle(
                                      fontSize: size.height * 0.028,
                                      color: Colors.white,
                                      fontFamily: 'Roboto'),
                                  onPressed: () async {
                                    if (mounted) {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                    }
                                    if (_formKey.currentState!.validate()) {
                                      // User Login
                                      UserModel? user =
                                          await authChangeNotifier.signIn(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                      );

                                      // Hata kontrolü - tek satırda
                                      authChangeNotifier
                                              .getFirebaseAuthErrors(
                                                  'firebaseAuthLogin')
                                              .isNotEmpty
                                          ? MySanckbar.mySnackbar(
                                              context,
                                              authChangeNotifier
                                                  .getFirebaseAuthErrors(
                                                      'firebaseAuthLogin')
                                                  .first
                                                  .message,
                                              2)
                                          : user != null
                                              ? FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .emailVerified
                                                  ? (
                                                      MySanckbar.mySnackbar(
                                                          context,
                                                          LocaleKeys
                                                              .errorsAuthLoginSuccess
                                                              .locale(context),
                                                          1),
                                                      mounted
                                                          ? Navigator.of(
                                                                  context)
                                                              .pushReplacement(
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const ControlPage(),
                                                              ),
                                                            )
                                                          : null
                                                    )
                                                  : (
                                                      MySanckbar.mySnackbar(
                                                          context,
                                                          LocaleKeys
                                                              .errorsAuthPleaseVerifyYourEmail
                                                              .locale(context),
                                                          2),
                                                      authChangeNotifier
                                                          .signOut()
                                                    )
                                              : null;
                                    }

                                    if (mounted) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LocaleKeys.loginRegisterDontHaveAccount
                                        .locale(context),
                                    style: TextStyle(
                                        color: Color(0xffB7B7B7),
                                        fontSize: size.height * 0.015),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (mounted) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterPage(),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      LocaleKeys.loginRegisterSignUp
                                          .locale(context),
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
                                // Google loading durumunu başlat
                                if (mounted) {
                                  setState(() {
                                    _isGoogleLoading = true;
                                  });
                                }

                                UserModel? user =
                                    await authChangeNotifier.authWithGoogle();

                                if (!mounted) return;

                                // Tek satırda hata kontrolü ve yönlendirme
                                authChangeNotifier
                                        .getFirebaseAuthErrors(
                                            'firebaseAuthGoogle')
                                        .isNotEmpty
                                    ? MySanckbar.mySnackbar(
                                        context,
                                        authChangeNotifier
                                            .getFirebaseAuthErrors(
                                                'firebaseAuthGoogle')
                                            .first
                                            .message,
                                        2)
                                    : user != null
                                        ? (
                                            MySanckbar.mySnackbar(
                                                context,
                                                LocaleKeys
                                                    .errorsAuthGoogleLoginSuccess
                                                    .locale(context),
                                                1),
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ControlPage()),
                                            )
                                          )
                                        : null;

                                // Google loading durumunu bitir
                                if (mounted) {
                                  setState(() {
                                    _isGoogleLoading = false;
                                  });
                                }
                              },
                              isLoading: _isGoogleLoading,
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
      ),
    );
  }

  InkWell signIn_container(Size size, String iconName, Function() onTap,
      {bool isLoading = false}) {
    return InkWell(
      onTap: isLoading ? null : onTap,
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
        child: isLoading
            ? MyCircularProgressIndicator(
                height: 20,
                width: 20,
                progressIndicatorColor: const Color(0xff939393),
              )
            : Image(
                fit: BoxFit.fill,
                color: const Color(0xff939393),
                image: AssetImage('assets/images/$iconName.png'),
              ),
      ),
    );
  }
}
