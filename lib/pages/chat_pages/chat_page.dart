// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locale_chat/comopnents/chat_components/my_single_chat.dart';
import 'package:locale_chat/comopnents/chat_components/my_single_chat_image.dart';
import 'package:locale_chat/comopnents/image_picker_helper.dart';
import 'package:locale_chat/comopnents/my_appbar.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/comopnents/my_text_field.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/languages_keys.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/helper/localization_extention.dart';
import 'package:locale_chat/model/messages_models/message_model.dart';
import 'package:locale_chat/pages/chat_pages/chat_detail_page.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:locale_chat/provider/chat_change_notifier/chat_change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:locale_chat/service/notification_service.dart';

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
  late AuthChangeNotifier authChangeNotifier;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _chatChangeNotifier = ChatChangeNotifier();
    authChangeNotifier =
        Provider.of<AuthChangeNotifier>(context, listen: false);
    _subscribeToNotifications();
  }

  Future<void> _subscribeToNotifications() async {
    if (widget.chatId != null) {
      print('ChatPage: Bildirimlere abone olunuyor...');
      print('ChatPage: Chat ID: ${widget.chatId}');
      print('ChatPage: Receiver ID: ${widget.receiverId}');

      await _notificationService.subscribeToChat(widget.chatId!);
      print(
          'ChatPage: Bildirimlere başarıyla abone olundu: chat_${widget.chatId}');
    }
  }

  @override
  void dispose() {
    if (widget.chatId != null) {
      _notificationService.unsubscribeFromTopic('chat_${widget.chatId}');
      print('Bildirim aboneliği kaldırıldı: chat_${widget.chatId}');
    }
    super.dispose();
  }

  List<MessageModel> messages = [];
  bool isLoading = true;

  void _sendMessage() {
    if (controller.text.trim().isEmpty ||
        widget.chatId == null ||
        widget.receiverId == null) {
      print('ChatPage: Mesaj gönderilemedi - Eksik bilgiler');
      print('ChatPage: Mesaj içeriği: ${controller.text.trim()}');
      print('ChatPage: Chat ID: ${widget.chatId}');
      print('ChatPage: Receiver ID: ${widget.receiverId}');
      return;
    }

    print('ChatPage: Mesaj gönderiliyor...');
    final String messageId = _uuid.v4();
    final String currentUserId = _auth.currentUser!.uid;

    print('ChatPage: Mesaj detayları:');
    print('ChatPage: Message ID: $messageId');
    print('ChatPage: Sender ID: $currentUserId');
    print('ChatPage: Receiver ID: ${widget.receiverId}');
    print('ChatPage: Content: ${controller.text.trim()}');

    final MessageModel message = MessageModel(
      content: controller.text.trim(),
      createdTime: DateTime.now(),
      senderId: currentUserId,
      messageId: messageId,
      receiverId: widget.receiverId!,
      type: MessageType.TEXT,
    );

    _chatChangeNotifier.sendMessage(message, widget.chatId!);
    print('ChatPage: Mesaj başarıyla gönderildi');
    controller.clear();
  }

  // Method to show image source selection dialog
  Future<void> _showImageSourceSelectionDialog() async {
    await ImagePickerHelper.showImageSourceSelectionDialog(
      context: context,
      onImageSourceSelected: (source) => _pickProfileImage(source),
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
      resizeToAvoidBottomInset: true,
      appBar: MyAppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 5),
            ProfileInfo(
              image_path: widget.image_path ?? 'assets/images/user_avatar.png',
              image_radius: 17,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailPage(
                    chatId: widget.chatId,
                    receiverId: widget.receiverId,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailPage(
                    chatId: widget.chatId,
                    receiverId: widget.receiverId,
                  ),
                ),
              ),
              child: Text(
                widget.title ?? LocaleKeys.navigationChat.locale(context),
                style: appBarTitleTextStyle,
              ),
            ),
          ],
        ),
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
                  return Center(
                    child: Text(
                      LocaleKeys.chatNoMessages.locale(context),
                      style: const TextStyle(
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

                    authChangeNotifier.getUserInfo(message.senderId);

                    final bool isMe =
                        message.senderId == _auth.currentUser!.uid;
                    if (message.type == MessageType.TEXT) {
                      return MySingleChat(
                        leftOrRight: isMe,
                        title: message.content,
                        time: _formatTime(message.createdTime),
                      );
                    }
                    if (message.type == MessageType.PHOTO) {
                      return MySingleChatImage(
                        leftOrRight: isMe,
                        imagePath: message.content,
                        time: _formatTime(message.createdTime),
                        userImage: authChangeNotifier.user?.profilePhoto ?? '',
                        userName: authChangeNotifier.user?.userName ?? '',
                      );
                    }
                    return null;
                  },
                );
              },
            ),
          ),
          // Message input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: profileCardColor,
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
                    hintText: LocaleKeys.chatTypeMessage.locale(context),
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
                    color: iconColor,
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
