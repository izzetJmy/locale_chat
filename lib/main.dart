import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/firebase_options.dart';
import 'package:locale_chat/pages/initial_control_page/initial_control_page.dart';
import 'package:locale_chat/pages/root_page/root_page.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:locale_chat/provider/chat_change_notifier/chat_change_notifier.dart';
import 'package:locale_chat/provider/general_change_notifier.dart';
import 'package:locale_chat/provider/group_change_notifier/group_change_notifier.dart';
import 'package:locale_chat/provider/location_change_notifier/locaiton_change_notifier.dart';
import 'package:locale_chat/provider/notification_change_notifier/notification_change_notifier.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:locale_chat/comopnents/network_check_widget.dart';

// Arka plan mesaj işleyici
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('main.dart: Arka planda mesaj alındı: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final authChangeNotifier = AuthChangeNotifier();
  final chatChangeNotifier = ChatChangeNotifier();
  final groupChangeNotifier = GroupChangeNotifier();
  final locationChangeNotifier = LocationChangeNotifier();
  final generalChangeNotifier = GeneralChangeNotifier();
  final notificationChangeNotifier = NotificationChangeNotifier();

  @override
  Widget build(BuildContext context) {
    return NetworkCheckWidget(
      child: RootPage(
        authChangeNotifier: authChangeNotifier,
        chatChangeNotifier: chatChangeNotifier,
        groupChangeNotifier: groupChangeNotifier,
        locationChangeNotifier: locationChangeNotifier,
        generalChangeNotifier: generalChangeNotifier,
        notificationChangeNotifier: notificationChangeNotifier,
        child: Consumer<GeneralChangeNotifier>(
          builder: (context, generalChangeNotifier, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Locale Chat',
              locale: generalChangeNotifier.currentLocale,
              themeMode: generalChangeNotifier.isDarkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,
              theme: ThemeData.light().copyWith(
                scaffoldBackgroundColor: generalBackgroundColor,
                appBarTheme: AppBarTheme(
                  backgroundColor: generalBackgroundColor,
                  elevation: 0,
                  iconTheme: IconThemeData(
                    color: generalChangeNotifier.isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                  titleTextStyle: TextStyle(
                    color: generalChangeNotifier.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              darkTheme: ThemeData.dark().copyWith(
                scaffoldBackgroundColor: generalBackgroundColor,
                appBarTheme: AppBarTheme(
                  backgroundColor: generalBackgroundColor,
                  elevation: 0,
                  iconTheme: IconThemeData(
                    color: generalChangeNotifier.isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                  titleTextStyle: TextStyle(
                    color: generalChangeNotifier.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'), // English
                Locale('tr'), // Turkish
              ],
              home: const InitialControlPage(),
            );
          },
        ),
      ),
    );
  }
}
