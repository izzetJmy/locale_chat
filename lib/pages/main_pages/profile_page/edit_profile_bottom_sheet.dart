import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locale_chat/comopnents/image_picker_helper.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/comopnents/my_profile_card.dart';
import 'package:locale_chat/comopnents/my_snackbar.dart';
import 'package:locale_chat/comopnents/my_text_field.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/image_path.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/helper/ui_helper.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:provider/provider.dart';

class EditProfileBottomSheet extends StatefulWidget {
  final TextEditingController editController;

  const EditProfileBottomSheet({
    Key? key,
    required this.editController,
  }) : super(key: key);

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  // Method to show image source selection dialog
  Future<void> _showImageSourceSelectionDialog() async {
    await ImagePickerHelper.showImageSourceSelectionDialog(
      context: context,
      onImageSourceSelected: (source) => _pickProfileImage(source),
    );
  }

  // Method to pick and upload profile image
  Future<void> _pickProfileImage(ImageSource source) async {
    await ImagePickerHelper.pickAndUploadProfileImage(
      context: context,
      source: source,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: UIHelper.getDeviceHeight(context) * 0.6,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: UIHelper.getDeviceWith(context) * 0.05,
            vertical: UIHelper.getDeviceWith(context) * 0.05),
        child: Consumer<AuthChangeNotifier>(
          builder: (context, authChangeNotifier, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ProfileInfo(
                  image_path: authChangeNotifier.user?.profilePhoto != null &&
                          authChangeNotifier.user!.profilePhoto.isNotEmpty
                      ? authChangeNotifier.user!.profilePhoto
                      : ImagePath.user_avatar,
                  image_radius: 40,
                  showName: true,
                  showDate: true,
                  name: authChangeNotifier.user?.userName ?? 'Anonymous',
                  profileNameTextStyle: profileInfoNameTextStyle,
                  profileInfoDateTextStyle: profileInfoDateTextStyle,
                  date: formatDate(authChangeNotifier.user?.createdAt),
                  isNetworkImage:
                      authChangeNotifier.user?.profilePhoto != null &&
                          authChangeNotifier.user!.profilePhoto.isNotEmpty,
                  onTap: _showImageSourceSelectionDialog,
                ),
                MyTextField(
                  prefixIcon: Icon(
                    Icons.person,
                    color: backgroundColor,
                  ),
                  controller: widget.editController,
                  hintText: 'Name',
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
                  tittleText: const Text('Change Password'),
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
                  buttonText: 'Change',
                  textStyle: onboardingPageButtonTextTextStyle,
                  onPressed: () async {
                    if (widget.editController.text.isEmpty) {
                      MySanckbar.mySnackbar(
                          context, 'Please enter a username', 2);
                      return;
                    }

                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Center(
                          child: MyCircularProgressIndicator(),
                        );
                      },
                    );
                    try {
                      await authChangeNotifier
                          .updateUserName(widget.editController.text);

                      if (context.mounted) Navigator.of(context).pop();
                      if (context.mounted) Navigator.of(context).pop();
                      // Show success message
                      if (context.mounted) {
                        MySanckbar.mySnackbar(
                            context, 'Username updated successfully', 2);
                      }
                      widget.editController.clear();
                    } catch (e) {
                      // Close loading dialog
                      if (context.mounted) Navigator.of(context).pop();

                      // Show error message
                      if (context.mounted) {
                        MySanckbar.mySnackbar(
                            context, 'Error updating username', 2);
                      }
                    }
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

// Helper function to show the edit profile bottom sheet
Future<dynamic> showEditProfileBottomSheet(
    BuildContext context, TextEditingController editController) {
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
      return EditProfileBottomSheet(editController: editController);
    },
  );
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
