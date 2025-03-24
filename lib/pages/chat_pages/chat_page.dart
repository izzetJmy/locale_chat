// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locale_chat/comopnents/image_picker_helper.dart';
import 'package:locale_chat/comopnents/my_appbar.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/comopnents/my_text_field.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/model/messages_models/message_model.dart';
import 'package:locale_chat/provider/chat_change_notifier/chat_change_notifier.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class ChatPage extends StatefulWidget {
  final String? title;
  final String? image_path;
  final String? chatId;
  final String? receiverId;

  //Widget for drop down menu at the top right
  final List<PopupMenuEntry<String>> drop_down_menu_list;
  final void Function(String)? onSelected;
  const ChatPage({
    super.key,
    this.title,
    this.image_path,
    required this.drop_down_menu_list,
    this.onSelected,
    this.chatId,
    this.receiverId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();
  late ChatChangeNotifier _chatChangeNotifier;
  @override
  void initState() {
    super.initState();
    _chatChangeNotifier = ChatChangeNotifier();
  }

  List<MessageModel> messages = [];
  bool isLoading = true;

  void _sendMessage() {
    if (controller.text.trim().isEmpty ||
        widget.chatId == null ||
        widget.receiverId == null) {
      return;
    }

    final String messageId = _uuid.v4();
    final String currentUserId = _auth.currentUser!.uid;

    final MessageModel message = MessageModel(
      content: controller.text.trim(),
      createdTime: DateTime.now(),
      senderId: currentUserId,
      messageId: messageId,
      receiverId: widget.receiverId!,
      type: MessageType.TEXT,
    );

    _chatChangeNotifier.sendMessage(message, widget.chatId!);
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
    if (widget.chatId == null || widget.receiverId == null) return;

    final File? selectedImagePath = await _chatChangeNotifier.getImage(source);
    if (selectedImagePath == null) return;

    final String messageId = _uuid.v4();
    final String currentUserId = _auth.currentUser!.uid;

    final MessageModel message = MessageModel(
      content: '', // Resim mesajları için content boş olabilir
      createdTime: DateTime.now(),
      senderId: currentUserId,
      messageId: messageId,
      receiverId: widget.receiverId!,
      type: MessageType.PHOTO,
    );

    final String? imageUrl = await _chatChangeNotifier.uploadImage(
        message, selectedImagePath, widget.chatId!);
    if (imageUrl != null) {
      message.content = imageUrl;
      await _chatChangeNotifier.sendMessage(message, widget.chatId!);
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
              image_path: widget.image_path ?? 'assets/images/user_avatar.png',
              image_radius: 17,
            ),
            const SizedBox(width: 10),
            Text(
              widget.title ?? 'Chat',
              style: appBarTitleTextStyle,
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => widget.drop_down_menu_list,
            onSelected: widget.onSelected,
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: widget.chatId != null
                  ? _firestore
                      .collection("chat_rooms")
                      .doc(widget.chatId)
                      .collection("messages")
                      .orderBy("createdTime", descending: true)
                      .limit(50)
                      .snapshots()
                  : null,
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
                    .map((doc) => MessageModel.fromJson(
                        doc.data() as Map<String, dynamic>))
                    .toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];

                    final bool isMe =
                        message.senderId == _auth.currentUser!.uid;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? backgroundColor : Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (message.type == MessageType.PHOTO)
                              ClipRRect(
                                child: Image.network(
                                  message.content,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return SizedBox(
                                      width: 200,
                                      height: 200,
                                      child: Center(
                                        child: MyCircularProgressIndicator(),
                                      ),
                                    );
                                  },
                                ),
                              )
                            else
                              Text(
                                message.content,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            const SizedBox(height: 5),
                            Text(
                              _formatTime(message.createdTime),
                              style: TextStyle(
                                color: isMe ? Colors.white70 : Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Message input
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
                      icon: const Icon(
                        CupertinoIcons.camera,
                        color: Colors.grey,
                      ),
                      onPressed: _showImageSourceSelectionDialog,
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
