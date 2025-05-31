// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/languages_keys.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/helper/localization_extention.dart';
import 'package:locale_chat/model/onboarding_model.dart';
import 'package:locale_chat/pages/auth_pages/login_page.dart';
import 'package:locale_chat/pages/control_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 5, vertical: size.height * 0.07),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //All pages created here
            allPages(size),
            const SizedBox(height: 20),
            //Button to go to next page
            nextButton(size, context),
            const SizedBox(height: 20),
            //Indicator showing which page you are on
            indicatorLines(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Expanded allPages(Size size) {
    return Expanded(
      child: PageView.builder(
        controller: _controller,
        itemCount: onboardingContent.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                image: AssetImage(onboardingContent[index].image_path),
                width: size.width * 0.8,
                height: size.height * 0.4,
              ),
              Text(
                onboardingContent[index].title,
                style: onboardingPageTitleTextStyle,
              ),
              Text(
                onboardingContent[index].discription,
                style: onboardingPageDiscriptionTextStyle,
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }

  MyButton nextButton(Size size, BuildContext context) {
    return MyButton(
      width: size.width * 0.5,
      height: size.height * 0.065,
      buttonColor: backgroundColor,
      buttonText: currentIndex == onboardingContent.length - 1
          ? LocaleKeys.onboardingContinue.locale(context)
          : LocaleKeys.onboardingNext.locale(context),
      textStyle: onboardingPageButtonTextTextStyle,
      onPressed: () async {
        if (currentIndex == onboardingContent.length - 1) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool("seenOnboarding", true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder:
                      (BuildContext context, AsyncSnapshot<User?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return MyCircularProgressIndicator();
                    } else if (snapshot.hasData && snapshot.data != null) {
                      return const ControlPage();
                    } else {
                      return LoginPage();
                    }
                  },
                );
              },
            ),
          );
        } else {
          _controller.nextPage(
              duration: const Duration(microseconds: 100),
              curve: Curves.bounceIn);
        }
      },
    );
  }

  Row indicatorLines() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingContent.length,
        (index) => Container(
          height: 8,
          width: 30,
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: currentIndex == index
                  ? backgroundColor
                  : backgroundColor.withOpacity(0.5)),
        ),
      ),
    );
  }
}
