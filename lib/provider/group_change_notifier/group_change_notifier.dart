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
    _messageList = value;
    notifyListeners();
  }

  GroupChatModel? _group;
  GroupChatModel? get group => _group;
  set group(GroupChatModel? value) {
    _group = value;
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
        group = await _groupService.createGroup(groups, selectedUser);
        errors.clear();
        notifyListeners();
      },
      ErrorModel(id: userId, message: "Filed to create group"),
    );
  }

  Future<void> addMemberToGroup(
      String groupId, List<String> selectedUser) async {
    await wrapAsync(
      () async {
        _group = await _groupService.addMemberToGroup(
            _group!, groupId, selectedUser);
        errors.clear();
        notifyListeners();
      },
      ErrorModel(id: userId, message: "Failed to add member to group"),
    );
  }

  //Listen to get group in firebase
  Future<void> getGroup(String groupId) async {
    try {
      final snapshot = await _groupService.getGroup(groupId).first;
      if (snapshot.exists) {
        _group =
            GroupChatModel.fromJson(snapshot.data() as Map<String, dynamic>);
        errors.clear();
        notifyListeners();
      }
    } catch (e) {
      errors.add(ErrorModel(id: userId, message: "Failed to get group"));
      notifyListeners();
    }
  }

  //Listen to update group name in firebase
  Future<void> updateGroupName(
      String groupId, String newName, GroupChatModel oldGroup) async {
    return wrapAsync(
      () async {
        await _groupService.updateGroupName(groupId, newName, oldGroup);
        errors.clear();
        notifyListeners();
      },
      ErrorModel(id: groupId, message: "Failed to update group name"),
    );
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
  Future<String?> uploadGroupImage(
    GroupMessageModel message,
    File imageFile,
    String groupId,
  ) async {
    String? downloadURL;
    await wrapAsync(
      () async {
        downloadURL =
            await _groupService.uploadGroupImage(imageFile, groupId, message);
        errors.clear();
        notifyListeners();
      },
      ErrorModel(id: userId, message: "Failed to upload image from group"),
    );
    return downloadURL;
  }

  //Listen to upload image in firebase
  Future<String?> uploadGroupProfileImage(
    File imageFile,
    String groupId,
  ) async {
    String? downloadURL;
    await wrapAsync(
      () async {
        downloadURL =
            await _groupService.uploadGroupProfileImage(imageFile, groupId);
        errors.clear();
        notifyListeners();
      },
      ErrorModel(id: userId, message: "Failed to upload image from group"),
    );
    return downloadURL;
  }

  //Listen to get image in firebase
  Future<File?> getGroupImage(ImageSource source) async {
    return wrapAsync(
      () async {
        _image = await _groupService.getImage(source);
        errors.clear();
        notifyListeners();
      },
      ErrorModel(id: userId, message: "Failed to get image from group"),
    ).then((_) => _image);
  }

  //Listen to get all images from folder in firebase
  Future<List<String>> getAllImagesFromFolder(String folderPath) async {
    List<String> imageUrls = [];
    try {
      imageUrls = await _groupService.getAllImagesFromFolder(folderPath);
      errors.clear();
      notifyListeners();
    } catch (e) {
      errors.add(ErrorModel(
          id: userId, message: "Failed to get all images from folder"));
      notifyListeners();
    }
    return imageUrls;
  }
}
