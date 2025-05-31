import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/pages/auth_pages/auth_control_page.dart';
import 'package:locale_chat/pages/auth_pages/login_page.dart';
import 'package:locale_chat/pages/onboarding_pages/onboarding_page.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialControlPage extends StatelessWidget {
  const InitialControlPage({super.key});

  //SharedPreferences was used to show the onboarding page once
  Future<bool> _seenOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("seenOnboarding") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    //splash screen shows for 2 seconds if the user uses the application for the first time the onboarding page is shown
    //then the login page is displayed after the user logs in the user is directed to the control page.
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 1))
              .then((value) => _seenOnboarding()),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return MyCircularProgressIndicator();
            } else if (snapshot.hasData && snapshot.data == true) {
              return _authStreamBuilder(context);
            } else {
              return const OnboardingPage();
            }
          },
        ),
      ),
    );
  }

  StreamBuilder<User?> _authStreamBuilder(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MyCircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data != null) {
          User currentUser = snapshot.data!;
          // Ensure we have the latest user data
          currentUser.reload();

          // Load user data from Firestore
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<AuthChangeNotifier>(context, listen: false)
                .authStateChanges();
          });

          if (currentUser.emailVerified) {
            return const AuthControlPage();
          } else {
            return LoginPage();
          }
        } else {
          return LoginPage();
        }
      },
    );
  }
}
