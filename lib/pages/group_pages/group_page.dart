// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locale_chat/comopnents/chat_components/my_group_chat.dart';
import 'package:locale_chat/comopnents/chat_components/my_group_chat_image.dart';
import 'package:locale_chat/comopnents/image_picker_helper.dart';
import 'package:locale_chat/comopnents/my_appbar.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/comopnents/my_text_field.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/model/messages_models/group_chat_model.dart';
import 'package:locale_chat/model/messages_models/group_message_model.dart';
import 'package:locale_chat/model/user_model.dart';
import 'package:locale_chat/pages/group_pages/group_detail_page.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:locale_chat/provider/group_change_notifier/group_change_notifier.dart';
import 'package:uuid/uuid.dart';

class GroupPage extends StatefulWidget {
  final GroupChatModel group;
  const GroupPage({super.key, required this.group});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  TextEditingController controller = TextEditingController();
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();
  late GroupChangeNotifier _groupChangeNotifier;
  late AuthChangeNotifier _authChangeNotifier;

  @override
  void initState() {
    super.initState();
    _groupChangeNotifier = GroupChangeNotifier();
    _authChangeNotifier = AuthChangeNotifier();
    _loadCurrentUser();
  }

  List<GroupMessageModel> messages = [];
  bool isLoading = true;

  Future<void> _sendMessage() async {
    if (controller.text.trim().isEmpty) return;
    final String messageId = _uuid.v4();
    UserModel? user = _authChangeNotifier.user;
    final GroupMessageModel message = GroupMessageModel(
      messageId: messageId,
      groupId: widget.group.groupId,
      content: controller.text.trim(),
      sender: user!,
      createdTime: DateTime.now(),
      type: MessageType.TEXT,
    );
    debugPrint(user.toJson().toString());
    _groupChangeNotifier.sendGroupMessage(message, widget.group.groupId);

    controller.clear();
  }

  // Method to show image source selection dialog
  Future<void> _showImageSourceSelectionDialog() async {
    await ImagePickerHelper.showImageSourceSelectionDialog(
      context: context,
      onImageSourceSelected: (source) => _pickProfileImage(source),
      dialogTitle: 'Resim Gön5er',
      galleryOptionText: 'Galeriden Seç',
      cameraOptionText: 'Kamera ile Çek',
    );
  }

  // Method to pick and upload profile image
  Future<void> _pickProfileImage(ImageSource source) async {
    final File? selectedImagePath =
        await _groupChangeNotifier.getGroupImage(source);
    if (selectedImagePath == null) return;

    final String messageId = _uuid.v4();
    UserModel? user = _authChangeNotifier.user;
    GroupMessageModel message = GroupMessageModel(
      messageId: messageId,
      groupId: widget.group.groupId,
      content: '',
      sender: user!,
      createdTime: DateTime.now(),
      type: MessageType.PHOTO,
    );
    final String? imageUrl = await _groupChangeNotifier.uploadGroupImage(
        message, selectedImagePath, widget.group.groupId);
    if (imageUrl != null) {
      message.content = imageUrl;
      await _groupChangeNotifier.sendGroupMessage(
          message, widget.group.groupId);
    }
  }

  Future<void> _loadCurrentUser() async {
    if (currentUserId != null) {
      await _authChangeNotifier.getUserInfo(currentUserId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: backgroundColor,
              ),
            ),
            const SizedBox(width: 5),
            ProfileInfo(
              image_path: widget.group.groupProfilePhoto ??
                  'assets/images/group_avatar.png',
              image_radius: 17,
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupDetailPage(group: widget.group),
                ),
              ),
              child: Text(
                widget.group.groupName,
                style: appBarTitleTextStyle,
              ),
            ),
          ],
        ),
        actions: [],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('group_rooms')
                  .doc(widget.group.groupId)
                  .collection('messages')
                  .orderBy('createdTime', descending: true)
                  .limit(50)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: MyCircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  );
                }
                messages = snapshot.data!.docs
                    .map((doc) => GroupMessageModel.fromJson(doc.data()))
                    .toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final bool isMe = message.sender?.id == currentUserId;
                    if (message.type == MessageType.TEXT) {
                      return MyGroupChat(
                        leftOrRight: isMe,
                        title: message.content,
                        time: _formatTime(message.createdTime),
                        userImage: message.sender?.profilePhoto ?? '',
                        userName: message.sender?.userName ?? '',
                      );
                    }
                    if (message.type == MessageType.PHOTO) {
                      return MyGroupChatImage(
                        leftOrRight: isMe,
                        imagePath: message.content,
                        time: _formatTime(message.createdTime),
                        userImage: message.sender?.profilePhoto ?? '',
                        userName: message.sender?.userName ?? '',
                      );
                    }
                    return null;
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: controller,
                    hintText: 'Type a message...',
                    obscureText: false,
                    suffixIcon: IconButton(
                      onPressed: _showImageSourceSelectionDialog,
                      icon: const Icon(
                        CupertinoIcons.camera,
                        color: Colors.grey,
                      ),
                    ),
                    prefixIcon: const Icon(Icons.emoji_emotions_outlined,
                        color: Colors.grey),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: backgroundColor,
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
