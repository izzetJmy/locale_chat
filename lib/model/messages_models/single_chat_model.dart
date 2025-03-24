// ignore_for_file: unnecessary_this

import 'package:locale_chat/model/messages_models/chat_model.dart';

class SingleChatModel extends ChatModel {
  String chatId;
  List members;
  String? lastMessage;
  DateTime? lastMessageTime;

  SingleChatModel({
    required this.chatId,
    required this.members,
    this.lastMessage,
    this.lastMessageTime,
  });

  @override
  String getId() {
    return this.chatId;
  }

  @override
  List getMembers() {
    return this.members;
  }

  static SingleChatModel fromJson(Map<String, dynamic> map) {
    return SingleChatModel(
        chatId: map['chatId'],
        members: [],
        lastMessage: map['lastMessage'],
        lastMessageTime: map['lastMessageTime']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'chatId': chatId,
      'members': members,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }
}
