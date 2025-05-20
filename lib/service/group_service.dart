import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locale_chat/model/messages_models/group_chat_model.dart';
import 'package:locale_chat/model/messages_models/group_message_model.dart';
import 'package:locale_chat/model/user_model.dart';

class GroupService {
  final String? currentUser = FirebaseAuth.instance.currentUser?.uid;
  final String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //CREATE GROUP
  Future<GroupChatModel?> createGroup(
      GroupChatModel groups, List<UserModel> selectedUser) async {
    GroupChatModel newGroup = GroupChatModel(
      groupId: groups.groupId,
      groupName: groups.groupName,
      members: _groupChatMembers(selectedUser),
      groupProfilePhoto: groups.groupProfilePhoto,
      createdTime: groups.createdTime,
      createdId: currentUser!,
      adminEmail: currentUserEmail!,
    );

    try {
      await _firestore
          .collection('group_rooms')
          .doc(groups.groupId)
          .set(newGroup.toJson());
    } catch (e) {
      debugPrint("Error creating group $e");
    }
    return newGroup;
  }

  Future<GroupChatModel> addMemberToGroup(
      GroupChatModel group, String groupId, List<String> selectedUser) async {
    GroupChatModel newGroup = GroupChatModel(
      groupId: group.groupId,
      groupName: group.groupName,
      members: selectedUser,
      groupProfilePhoto: group.groupProfilePhoto,
      createdTime: group.createdTime,
      createdId: currentUser!,
      adminEmail: currentUserEmail!,
    );
    DocumentReference groupRef =
        _firestore.collection("group_rooms").doc(groupId);
    await groupRef.update({'members': FieldValue.arrayUnion(selectedUser)});
    return newGroup;
  }

  //SELECTED USER LIST
  List<String> _groupChatMembers(List<UserModel> selectedUser) {
    List<String> membersList = [];
    membersList.add(currentUser!);
    for (UserModel member in selectedUser) {
      membersList.add(member.id);
    }
    return membersList;
  }

  //GET GROUP
  Stream<DocumentSnapshot> getGroup(String groupId) {
    return _firestore.collection("group_rooms").doc(groupId).snapshots();
  }

  Future<GroupChatModel> updateGroupName(
      String groupId, String newName, GroupChatModel oldGroup) async {
    await _firestore
        .collection("group_rooms")
        .doc(groupId)
        .update({'groupName': newName});
    GroupChatModel group = GroupChatModel(
      groupId: groupId,
      groupName: newName,
      members: oldGroup.members,
      groupProfilePhoto: oldGroup.groupProfilePhoto,
      createdTime: oldGroup.createdTime,
      createdId: currentUser!,
      adminEmail: currentUserEmail!,
    );
    return group;
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
    GroupMessageModel newMessage = GroupMessageModel(
        messageId: message.messageId,
        groupId: groupId,
        content: message.content,
        sender: message.sender,
        createdTime: message.createdTime,
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

//Upload user profile photo to firebase storage
  Future<String?> uploadGroupImage(
      File imageFile, String groupId, GroupMessageModel message) async {
    var imageName = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef =
        storageRef.child('groupImage/$groupId/groupImages/$imageName');
    final uploadTask = imageRef.putFile(imageFile);
    final TaskSnapshot taskSnapshot = await uploadTask;
    final String downloadURL = await taskSnapshot.ref.getDownloadURL();
    GroupMessageModel newMessage = GroupMessageModel(
        messageId: message.messageId,
        groupId: groupId,
        content: downloadURL,
        sender: message.sender,
        createdTime: message.createdTime,
        type: message.type);

    await _firestore
        .collection('group_rooms')
        .doc(groupId)
        .collection('messages')
        .doc(message.messageId)
        .set(newMessage.toJson());
    debugPrint("Group image uploaded successfully: $downloadURL");

    return downloadURL;
  }

//Upload user profile photo to firebase storage
  Future<String?> uploadGroupProfileImage(
      File imageFile, String groupId) async {
    var imageName = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef =
        storageRef.child('groupImage/$groupId/groupProfilePhoto/$imageName');
    final uploadTask = imageRef.putFile(imageFile);
    final TaskSnapshot taskSnapshot = await uploadTask;
    final String downloadURL = await taskSnapshot.ref.getDownloadURL();

    debugPrint("Group image uploaded successfully: $downloadURL");

    return downloadURL;
  }

  //GET GROUP IMAGE
  Future<File?> getImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
          source: source, maxWidth: 800, maxHeight: 800, imageQuality: 80);
      if (pickedFile == null) {
        debugPrint('Resim seçilmedi veya seçim iptal edildi');
        return null;
      }
      debugPrint('pickedFile: ${pickedFile.path}');
      return File(pickedFile.path);
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
    return null;
  }

  //GET ALL IMAGES FROM FOLDER
  Future<List<String>> getAllImagesFromFolder(String folderPath) async {
    try {
      // Check if user is authenticated
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final storageRef = FirebaseStorage.instance.ref();
      final folderRef = storageRef.child(folderPath);

      // Get all items in the folder
      final result = await folderRef.listAll();

      // Get download URLs for all items
      List<String> imageUrls = [];
      for (var item in result.items) {
        try {
          final downloadUrl = await item.getDownloadURL();
          imageUrls.add(downloadUrl);
        } catch (e) {
          debugPrint("Error getting download URL for ${item.name}: $e");
          // Continue with next item if one fails
          continue;
        }
      }

      return imageUrls;
    } catch (e) {
      debugPrint("Error getting images from folder: $e");
      rethrow;
    }
  }
}
