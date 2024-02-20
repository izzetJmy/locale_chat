// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/login_card.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_text_field.dart';
import 'package:locale_chat/pages/auth_pages/forgot_password_page.dart';
import 'package:locale_chat/pages/auth_pages/register_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  LoginPage({super.key});

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
        child: SizedBox(
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
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                child: MyLoginCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  column: Column(
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
                      ),
                      MyTextField(
                        controller: passwordController,
                        prefixIcon: const Icon(CupertinoIcons.lock),
                        hintText: 'Password',
                        obscureText: true,
                        suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.remove_red_eye)),
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
                          width: size.width * 0.5,
                          height: size.height * 0.05,
                          buttonColor: Color(0xffAAD9BB),
                          onPressed: () {},
                          buttonText: 'Login',
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
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Divider(
                          endIndent: size.width * 0.03,
                          indent: size.width * 0.3,
                          thickness: 2,
                          color: const Color(0xffD7D7D7),
                        ),
                      ),
                      Text(
                        'OR',
                        style: TextStyle(
                            fontSize: size.height * 0.023,
                            color: const Color(0xffD7D7D7),
                            fontFamily: 'Roboto'),
                      ),
                      Expanded(
                        child: Divider(
                          endIndent: size.width * 0.3,
                          indent: size.width * 0.03,
                          thickness: 2,
                          color: const Color(0xffD7D7D7),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      signIn_container(size, 'google_icon'),
                      signIn_container(size, 'facebook_icon'),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Container signIn_container(Size size, String iconName) {
    return Container(
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
    );
  }
}
