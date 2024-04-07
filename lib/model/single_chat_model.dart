import 'package:locale_chat/model/chat_model.dart';

class SingleChatModel extends ChatModel {
  String id;
  List members;

  SingleChatModel(this.id, this.members);

  @override
  String getId() {
    return this.id;
  }

  @override
  List getMembers() {
    return this.members;
  }
}
