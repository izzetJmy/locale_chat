// ignore_for_file: constant_identifier_names

enum MessageType { PHOTO, TEXT }

class MessageModel {
  String messageId;
  String content;
  String senderId;
  String receiverId;
  DateTime createdTime;
  MessageType type;

  MessageModel({
    required this.content,
    required this.createdTime,
    required this.senderId,
    required this.messageId,
    required this.receiverId,
    required this.type,
  });

  MessageModel fromJson(Map<String, dynamic> map) {
    return MessageModel(
        content: map["content"],
        createdTime: map["createdTime"],
        senderId: map["senderId"],
        messageId: map["messageId"],
        receiverId: map["receiverId"],
        type: MessageType.values[map["type"]]);
  }

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "createdTime": createdTime,
      "senderId": senderId,
      "messageId": messageId,
      "receiverId": receiverId,
      "type": type.index
    };
  }
}
