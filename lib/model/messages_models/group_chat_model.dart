// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:locale_chat/model/messages_models/chat_model.dart';

class GroupChatModel extends ChatModel {
  String groupId;
  String groupName;
  List members;
  String? groupPhoto;
  DateTime createdTime;
  String createdId;
  String adminEmail;

  GroupChatModel({
    required this.groupId,
    required this.groupName,
    required this.members,
    this.groupPhoto,
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
      members: [],
      groupPhoto: map['groupPhoto'],
      createdTime: map['createdTime'],
      createdId: map['createdId'],
      adminEmail: map['adminEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'groupId': groupId,
      'groupName': groupName,
      'members': members,
      'groupPhoto': groupPhoto,
      'createdTime': createdTime,
      'createdId': createdId,
      'adminEmail': adminEmail,
    };
  }
}
