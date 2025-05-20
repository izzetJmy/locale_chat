// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locale_chat/model/messages_models/chat_model.dart';

class GroupChatModel extends ChatModel {
  String groupId;
  String groupName;
  List<String> members;
  String? groupProfilePhoto;
  DateTime createdTime;
  String createdId;
  String adminEmail;

  GroupChatModel({
    required this.groupId,
    required this.groupName,
    required this.members,
    this.groupProfilePhoto,
    required this.createdTime,
    required this.createdId,
    required this.adminEmail,
  });

  @override
  String getId() {
    return groupId;
  }

  @override
  List getMembers() {
    return members;
  }

  static GroupChatModel fromJson(Map<String, dynamic> map) {
    return GroupChatModel(
      groupId: map['groupId'],
      groupName: map['groupName'],
      members: List<String>.from(map['members'] ?? []),
      groupProfilePhoto: map['groupProfilePhoto'],
      createdTime: (map["createdTime"] as Timestamp).toDate(),
      createdId: map['createdId'],
      adminEmail: map['adminEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'groupId': groupId,
      'groupName': groupName,
      'members': members,
      'groupProfilePhoto': groupProfilePhoto,
      'createdTime': createdTime,
      'createdId': createdId,
      'adminEmail': adminEmail,
    };
  }
}
