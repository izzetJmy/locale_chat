import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_appbar.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_marquee.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/languages_keys.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/helper/localization_extention.dart';
import 'package:locale_chat/helper/ui_helper.dart';
import 'package:locale_chat/pages/main_pages/home_page/chat_screen_widget.dart';
import 'package:locale_chat/pages/main_pages/home_page/group_screen_widget.dart';
import 'package:locale_chat/pages/notification_pages/notification_page.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:locale_chat/provider/chat_change_notifier/chat_change_notifier.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int selectedIndex = 0;
  late ChatChangeNotifier _chatChangeNotifier;
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    _pageController = PageController(initialPage: selectedIndex);
    _chatChangeNotifier = ChatChangeNotifier();
    _loadChats();
    super.initState();
  }

  Future<void> _loadChats() async {
    _chatChangeNotifier.chats ??= [];
    _chatChangeNotifier.getChat('');
    final authChangeNotifier =
        Provider.of<AuthChangeNotifier>(context, listen: false);
    await authChangeNotifier.getUserInfo(currentUserId!);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _chatChangeNotifier.dispose();
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
                title: MyMarquee(
                  textToMeasure:
                      authChangeNotifier.user?.userName ?? 'Anonymus',
                  child: Text(
                    authChangeNotifier.user?.userName ?? 'Anonymus',
                    style: appBarTitleTextStyle,
                  ),
                ),
                subtitle: Text(
                  authChangeNotifier.getTimeOfDay(context),
                  style: appBarSubTitleTextStyle,
                ),
                trailing: IconButton(
                  color: iconColor,
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
                  //List Button
                  MyButton(
                      width: width * 0.42,
                      height: hegiht * 0.048,
                      buttonColor: selectedIndex == 0
                          ? const Color(0xffAAD9BB)
                          : profileCardColor,
                      onPressed: () {
                        setState(() {
                          navigateToPage(0);
                        });
                      },
                      buttonText: LocaleKeys.navigationChat.locale(context),
                      textStyle: homePageButtontitleTextStyle),
                  const Spacer(),
                  //Map Button
                  MyButton(
                      width: width * 0.42,
                      height: hegiht * 0.048,
                      buttonColor: selectedIndex == 1
                          ? const Color(0xffAAD9BB)
                          : profileCardColor,
                      onPressed: () {
                        setState(
                          () {
                            navigateToPage(1);
                          },
                        );
                      },
                      buttonText: LocaleKeys.navigationGroup.locale(context),
                      textStyle: homePageButtontitleTextStyle)
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
            //Where the chat and group were created
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: const ChatScreenWidget(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: const GroupScreenWidget(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
