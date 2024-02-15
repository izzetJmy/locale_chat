import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/login_card.dart';
import 'package:locale_chat/comopnents/my_button.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/login_image.png'),
                  fit: BoxFit.fill)),
          alignment: Alignment.center,
          child: const MyLoginCard(
            column: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text('<dfasdf>')],
            ),
            padding: EdgeInsets.all(10),
          ),
        ),
      ),
    );
  }
}
