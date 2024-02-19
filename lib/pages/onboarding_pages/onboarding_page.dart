import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/model/onboarding_model.dart';
import 'package:locale_chat/pages/control_page.dart';

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
            const SizedBox(height: 60),
            //Button to go to next page
            nextButton(size, context),
            const SizedBox(height: 30),
            //Indicator showing which page you are on
            indicatorLines(),
            const SizedBox(height: 40),
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
      buttonText:
          currentIndex == onboardingContent.length - 1 ? 'Devam et' : 'Sonraki',
      textStyle: onboardingPageButtonTextTextStyle,
      onPressed: () {
        if (currentIndex == onboardingContent.length - 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ControlPage(),
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
