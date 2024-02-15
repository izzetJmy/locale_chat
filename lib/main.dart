import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_appbar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
          appBar: MyAppBar(
            leading: Icon(Icons.back_hand),
            title: Text('dada'),
          ),
          body: Center(),
        ));
  }
}
