import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locale_chat/model/messages_models/group_chat_model.dart';
import 'package:locale_chat/model/messages_models/group_message_model.dart';
import 'package:locale_chat/model/user_model.dart';
import 'package:uuid/uuid.dart';

class GroupService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();
  final DateTime _nowTime = DateTime.now();

  //CREATE GROUP
  Future<void> createGroup(
      GroupChatModel groups, List<UserModel> selectedUser) async {
    User? currentUser = _auth.currentUser!;

    GroupChatModel newGroup = GroupChatModel(
      groupId: groups.groupId,
      groupName: groups.groupName,
      members: _groupChatMembers(selectedUser),
      groupPhoto: groups.groupPhoto,
      createdTime: _nowTime,
      createdId: currentUser.uid,
      adminEmail: currentUser.email.toString(),
    );

    try {
      await _firestore
          .collection('group_rooms')
          .doc(groups.groupId)
          .set(newGroup.toJson());
    } catch (e) {
      debugPrint("Error creating group $e");
    }
  }

  //SELECTED USER LIST
  List<String> _groupChatMembers(List<UserModel> selectedUser) {
    List<String> membersList = [];
    for (UserModel member in selectedUser) {
      membersList.add(member.id);
    }
    return membersList;
  }

  //GET GROUP
  Stream<QuerySnapshot> getGroup() {
    return _firestore
        .collection("group_rooms")
        .orderBy("createdTime", descending: false)
        .snapshots();
  }

  //REMOVE USER FROM GROUP OR EXIT GROUP
  Future<void> removeUserFromGroup(String groupId, UserModel user) async {
    DocumentReference groupRef =
        _firestore.collection("group_rooms").doc(groupId);
    groupRef.update(
      {
        'members': FieldValue.arrayRemove([user.id])
      },
    );
  }

  //DELETE GROUP
  Future<void> exitGroup(String groupId) async {
    await _firestore.collection("group_rooms").doc(groupId).delete();
  }

  //SEND GROUP MESSAGE
  Future<void> sendGroupMessage(
      GroupMessageModel message, String groupId) async {
    final User currentUser = _auth.currentUser!;
    GroupMessageModel newMessage = GroupMessageModel(
        messageId: message.messageId,
        groupId: groupId,
        content: message.content,
        senderId: currentUser.uid,
        createdTime: _nowTime,
        type: message.type);

    try {
      await _firestore
          .collection("group_rooms")
          .doc(groupId)
          .collection("messages")
          .doc(message.messageId)
          .set(newMessage.toJson());
    } catch (e) {
      debugPrint("Error send message $e");
    }
  }

  //GET GROUP MESSAGE
  Stream<QuerySnapshot> getGroupMessage(String groupId) {
    return _firestore
        .collection("group_rooms")
        .doc(groupId)
        .collection("messages")
        .orderBy("createdTime", descending: false)
        .snapshots();
  }

  //GROUP UPLOAD IMAGE
  Future<String?> uploadGroupImage(
      GroupMessageModel message, File imageFile) async {
    final User currentUser = _auth.currentUser!;
    final String downloadUrl;

    final Reference storageRef =
        FirebaseStorage.instance.ref().child("images").child(_uuid.v4());
    final UploadTask uploadTask = storageRef.putFile(imageFile);

    try {
      await uploadTask;
      downloadUrl = await storageRef.getDownloadURL();

      GroupMessageModel newMessage = GroupMessageModel(
          messageId: message.messageId,
          groupId: message.groupId,
          content: downloadUrl,
          senderId: currentUser.uid,
          createdTime: _nowTime,
          type: message.type);

      await _firestore
          .collection("group_rooms")
          .doc(message.groupId)
          .collection("messages")
          .doc(message.messageId)
          .set(newMessage.toJson());
    } catch (e) {
      debugPrint("Error adding image: $e");
    }
    return null;
  }

  //GROUP GET IMAGE
  Future<File?> getGroupImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: source);
      return File(pickedFile!.path);
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
    return null;
  }
}
