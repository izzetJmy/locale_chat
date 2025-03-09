import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_profile_card.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/helper/ui_helper.dart';

class SettingsBottomSheet extends StatelessWidget {
  final TextEditingController controller;

  const SettingsBottomSheet({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              'Settings',
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
              tittleText: const Text('Dark Mode'),
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
              tittleText: const Text('Languages'),
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
              tittleText: const Text('Delete Account'),
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
  }
}

// Helper function to show the settings bottom sheet
Future<dynamic> showSettingsBottomSheet(
    BuildContext context, TextEditingController controller) {
  return showModalBottomSheet(
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    context: context,
    builder: (BuildContext context) {
      return SettingsBottomSheet(controller: controller);
    },
  );
}
