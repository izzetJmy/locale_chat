// ignore_for_file: prefer_final_fields, avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locale_chat/mixin/error_holder.dart';
import 'package:locale_chat/model/async_change_notifier.dart';
import 'package:locale_chat/model/error_model.dart';
import 'package:locale_chat/model/messages_models/message_model.dart';
import 'package:locale_chat/model/messages_models/single_chat_model.dart';
import 'package:locale_chat/service/chat_service.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatChangeNotifier extends AsyncChangeNotifier with ErrorHolder {
  SingleChatService _singleChatService = SingleChatService();
  final Uuid _uuid = Uuid();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<MessageModel>? _messages;
  List<MessageModel>? get messages => _messages;
  set messages(List<MessageModel>? value) {
    _messages = value;
    notifyListeners();
  }

  List<SingleChatModel>? _chats;
  List<SingleChatModel>? get chats => _chats;
  set chats(List<SingleChatModel>? value) {
    _chats = value;
    notifyListeners();
  }

  String? _imageDownloadUrl;
  String? get imageDownloadUrl => _imageDownloadUrl;
  set imageDownloadUrl(String? value) {
    _imageDownloadUrl = value;
    notifyListeners();
  }

  File? _imageFile;
  File? get imageFile => _imageFile;
  set imageFile(File? value) {
    _imageFile = value;
    notifyListeners();
  }

  @override
  AsyncChangeNotifierState state = AsyncChangeNotifierState.idle;

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return _singleChatService.getAllUsers();
  }

  void createChat(SingleChatModel chatModel, String chatId) {
    wrapAsync(
      () async {
        await _singleChatService.createChat(chatModel, chatId);
      },
      ErrorModel(id: "", message: "message"),
    );
  }

  Stream<QuerySnapshot> getUserChats() {
    return _singleChatService.getUserChats(_auth.currentUser!.uid);
  }

  Future<void> sendMessage(MessageModel message, String chatId) async {
    await wrapAsync(
      () async {
        await _singleChatService.sendMessage(message, chatId);
      },
      ErrorModel(id: "id", message: "message"),
    );
  }

  void getMessage(String chatId) {
    //bu metodu anlamadım hata çıkma olasılığı baya yüksek
    wrapAsync(
      () async {
        Stream<QuerySnapshot<Object?>> snapshot =
            _singleChatService.getMessage(chatId);
        snapshot.map(
          (QuerySnapshot queryDocuments) {
            queryDocuments.docs.forEach(
              (QueryDocumentSnapshot element) {
                messages!.add(element.data() as MessageModel);
                notifyListeners();
              },
            );
          },
        );
      },
      ErrorModel(id: "id", message: "message"),
    );
  }

  void getChat(String chatId) {
    //bu metodu anlamadım hata çıkma olasılığı baya yüksek
    wrapAsync(
      () async {
        Stream<QuerySnapshot<Map<String, dynamic>>?> snapshot =
            _singleChatService.getChat();
        snapshot.map(
          (QuerySnapshot<Map<String, dynamic>>? queryDocuments) {
            queryDocuments!.docs.forEach(
              (QueryDocumentSnapshot element) {
                chats!.add(element.data() as SingleChatModel);
                notifyListeners();
              },
            );
          },
        );
      },
      ErrorModel(id: "id", message: "message"),
    );
  }

  void deleteChat(String chatId) {
    wrapAsync(
      () async {
        await _singleChatService.deleteChat(chatId);
      },
      ErrorModel(id: "id", message: "message"),
    );
  }

  Future<String?> uploadImage(
      MessageModel message, File imageFile, String chatId) async {
    return await wrapAsync(
      () async {
        final url =
            await _singleChatService.uploadImage(message, imageFile, chatId);
        imageDownloadUrl = url;
        notifyListeners();
        return url;
      },
      ErrorModel(id: "id", message: "message"),
    );
  }

  Future<File?> getImage(ImageSource source) async {
    return await wrapAsync(
      () async {
        final file = await _singleChatService.getImage(source);
        imageFile = file;
        notifyListeners();
        return file;
      },
      ErrorModel(id: "id", message: "message"),
    );
  }

  Future<void> sendImageMessage({
    required File imageFile,
    required String receiverId,
    required String chatId,
  }) async {
    final String messageId = _uuid.v4();
    final String currentUserId = _auth.currentUser!.uid;

    final MessageModel message = MessageModel(
      content: '', // Resim mesajları için content boş olabilir
      createdTime: DateTime.now(),
      senderId: currentUserId,
      messageId: messageId,
      receiverId: receiverId,
      type: MessageType.PHOTO,
    );

    await wrapAsync(
      () async {
        final String? imageUrl = await _singleChatService.uploadImage(
          message,
          imageFile,
          chatId,
        );

        if (imageUrl != null) {
          message.content = imageUrl; // Resim URL'ini content olarak kaydet
          await _singleChatService.sendMessage(message, chatId);
        }
      },
      ErrorModel(
          id: "sendImageMessage", message: "Failed to send image message"),
    );
  }
}
