// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/login_card.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_text_field.dart';
import 'package:locale_chat/pages/auth_pages/login_page.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
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
                      MyTextField(
                        controller: confirmPasswordController,
                        prefixIcon: const Icon(CupertinoIcons.lock),
                        hintText: 'Confirm Password',
                        obscureText: true,
                        suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.remove_red_eye)),
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
      ),
    );
  }
}
