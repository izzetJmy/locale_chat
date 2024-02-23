import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/login_card.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/pin_put.dart';
import 'package:locale_chat/pages/auth_pages/reset_password.dart';

class SentCodePage extends StatelessWidget {
  SentCodePage({super.key});
  final List<TextEditingController> controllerList =
      List.generate(6, (index) => TextEditingController());

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
                      'Enter the email you want to change your password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff828282),
                          fontSize: size.height * 0.024),
                    ),
                    PinPut(),
                    MyButton(
                      width: size.width * 0.5,
                      height: size.height * 0.05,
                      buttonColor: Color(0xffAAD9BB),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ResetPasswordPage(),
                          ),
                        );
                      },
                      buttonText: 'Verify',
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
        ),
      ),
    );
  }
}
