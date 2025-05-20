import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/firebase_options.dart';
import 'package:locale_chat/pages/initial_control_page/initial_control_page.dart';
import 'package:locale_chat/pages/root_page/root_page.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:locale_chat/provider/chat_change_notifier/chat_change_notifier.dart';
import 'package:locale_chat/provider/group_change_notifier/group_change_notifier.dart';
import 'package:locale_chat/provider/location_change_notifier/locaiton_change_notifier.dart';

bool seenOnboarding = true;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final authChangeNotifier = AuthChangeNotifier();
  final chatChangeNotifier = ChatChangeNotifier();
  final groupChangeNotifier = GroupChangeNotifier();
  final locationChangeNotifier = LocationChangeNotifier();

  @override
  Widget build(BuildContext context) {
    return RootPage(
      authChangeNotifier: authChangeNotifier,
      chatChangeNotifier: chatChangeNotifier,
      groupChangeNotifier: groupChangeNotifier,
      locationChangeNotifier: locationChangeNotifier,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Locale Chat',
        home: InitialControlPage(), //onboarding page and splash screen control
      ),
    );
  }
}
