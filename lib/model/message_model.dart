enum MessageType { PHOTO, TEXT }

class MessageModel {
  String messageId;
  String chatId;
  String content;
  String to;
  String from;
  DateTime createdTime;
  MessageType type;

  MessageModel({
    required this.chatId,
    required this.content,
    required this.createdTime,
    required this.from,
    required this.messageId,
    required this.to,
    required this.type,
  });

  MessageModel fromJson(Map<String, dynamic> map) {
    return MessageModel(
        chatId: map["chatId"],
        content: map["content"],
        createdTime: map["createdTime"],
        from: map["from"],
        messageId: map["messageId"],
        to: map["to"],
        type: map["type"]);
  }

  Map<String, dynamic> toJson(MessageModel model) {
    return {
      "chatID": model.chatId,
      "content": model.content,
      "createdTime": model.createdTime,
      "from": model.from,
      "messageId": model.messageId,
      "to": model.to,
      "type": model.type
    };
  }
}
