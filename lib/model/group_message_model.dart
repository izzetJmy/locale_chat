enum MessageType { PHOTO, TEXT }

class GroupMessageModel {
  String messageId;
  String groupId;
  String content;
  String senderId;
  DateTime createdTime;
  MessageType type;

  GroupMessageModel({
    required this.messageId,
    required this.groupId,
    required this.content,
    required this.senderId,
    required this.createdTime,
    required this.type,
  });

  GroupMessageModel fromJson(Map<String, dynamic> map) {
    return GroupMessageModel(
        messageId: map['messageId'],
        groupId: map['groupId'],
        content: map['content'],
        senderId: map['senderId'],
        createdTime: map['createdTime'],
        type: map['type']);
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'groupId': groupId,
      'content': content,
      'senderId': senderId,
      'createdTime': createdTime,
      'type': type,
    };
  }
}
