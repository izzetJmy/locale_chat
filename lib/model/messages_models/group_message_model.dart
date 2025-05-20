// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locale_chat/model/user_model.dart';

enum MessageType { PHOTO, TEXT }

class GroupMessageModel {
  String messageId;
  String groupId;
  String content;
  UserModel? sender;
  DateTime createdTime;
  MessageType type;

  GroupMessageModel({
    required this.messageId,
    required this.groupId,
    required this.content,
    required this.sender,
    required this.createdTime,
    required this.type,
  });

  static GroupMessageModel fromJson(Map<String, dynamic> map) {
    return GroupMessageModel(
        messageId: map['messageId'],
        groupId: map['groupId'],
        content: map['content'],
        sender: map['sender'] != null
            ? UserModel.fromJson(map['sender'] as Map<String, dynamic>)
            : UserModel(
                id: '',
                userName: '',
                isAnonymousName: false,
                email: '',
                profilePhoto: '',
                isOnline: false,
                createdAt: ''),
        createdTime: (map['createdTime'] as Timestamp).toDate(),
        type: MessageType.values[map['type']]);
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'groupId': groupId,
      'content': content,
      'sender': sender?.toJson(),
      'createdTime': createdTime,
      'type': type.index,
    };
  }
}
