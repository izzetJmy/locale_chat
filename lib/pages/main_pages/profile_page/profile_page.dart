// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:locale_chat/comopnents/my_appbar.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_profile_card.dart';
import 'package:locale_chat/comopnents/my_text_field.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/image_path.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/helper/ui_helper.dart';
import 'package:locale_chat/pages/create_group_pages/create_group_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController controller = TextEditingController();

  final TextEditingController controoler1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text(
          'Profile',
          style: homePageTitleTextStyle,
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.create),
            color: backgroundColor,
            onPressed: () {
              showEditModalBottomSheetFunction(context, controoler1);
            },
          )
        ],
      ),
      body: Center(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: UIHelper.getDeviceHeight(context) * 0.06),
            child: Column(
              children: [
                //User name and avatar
                ProfileInfo(
                  image_path: ImagePath.user_avatar,
                  image_radius: 35,
                  showName: true,
                  showDate: true,
                  name: 'İzzet Şef',
                  profileNameTextStyle: profileInfoNameTextStyle,
                  profileInfoDateTextStyle: profileInfoDateTextStyle,
                  date: '12.12.2032',
                ),
                SizedBox(height: UIHelper.getDeviceHeight(context) * 0.04),
                //User email
                MyProfileCard(
                  height: 60,
                  containerRadius: 10,
                  leading: Icon(
                    Icons.email,
                    color: backgroundColor,
                  ),
                  tittleText: const Text('izzet@gmail.com'),
                  profileCardTittleTextStyle: profilePageListTileTextStyle,
                ),
                SizedBox(height: UIHelper.getDeviceHeight(context) * 0.02),
                //Create group
                MyProfileCard(
                  height: 60,
                  containerRadius: 10,
                  leading: Icon(
                    Icons.group,
                    color: backgroundColor,
                  ),
                  tittleText: const Text('Grup Oluştur'),
                  profileCardTittleTextStyle: profilePageListTileTextStyle,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: backgroundColor,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateGroupPage(),
                    ),
                  ),
                ),
                SizedBox(height: UIHelper.getDeviceHeight(context) * 0.02),
                //Settings
                MyProfileCard(
                  height: 60,
                  containerRadius: 10,
                  leading: Icon(
                    CupertinoIcons.settings,
                    color: backgroundColor,
                  ),
                  tittleText: const Text('Ayarlar'),
                  profileCardTittleTextStyle: profilePageListTileTextStyle,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: backgroundColor,
                  ),
                  onTap: () =>
                      showSettingsModalBottomSheetFunction(context, controller),
                ),
                SizedBox(height: UIHelper.getDeviceHeight(context) * 0.02),
                //Logout
                MyProfileCard(
                  height: 60,
                  containerRadius: 10,
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.red.withOpacity(0.8),
                  ),
                  tittleText: const Text('Çıkış yap'),
                  profileCardTittleTextStyle: exitTitleTextStyle,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.red.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<dynamic> showEditModalBottomSheetFunction(
    BuildContext context, TextEditingController controller) {
  return showModalBottomSheet(
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: UIHelper.getDeviceHeight(context) * 0.6,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: UIHelper.getDeviceWith(context) * 0.05,
              vertical: UIHelper.getDeviceWith(context) * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ProfileInfo(
                image_path: ImagePath.user_avatar,
                image_radius: 40,
                showName: true,
                showDate: true,
                name: 'İzzet Şef',
                profileNameTextStyle: profileInfoNameTextStyle,
                profileInfoDateTextStyle: profileInfoDateTextStyle,
                date: '12.12.2032',
              ),
              MyTextField(
                prefixIcon: Icon(
                  Icons.person,
                  color: backgroundColor,
                ),
                controller: TextEditingController(),
                hintText: 'İsim',
                borderRadius: 10,
                borderSideColor: Colors.transparent,
              ),
              MyProfileCard(
                height: 60,
                containerRadius: 10,
                leading: Icon(
                  Icons.lock,
                  color: backgroundColor,
                ),
                tittleText: const Text('Şifre değiştir'),
                profileCardTittleTextStyle: profilePageListTileTextStyle,
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: backgroundColor,
                ),
              ),
              const SizedBox(height: 20),
              MyButton(
                height: UIHelper.getDeviceHeight(context) * 0.06,
                width: UIHelper.getDeviceHeight(context) * 0.25,
                buttonColor: backgroundColor,
                buttonText: 'Oluştur',
                textStyle: onboardingPageButtonTextTextStyle,
                onPressed: () {},
              )
            ],
          ),
        ),
      );
    },
  );
}

Future<dynamic> showSettingsModalBottomSheetFunction(
    BuildContext context, TextEditingController controller) {
  return showModalBottomSheet(
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: UIHelper.getDeviceHeight(context) * 0.5,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: UIHelper.getDeviceWith(context) * 0.05,
              vertical: UIHelper.getDeviceWith(context) * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Ayarlar',
                style: profileInfoNameTextStyle,
              ),
              const SizedBox(height: 1),
              MyProfileCard(
                height: 60,
                containerRadius: 10,
                leading: Icon(
                  Icons.dark_mode,
                  color: backgroundColor,
                ),
                tittleText: const Text('Karanlık mod'),
                profileCardTittleTextStyle: profilePageListTileTextStyle,
                trailing: Icon(
                  Icons.toggle_off,
                  color: backgroundColor,
                  size: 40,
                ),
              ),
              MyProfileCard(
                height: 60,
                containerRadius: 10,
                leading: Icon(
                  Icons.language,
                  color: backgroundColor,
                ),
                tittleText: const Text('Diller'),
                profileCardTittleTextStyle: profilePageListTileTextStyle,
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: backgroundColor,
                ),
              ),
              MyProfileCard(
                height: 60,
                containerRadius: 10,
                leading: Icon(
                  Icons.delete,
                  color: Colors.red.withOpacity(0.8),
                ),
                tittleText: const Text('Hesabı sil'),
                profileCardTittleTextStyle: exitTitleTextStyle,
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.red.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      );
    },
  );
}
