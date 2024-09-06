// ignore_for_file: unnecessary_this

import 'package:locale_chat/model/messages_models/chat_model.dart';

class SingleChatModel extends ChatModel {
  String chatId;
  List members;
  SingleChatModel({
    required this.chatId,
    required this.members,
  });

  @override
  String getId() {
    return this.chatId;
  }

  @override
  List getMembers() {
    return this.members;
  }

  SingleChatModel fromJson(Map<String, dynamic> map) {
    return SingleChatModel(chatId: map['chatId'], members: []);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'chatId': chatId,
      'members': members,
    };
  }
}
