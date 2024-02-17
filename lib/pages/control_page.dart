import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/button_navigator_bar.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/model/nav_model.dart';
import 'package:locale_chat/pages/home_page/home_page.dart';
import 'package:locale_chat/pages/profile_page/profile_page.dart';
import 'package:locale_chat/pages/search_page/search_page.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final homeNavKey = GlobalKey<NavigatorState>();
  final searchNavKey = GlobalKey<NavigatorState>();
  final profileNavKey = GlobalKey<NavigatorState>();
  int selectedTap = 0;
  List<NavModel> items = [];

  @override
  void initState() {
    items = [
      NavModel(page: const SearchPage(), navKey: searchNavKey),
      NavModel(page: const HomePage(), navKey: homeNavKey),
      NavModel(page: const ProfilePage(), navKey: profileNavKey),
    ];
    super.initState();
  }

  void navigateToPage(int index) {
    if (index == selectedTap) {
      items[index].navKey.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        selectedTap = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      //Used to indicate what to do if someone tries to go back while on the control page
      onWillPop: () {
        if (items[selectedTap].navKey.currentState?.canPop() ?? false) {
          items[selectedTap].navKey.currentState?.pop();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            //pages shown here
            Positioned.fill(
              child: IndexedStack(
                index: selectedTap,
                children: items
                    .map(
                      (page) => Navigator(
                        key: page.navKey,
                        onGenerateInitialRoutes: (navigator, initialRoute) {
                          return [
                            MaterialPageRoute(builder: (context) => page.page)
                          ];
                        },
                      ),
                    )
                    .toList(),
              ),
            ),

            //BottomAppBar was created here
            Positioned(
              left: 0,
              right: 0,
              bottom: Platform.isAndroid ? 16 : 8,
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
        ),
      ),
    );
  }
}
