enum MessageType { PHOTO, TEXT }

class MessageModel {
  String messageId;
  String chatId;
  String content;
  String senderId;
  String receiverId;
  DateTime createdTime;
  MessageType type;

  MessageModel({
    required this.chatId,
    required this.content,
    required this.createdTime,
    required this.senderId,
    required this.messageId,
    required this.receiverId,
    required this.type,
  });

  MessageModel fromJson(Map<String, dynamic> map) {
    return MessageModel(
        chatId: map["chatId"],
        content: map["content"],
        createdTime: map["createdTime"],
        senderId: map["senderId"],
        messageId: map["messageId"],
        receiverId: map["receiverId"],
        type: map["type"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "chatID": chatId,
      "content": content,
      "createdTime": createdTime,
      "senderId": senderId,
      "messageId": messageId,
      "receiverId": receiverId,
      "type": type
    };
  }
}
