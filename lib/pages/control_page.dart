import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/button_navigator_bar.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/pages/main_pages/home_page/home_page.dart';
import 'package:locale_chat/pages/main_pages/profile_page/profile_page.dart';
import 'package:locale_chat/pages/main_pages/search_page/search_page.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  late PageController _pageController;
  int selectedTap = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: selectedTap);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void navigateToPage(int index) {
    if (index == selectedTap) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.jumpToPage(index);
      setState(() {
        selectedTap = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (value) {
              setState(() {
                selectedTap = value;
              });
            },
            children: const [
              SearchPage(),
              HomePage(),
              ProfilePage(),
            ],
          ),
          bottomNavigatorBar(size)
        ],
      ),
    );
  }

  Stack bottomNavigatorBar(Size size) {
    return Stack(
      children: [
        //BottomAppBar was created here
        Align(
          alignment: Alignment.bottomCenter,
          child: MyNavigatorBar(
            pageIndex: selectedTap,
            onTap: navigateToPage,
          ),
        ),
        //Search button created here
        Positioned(
          left: size.width / 2.5,
          right: size.width / 2.5,
          top: size.height * 0.85,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              setState(() {
                navigateToPage(0);
              });
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  boxShadow: searchButtonBoxShadow,
                  shape: BoxShape.circle,
                  color: backgroundColor),
              child: Icon(
                CupertinoIcons.search,
                color: selectedTap == 0
                    ? Colors.black.withOpacity(0.8)
                    : Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
