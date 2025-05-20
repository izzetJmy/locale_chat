//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_appbar.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_snackbar.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/helper/ui_helper.dart';
import 'package:locale_chat/pages/main_pages/search_page/map_screen.dart';
import 'package:locale_chat/pages/main_pages/search_page/list_screen.dart';
import 'package:locale_chat/pages/notification_pages/notification_page.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:locale_chat/provider/location_change_notifier/locaiton_change_notifier.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late PageController _pageController;
  int selectedIndex = 0;
  late LocationChangeNotifier locationChangeNotifier;
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  @override
  void initState() {
    _pageController = PageController(initialPage: selectedIndex);
    locationChangeNotifier = LocationChangeNotifier();
    final authChangeNotifier =
        Provider.of<AuthChangeNotifier>(context, listen: false);
    authChangeNotifier.getUserInfo(currentUserId!);
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
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final String _userID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    double hegiht = UIHelper.getDeviceHeight(context).toDouble();
    double width = UIHelper.getDeviceWith(context).toDouble();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(hegiht * 0.08),
        child: Consumer<AuthChangeNotifier>(
          builder: (context, authChangeNotifier, child) {
            return MyAppBar(
              title: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: ProfileInfo(
                  image_path: authChangeNotifier.user?.profilePhoto ??
                      'assets/images/user_avatar.png',
                  image_radius: 17,
                ),
                title: Text(
                  authChangeNotifier.user?.userName ?? 'Anonymus',
                  style: appBarTitleTextStyle,
                ),
                subtitle: Text(
                  authChangeNotifier.getTimeOfDay(),
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
            );
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: hegiht * 0.02),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // List Button
                  MyButton(
                    width: width * 0.42,
                    height: hegiht * 0.048,
                    buttonColor: selectedIndex == 0
                        ? backgroundColor
                        : const Color(0xffDDF0E4),
                    onPressed: () {
                      setState(() {
                        navigateToPage(0);
                      });
                    },
                    buttonText: 'List',
                    textStyle: homePageButtontitleTextStyle,
                  ),
                  const Spacer(),
                  // Map Button
                  MyButton(
                    width: width * 0.42,
                    height: hegiht * 0.048,
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
                            'Location permission not granted',
                            2,
                          );
                          return;
                        }
                      });
                      await locationChangeNotifier.getOtherLocaitons();
                      await locationChangeNotifier.getCurrentLocaiton();
                      await locationChangeNotifier.getNearUsersLocation();
                    },
                    buttonText: 'Map',
                    textStyle: homePageButtontitleTextStyle,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: hegiht * 0.01, horizontal: width * 0.05),
              child: const Divider(
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: ListScreen(isEmpty: isEmpty),
                  ),
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
