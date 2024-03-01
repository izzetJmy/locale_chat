import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/firebase_options.dart';
import 'package:locale_chat/pages/control_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        body: Center(child: ControlPage()),
      ),
    );
  }
}
