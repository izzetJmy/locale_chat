import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_profile_card.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/languages_keys.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/helper/localization_extention.dart';
import 'package:locale_chat/helper/ui_helper.dart';
import 'package:locale_chat/provider/general_change_notifier.dart';
import 'package:provider/provider.dart';

class SettingsBottomSheet extends StatelessWidget {
  final TextEditingController controller;

  const SettingsBottomSheet({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GeneralChangeNotifier>(
      builder: (context, generalChangeNotifier, child) {
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
                  LocaleKeys.profileSettings.locale(context),
                  style: profileInfoNameTextStyle,
                ),
                const SizedBox(height: 1),
                MyProfileCard(
                  height: 60,
                  containerRadius: 10,
                  leading: Icon(
                    Icons.dark_mode,
                    color: iconColor,
                  ),
                  tittleText: Text(LocaleKeys.profileDarkMode.locale(context)),
                  profileCardTittleTextStyle: profilePageListTileTextStyle,
                  trailing: Switch(
                    activeColor: iconColor,
                    value: generalChangeNotifier.isDarkMode,
                    onChanged: (value) async {
                      await generalChangeNotifier.toggleThemeMode();
                    },
                  ),
                ),
                MyProfileCard(
                  height: 60,
                  containerRadius: 10,
                  leading: Icon(
                    Icons.language,
                    color: iconColor,
                  ),
                  tittleText: Text(LocaleKeys.profileLanguages.locale(context)),
                  profileCardTittleTextStyle: profilePageListTileTextStyle,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: iconColor,
                  ),
                  onTap: () {
                    _buildLanguageButton(context);
                  },
                ),
                MyProfileCard(
                  height: 60,
                  containerRadius: 10,
                  leading: Icon(
                    Icons.delete,
                    color: Colors.red.withOpacity(0.8),
                  ),
                  tittleText:
                      Text(LocaleKeys.profileDeleteAccount.locale(context)),
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

Future<dynamic> _buildLanguageButton(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => Consumer<GeneralChangeNotifier>(
      builder: (context, generalChangeNotifier, child) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: profileCardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () async {
                    await generalChangeNotifier.changeLanguage('en');
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  icon: Row(
                    children: [
                      const Text('🇺🇸   '),
                      Text('English',
                          style: TextStyle(color: defaultTextColor)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: profileCardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () async {
                    await generalChangeNotifier.changeLanguage('tr');
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  icon: Row(
                    children: [
                      const Text('🇹🇷   '),
                      Text('Turkish',
                          style: TextStyle(color: defaultTextColor)),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    ),
  );
}
