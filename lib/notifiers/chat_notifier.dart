import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locale_chat/mixin/error_holder.dart';
import 'package:locale_chat/model/async_change_notifier.dart';
import 'package:locale_chat/model/error_model.dart';
import 'package:locale_chat/model/messages_models/message_model.dart';
import 'package:locale_chat/model/messages_models/single_chat_model.dart';
import 'package:locale_chat/service/chat_service.dart';

class ChatNotifier extends AsyncChangeNotifier with ErrorHolder {
  SingleChatService _singleChatService = SingleChatService();

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

  void createChat(SingleChatModel chatModel, String chatId) {
    wrapAsync(
      () async {
        await _singleChatService.createChat(chatModel, chatId);
      },
      ErrorModel(id: "", message: "message"),
    );
  }

  void sendMessage(MessageModel message, String chatId) {
    wrapAsync(
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

  void uploadImage(MessageModel message, File imageFile, String chatId) {
    wrapAsync(
      () async {
        imageDownloadUrl =
            await _singleChatService.uploadImage(message, imageFile, chatId);
        notifyListeners();
      },
      ErrorModel(id: "id", message: "message"),
    );
  }

  void getImage(ImageSource source) {
    wrapAsync(
      () async {
        imageFile = await _singleChatService.getImage(source);
        notifyListeners();
      },
      ErrorModel(id: "id", message: "message"),
    );
  }
}
