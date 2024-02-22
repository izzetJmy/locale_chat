import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_profile_card.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/image_path.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/helper/ui_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final listContainerNavKey = GlobalKey<NavigatorState>();
  final mapContainerNavKey = GlobalKey<NavigatorState>();
  List<Widget> screens = [];
  @override
  void initState() {
    screens = [chatScreen(), groupScreen()];
    super.initState();
  }

  int selectedIndex = 0;
  bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        selectedIndex = 0;
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
                      setState(() {
                        selectedIndex = 1;
                      });
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
              child: IndexedStack(
                index: selectedIndex,
                children: screens
                    .map(
                      (page) => Navigator(
                        onGenerateInitialRoutes: (navigator, initialRoute) {
                          return [
                            MaterialPageRoute(builder: (context) => page),
                          ];
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatScreen() {
    return isEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Henüz biriyle tanışmadın',
                  style: homePageTitleTextStyle,
                ),
                Text(
                  'Hemen arama yap!',
                  style: homePageSubtitleTextStyle,
                )
              ],
            ),
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: MyProfileCard(
                    leading: ProfileInfo(image_path: ImagePath.user_avatar),
                    tittleText: Text('Asım Şef'),
                    subtittleText: Text('selam'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: backgroundColor,
                    ),
                    height: 80),
              );
            },
          );
  }

  Widget groupScreen() {
    return isEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Henüz bir grupta değilsin',
                  style: homePageTitleTextStyle,
                ),
                Text(
                  'hemen yeni bir grup oluştur.',
                  style: homePageSubtitleTextStyle,
                )
              ],
            ),
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: MyProfileCard(
                    leading: const ProfileInfo(
                        image_path: 'assets/images/user_avatar.png'),
                    tittleText: Text('Grup Adı'),
                    subtittleText: const Text('4 kişi var'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: backgroundColor,
                    ),
                    height: 80),
              );
            },
          );
  }
}
