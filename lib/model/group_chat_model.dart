import 'package:locale_chat/model/chat_model.dart';

class GroupChatModel extends ChatModel {
  String id;
  List members;
  String? groupPhoto;
  String createdId;

  GroupChatModel(this.id, this.members, this.groupPhoto, this.createdId);

  @override
  String getId() {
    return this.id;
  }

  @override
  List getMembers() {
    return this.members;
  }
}
