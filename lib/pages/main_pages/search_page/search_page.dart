import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locale_chat/comopnents/my_appbar.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_snackbar.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/helper/ui_helper.dart';
import 'package:locale_chat/model/location_model.dart';
import 'package:locale_chat/pages/main_pages/search_page/map_screen.dart';
import 'package:locale_chat/pages/main_pages/search_page/list_screen.dart';
import 'package:locale_chat/pages/notification_pages/notification_page.dart';
import 'package:locale_chat/provider/location_change_notifier/locaiton_change_notifier.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late PageController _pageController;
  int selectedIndex = 0;
  late LocationChangeNotifier locationChangeNotifier;

  @override
  void initState() {
    _pageController = PageController(initialPage: selectedIndex);
    locationChangeNotifier = LocationChangeNotifier();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void navigateToPage(int index) {
    if (index == selectedIndex) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.jumpToPage(index);
      setState(() {
        selectedIndex = index;
      });
    }
  }

  bool isEmpty = false;
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: const ProfileInfo(
            image_path: 'assets/images/user_avatar.png',
            image_radius: 17,
          ),
          title: Text(
            'İzzet Şef',
            style: appBarTitleTextStyle,
          ),
          subtitle: Text(
            'Günaydın',
            style: appBarSubTitleTextStyle,
          ),
          trailing: IconButton(
            color: backgroundColor,
            icon: const Icon(CupertinoIcons.bell_fill),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationPage(),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // List Button
                MyButton(
                  width: UIHelper.getDeviceWith(context) * 0.42,
                  height: UIHelper.getDeviceHeight(context) * 0.048,
                  buttonColor: selectedIndex == 0
                      ? backgroundColor
                      : const Color(0xffDDF0E4),
                  onPressed: () {
                    setState(() {
                      navigateToPage(0);
                    });
                  },
                  buttonText: 'Liste',
                  textStyle: homePageButtontitleTextStyle,
                ),
                const Spacer(),
                // Map Button
                MyButton(
                  width: UIHelper.getDeviceWith(context) * 0.42,
                  height: UIHelper.getDeviceHeight(context) * 0.048,
                  buttonColor: selectedIndex == 1
                      ? backgroundColor
                      : const Color(0xffDDF0E4),
                  onPressed: () async {
                    setState(() {
                      navigateToPage(1);

                      if (locationChangeNotifier.isValidPermission == null) {
                        locationChangeNotifier.handleLocaitonPermission();
                      } else if (locationChangeNotifier.isValidPermission ==
                          false) {
                        MySanckbar.mySnackbar(
                          context,
                          'Konum izni verilmedi',
                          2,
                        );
                        return;
                      }
                    });
                    await locationChangeNotifier.getOtherLocaitons();
                    await locationChangeNotifier.getCurrentLocaiton();
                    await locationChangeNotifier.getNearUsersLocation();
                  },
                  buttonText: 'Harita',
                  textStyle: homePageButtontitleTextStyle,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Divider(
                thickness: 1,
                color: Color(0xffCBCBCB),
              ),
            ),
            // Where the list and map were created
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  ListScreen(isEmpty: isEmpty),
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: backgroundColor, width: 3),
                      ),
                      child: const MapScreen()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
