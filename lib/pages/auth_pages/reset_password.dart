import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/login_card.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_text_field.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPsswordController =
      TextEditingController();

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
                        controller: passwordController,
                        prefixIcon: const Icon(CupertinoIcons.lock),
                        hintText: 'New password',
                        obscureText: false,
                        suffixIcon: IconButton(
                            onPressed: () {}, icon: Icon(Icons.remove_red_eye)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child: MyTextField(
                        controller: confirmPsswordController,
                        prefixIcon: const Icon(CupertinoIcons.lock),
                        hintText: 'Confirm password',
                        obscureText: false,
                        suffixIcon: IconButton(
                            onPressed: () {}, icon: Icon(Icons.remove_red_eye)),
                      ),
                    ),
                    MyButton(
                      width: size.width * 0.5,
                      height: size.height * 0.05,
                      buttonColor: Color(0xffAAD9BB),
                      onPressed: () {},
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
      ),
    );
  }
}
