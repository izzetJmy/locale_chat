// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locale_chat/comopnents/image_picker_helper.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_snackbar.dart';
import 'package:locale_chat/comopnents/my_text_field.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/image_path.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/helper/ui_helper.dart';
import 'package:locale_chat/model/messages_models/group_chat_model.dart';
import 'package:locale_chat/provider/group_change_notifier/group_change_notifier.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditGroupDetailPage extends StatefulWidget {
  final TextEditingController editController;
  GroupChatModel group;

  EditGroupDetailPage({
    Key? key,
    required this.editController,
    required this.group,
  }) : super(key: key);

  @override
  State<EditGroupDetailPage> createState() => _EditGroupDetailPageState();
}

class _EditGroupDetailPageState extends State<EditGroupDetailPage> {
  bool isAdmin = false;
  bool isLoading = false;
  late GroupChangeNotifier _groupChangeNotifier;
  final String? currentUserId = FirebaseAuth.instance.currentUser?.email;

  @override
  void initState() {
    super.initState();
    isAdmin = widget.group.adminEmail == currentUserId;
    _groupChangeNotifier =
        Provider.of<GroupChangeNotifier>(context, listen: false);
  }

  Future<void> _showImageSourceSelectionDialog() async {
    if (!isAdmin) return;

    await ImagePickerHelper.showImageSourceSelectionDialog(
      context: context,
      onImageSourceSelected: (source) => _pickProfileImage(source),
      dialogTitle: 'Grup Fotoğrafı Seç',
      galleryOptionText: 'Galeriden Seç',
      cameraOptionText: 'Kamera ile Çek',
    );
  }

  Future<void> _pickProfileImage(ImageSource source) async {
    File? selectedImagePath = await _groupChangeNotifier.getGroupImage(source);
    if (selectedImagePath == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      String? imageUrl = await _groupChangeNotifier.uploadGroupProfileImage(
          selectedImagePath, widget.group.groupId);
      if (imageUrl != null) {
        await FirebaseFirestore.instance
            .collection('group_rooms')
            .doc(widget.group.groupId)
            .update({'groupProfilePhoto': imageUrl});

        // Refresh group data
        await _groupChangeNotifier.getGroup(widget.group.groupId);

        if (mounted) {
          Navigator.pop(context);
          MySanckbar.mySnackbar(
              context, 'Grup fotoğrafı başarıyla güncellendi', 2);
        }
      }
    } catch (e) {
      if (mounted) {
        MySanckbar.mySnackbar(context, 'Fotoğraf yüklenirken hata: $e', 2);
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: UIHelper.getDeviceHeight(context) * 0.6,
      child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: UIHelper.getDeviceWith(context) * 0.05,
              vertical: UIHelper.getDeviceWith(context) * 0.05),
          child: Consumer<GroupChangeNotifier>(
            builder: (context, groupChangeNotifier, child) {
              final currentGroup = groupChangeNotifier.group ?? widget.group;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ProfileInfo(
                    image_path: currentGroup.groupProfilePhoto ??
                        ImagePath.group_avatar,
                    image_radius: 40,
                    showName: true,
                    showDate: true,
                    name: currentGroup.groupName,
                    profileNameTextStyle: profileInfoNameTextStyle,
                    profileInfoDateTextStyle: profileInfoDateTextStyle,
                    date: formatDate(currentGroup.createdTime),
                    isNetworkImage: currentGroup.groupProfilePhoto != null &&
                        currentGroup.groupProfilePhoto!.isNotEmpty,
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

                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await _groupChangeNotifier.updateGroupName(
                            widget.group.groupId,
                            widget.editController.text,
                            widget.group);
                        debugPrint('currentGroup: ${widget.group}');
                        // Refresh group data
                        await _groupChangeNotifier
                            .getGroup(widget.group.groupId);
                        if (mounted) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          MySanckbar.mySnackbar(
                              // ignore: use_build_context_synchronously
                              context,
                              'Updated successfully',
                              2);
                        }
                        widget.editController.clear();
                      } catch (e) {
                        if (mounted) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          MySanckbar.mySnackbar(
                              // ignore: use_build_context_synchronously
                              context,
                              'Error updating username',
                              2);
                        }
                      } finally {
                        if (mounted) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                  )
                ],
              );
            },
          )),
    );
  }
}

// Firebase timestamp'inden sadece gün.ay.yıl formatını çıkaran fonksiyon
String formatDate(DateTime? timestamp) {
  if (timestamp == null) return '12.12.2032';

  try {
    final date = timestamp;
    return '${date.day < 10 ? '0' : ''}${date.day}.${date.month < 10 ? '0' : ''}${date.month}.${date.year}';
  } catch (_) {
    return '12.12.2032';
  }
}
