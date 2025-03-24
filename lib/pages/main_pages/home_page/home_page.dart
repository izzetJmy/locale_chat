import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_appbar.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/helper/ui_helper.dart';
import 'package:locale_chat/pages/main_pages/home_page/chat_screen_widget.dart';
import 'package:locale_chat/pages/main_pages/home_page/group_screen_widget.dart';
import 'package:locale_chat/pages/notification_pages/notification_page.dart';
import 'package:locale_chat/provider/chat_change_notifier/chat_change_notifier.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int selectedIndex = 0;
  late ChatChangeNotifier _chatChangeNotifier;

  @override
  void initState() {
    _pageController = PageController(initialPage: selectedIndex);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chatChangeNotifier = ChatChangeNotifier();
    _loadChats();
  }

  void _loadChats() {
    // Initialize chats list if null
    _chatChangeNotifier.chats ??= [];

    // Load chats from service
    _chatChangeNotifier.getChat('');
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
                //List Button
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
                    buttonText: 'Chat',
                    textStyle: homePageButtontitleTextStyle),
                const Spacer(),
                //Map Button
                MyButton(
                    width: UIHelper.getDeviceWith(context) * 0.42,
                    height: UIHelper.getDeviceHeight(context) * 0.048,
                    buttonColor: selectedIndex == 1
                        ? backgroundColor
                        : const Color(0xffDDF0E4),
                    onPressed: () {
                      setState(
                        () {
                          navigateToPage(1);
                        },
                      );
                    },
                    buttonText: 'Grup',
                    textStyle: homePageButtontitleTextStyle)
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Divider(
                thickness: 1,
                color: Color(0xffCBCBCB),
              ),
            ),
            //Where the chat and group were created
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: const [
                  ChatScreenWidget(),
                  GroupScreenWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
