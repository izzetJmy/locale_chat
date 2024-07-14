import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locale_chat/mixin/error_holder.dart';
import 'package:locale_chat/model/async_change_notifier.dart';
import 'package:locale_chat/model/error_model.dart';
import 'package:locale_chat/model/messages_models/group_chat_model.dart';
import 'package:locale_chat/model/messages_models/group_message_model.dart';
import 'package:locale_chat/model/user_model.dart';
import 'package:locale_chat/service/group_service.dart';

class GroupChangeNotifier extends AsyncChangeNotifier with ErrorHolder {
  List<GroupChatModel>? _groupList;
  List<GroupChatModel>? get groupList => _groupList;
  set groupList(List<GroupChatModel>? value) {
    _groupList = value;
    notifyListeners();
  }

  List<GroupMessageModel>? _messageList;
  List<GroupMessageModel>? get messageList => _messageList;
  set messageList(List<GroupMessageModel>? value) {
    messageList = value;
    notifyListeners();
  }

  File? _image;
  File? get image => _image;
  set image(File? value) {
    _image = value;
    notifyListeners();
  }

  @override
  AsyncChangeNotifierState state = AsyncChangeNotifierState.idle;

  final GroupService _groupService = GroupService();
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? 'Anonymous';

  //Listens to create group in firebase
  Future<void> createGroup(
      GroupChatModel groups, List<UserModel> selectedUser) async {
    await wrapAsync(
      () async {
        await _groupService.createGroup(groups, selectedUser);
        errors.clear();
        notifyListeners();
      },
      ErrorModel(id: userId, message: "Filed to create group"),
    );
  }

  //Listen to get group in firebase
  Stream<QuerySnapshot> getGroup() {
    late Stream<QuerySnapshot> groupSnapshot;
    wrap(
      () {
        groupSnapshot = _groupService.getGroup();
        groupSnapshot.listen(
          (snapshot) {
            groupList = snapshot.docs
                .map((e) =>
                    GroupChatModel.fromJson(e.data() as Map<String, dynamic>))
                .toList();
            errors.clear();
            notifyListeners();
          },
        );
      },
      ErrorModel(id: userId, message: "Failed to get group"),
    );
    return groupSnapshot;
  }

  //Listen to remove user from group in firebase
  Future<void> removeUserFromGroup(String groupId, UserModel user) async {
    await wrapAsync(
      () async {
        await _groupService.removeUserFromGroup(groupId, user);
        errors.clear();
      },
      ErrorModel(id: groupId, message: "Failed to remove user from group"),
    );
  }

  //Listen to exit group in firebase
  Future<void> exitGroup(String groupId) async {
    await wrapAsync(
      () async {
        await _groupService.exitGroup(groupId);
        errors.clear();
      },
      ErrorModel(id: groupId, message: "Failed to exit group"),
    );
  }

  //Listen to send group message in firebase
  Future<void> sendGroupMessage(
      GroupMessageModel message, String groupId) async {
    await wrapAsync(
      () async {
        await _groupService.sendGroupMessage(message, groupId);
        errors.clear();
        notifyListeners();
      },
      ErrorModel(id: groupId, message: "Failed to send message from group"),
    );
  }

  //Listen to get group message in firebase
  Stream<QuerySnapshot> getGroupMessage(String groupId) {
    late Stream<QuerySnapshot> groupSnapshot;
    wrap(
      () {
        groupSnapshot = _groupService.getGroupMessage(groupId);
        groupSnapshot.listen(
          (snapshot) {
            messageList = snapshot.docs
                .map((e) => GroupMessageModel.fromJson(
                    e.data() as Map<String, dynamic>))
                .toList();
          },
        );
        errors.clear();
        notifyListeners();
      },
      ErrorModel(id: groupId, message: "Failed to get group message"),
    );
    return groupSnapshot;
  }

  //Listen to upload image in firebase
  Future<void> uploadGroupImage(
      GroupMessageModel message, File imageFile) async {
    await wrapAsync(
      () async {
        await _groupService.uploadGroupImage(message, imageFile);
        errors.clear();
        notifyListeners();
      },
      ErrorModel(id: userId, message: "Failed to upload image from group"),
    );
  }

  //Listen to get image in firebase
  Future<File?> getGroupImage(ImageSource source) async {
    await wrapAsync(
      () async {
        image = await _groupService.getGroupImage(source);
        errors.clear();
        notifyListeners();
      },
      ErrorModel(id: userId, message: "Failed to get image from group"),
    );
    return image;
  }
}
