// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locale_chat/comopnents/my_appbar.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/comopnents/my_profile_card.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/comopnents/image_picker_helper.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/image_path.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/helper/ui_helper.dart';
import 'package:locale_chat/pages/auth_pages/login_page.dart';
import 'package:locale_chat/pages/create_group_pages/create_group_page.dart';
import 'package:locale_chat/pages/main_pages/profile_page/edit_profile_bottom_sheet.dart';
import 'package:locale_chat/pages/main_pages/profile_page/settings_bottom_sheet.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController editingController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to show image source selection dialog
  Future<void> _showImageSourceSelectionDialog() async {
    await ImagePickerHelper.showImageSourceSelectionDialog(
      context: context,
      onImageSourceSelected: (source) => _pickProfileImage(source),
    );
  }

  // Method to pick and upload profile image
  Future<void> _pickProfileImage(ImageSource source) async {
    await ImagePickerHelper.pickAndUploadImage(
      context: context,
      source: source,
    );
  }

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
              _showEditProfileBottomSheet();
            },
          )
        ],
      ),
      body: Center(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: UIHelper.getDeviceHeight(context) * 0.06),
            child: Consumer<AuthChangeNotifier>(
              builder: (context, authChangeNotifier, child) {
                return Column(
                  children: [
                    //User name and avatar
                    ProfileInfo(
                      image_path: authChangeNotifier.user?.profilePhoto ??
                          ImagePath.user_avatar,
                      image_radius: 35,
                      showName: true,
                      showDate: true,
                      name: authChangeNotifier.user?.userName.isEmpty ?? true
                          ? 'Anonymous'
                          : authChangeNotifier.user?.userName ?? 'Anonymous',
                      profileNameTextStyle: profileInfoNameTextStyle,
                      profileInfoDateTextStyle: profileInfoDateTextStyle,
                      date: formatDate(authChangeNotifier.user?.createdAt),
                      onTap: _showImageSourceSelectionDialog,
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
                      tittleText: Text(_auth.currentUser?.email ?? ''),
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
                      tittleText: const Text('Create Group'),
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
                      tittleText: const Text('Settings'),
                      profileCardTittleTextStyle: profilePageListTileTextStyle,
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: backgroundColor,
                      ),
                      onTap: () => _showSettingsBottomSheet(),
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
                      tittleText: const Text('Sign Out'),
                      profileCardTittleTextStyle: exitTitleTextStyle,
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.red.withOpacity(0.8),
                      ),
                      onTap: () => _handleSignOut(context, authChangeNotifier),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Edit profil bottom sheet'i gösterme metodu
  void _showEditProfileBottomSheet() {
    showModalBottomSheet(
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return EditProfileBottomSheet(editController: editingController);
      },
    );
  }

  // Ayarlar bottom sheet'i gösterme metodu
  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return SettingsBottomSheet(controller: controller);
      },
    );
  }

  // Çıkış işlemini yöneten fonksiyon
  Future<void> _handleSignOut(
      BuildContext context, AuthChangeNotifier authChangeNotifier) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: MyCircularProgressIndicator(),
        ),
      );
      await authChangeNotifier.signOut();

      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false, // Tüm önceki sayfaları kaldır
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong: ${e.toString()}')),
        );
      }
    }
  }
}

// Firebase timestamp'inden sadece gün.ay.yıl formatını çıkaran fonksiyon
String formatDate(String? timestamp) {
  if (timestamp == null || timestamp.isEmpty) return '12.12.2032';

  try {
    final date = DateTime.parse(timestamp);
    return '${date.day < 10 ? '0' : ''}${date.day}.${date.month < 10 ? '0' : ''}${date.month}.${date.year}';
  } catch (_) {
    return '12.12.2032';
  }
}
