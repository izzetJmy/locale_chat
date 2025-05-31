import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locale_chat/comopnents/image_picker_helper.dart';
import 'package:locale_chat/comopnents/my_appbar.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/comopnents/my_profile_card.dart';
import 'package:locale_chat/comopnents/my_snackbar.dart';
import 'package:locale_chat/comopnents/my_text_field.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/image_path.dart';
import 'package:locale_chat/constants/languages_keys.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/helper/localization_extention.dart';
import 'package:locale_chat/helper/ui_helper.dart';
import 'package:locale_chat/model/messages_models/group_chat_model.dart';
import 'package:locale_chat/model/user_model.dart';
import 'package:locale_chat/provider/group_change_notifier/group_change_notifier.dart';
import 'package:uuid/uuid.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  TextEditingController controller = TextEditingController();
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();
  late GroupChangeNotifier _groupChangeNotifier;
  String? imageURL;
  String? groupId;
  List<UserModel> selectedMembers = [];
  bool isSelected = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _groupChangeNotifier = GroupChangeNotifier();
    groupId = _uuid.v4();
  }

  Future<void> _showImageSourceSelectionDialog() async {
    await ImagePickerHelper.showImageSourceSelectionDialog(
      context: context,
      onImageSourceSelected: (source) => _pickProfileImage(source),
    );
  }

  Future<void> _pickProfileImage(ImageSource source) async {
    File? selectedImagePath = await _groupChangeNotifier.getGroupImage(source);
    if (selectedImagePath == null) return;
    String? imageUrl = await _groupChangeNotifier.uploadGroupProfileImage(
        selectedImagePath, groupId!);
    setState(() {
      imageURL = imageUrl;
    });
  }

  Future<void> _createGroup() async {
    if (controller.text.trim().isEmpty) {
      MySanckbar.mySnackbar(context,
          LocaleKeys.errorsGroupPleaseEnterAGroupName.locale(context), 2);
      return;
    }

    if (imageURL == null) {
      MySanckbar.mySnackbar(context,
          LocaleKeys.errorsGroupPleaseSelectAGroupImage.locale(context), 2);
      return;
    }

    if (selectedMembers.isEmpty) {
      MySanckbar.mySnackbar(
          context,
          LocaleKeys.errorsGroupPleaseSelectAtLeastOneMember.locale(context),
          2);

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final groupName = controller.text.trim();
      final groupImage = imageURL;
      final createdTime = DateTime.now();

      final groupData = GroupChatModel(
          groupId: groupId!,
          groupName: groupName,
          groupProfilePhoto: groupImage,
          members: [],
          createdTime: createdTime,
          createdId: _currentUserId,
          adminEmail: _currentUserId);

      await _groupChangeNotifier.createGroup(groupData, selectedMembers);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        MySanckbar.mySnackbar(context,
            LocaleKeys.errorsGroupErrorCreatingGroup.locale(context), 2);
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _toggleUserSelection(UserModel user, int index) {
    setState(() {
      if (isSelected) {
        selectedMembers.removeAt(index);
      } else {
        selectedMembers.add(user);
      }
      isSelected = !isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: backgroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(LocaleKeys.groupCreateGroup.locale(context),
            style: homePageTitleTextStyle),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
              top: UIHelper.getDeviceHeight(context) * 0.01,
              bottom: UIHelper.getDeviceHeight(context) * 0.05,
              left: UIHelper.getDeviceHeight(context) * 0.03,
              right: UIHelper.getDeviceHeight(context) * 0.03),
          child: Column(
            children: [
              //Create group photo
              ProfileInfo(
                image_path: imageURL ?? ImagePath.group_avatar,
                image_radius: 40,
                onTap: _showImageSourceSelectionDialog,
              ),
              const SizedBox(height: 10),
              //Create group name
              MyTextField(
                prefixIcon: Icon(
                  Icons.group,
                  color: backgroundColor,
                ),
                controller: controller,
                hintText: LocaleKeys.groupGroupName.locale(context),
                borderRadius: 10,
                borderSideColor: Colors.transparent,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  thickness: 1,
                  color: Color(0xffCBCBCB),
                ),
              ),
              //Add user for group
              Expanded(
                child: StreamBuilder(
                  stream: _firestore.collection('Users').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: MyCircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              LocaleKeys.errorsGroupNoUsersFound
                                  .locale(context),
                              style: homePageTitleTextStyle,
                            ),
                          ],
                        ),
                      );
                    }
                    final users = snapshot.data!.docs.map((doc) {
                      return UserModel.fromJson(doc.data());
                    }).toList();
                    users.removeWhere((user) => user.id == _currentUserId);
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return MyProfileCard(
                          leading: ProfileInfo(
                            image_path: user.profilePhoto,
                          ),
                          tittleText: Text(user.userName),
                          trailing: Icon(
                            isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: backgroundColor,
                          ),
                          height: 80,
                          onTap: () => _toggleUserSelection(user, index),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              //Button of create group
              MyButton(
                height: UIHelper.getDeviceHeight(context) * 0.06,
                width: UIHelper.getDeviceHeight(context) * 0.25,
                buttonColor: backgroundColor,
                buttonText: LocaleKeys.groupCreate.locale(context),
                textStyle: onboardingPageButtonTextTextStyle,
                onPressed: _createGroup,
                button: isLoading ? MyCircularProgressIndicator() : null,
              )
            ],
          ),
        ),
      ),
    );
  }
}
