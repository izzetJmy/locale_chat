import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locale_chat/model/message_model.dart';
import 'package:locale_chat/model/single_chat_model.dart';
import 'package:uuid/uuid.dart';

class SingleChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();
  final DateTime _nowTime = DateTime.now();

  //CREATE CHAT
  Future<void> createChat(SingleChatModel chatModel, String chatId) async {
    await _firestore
        .collection("chat_rooms")
        .doc(chatId)
        .set(chatModel.toJson());
  }

  //SEND MESSAGE
  Future<void> sendMessage(MessageModel message, String chatId) async {
    final User currentUser = _auth.currentUser!;

    MessageModel newMessage = MessageModel(
        content: message.content,
        createdTime: _nowTime,
        senderId: currentUser.uid,
        messageId: message.messageId,
        receiverId: message.receiverId,
        type: message.type);

    await _firestore
        .collection("chat_rooms")
        .doc(chatId)
        .collection("messages")
        .doc(message.messageId)
        .set(newMessage.toJson());
  }

  //GET MESSAGE
  Stream<QuerySnapshot> getMessage(String chatId) {
    return _firestore
        .collection("chat_rooms")
        .doc(chatId)
        .collection("messages")
        .orderBy("createdTime", descending: false)
        .snapshots();
  }

  //GET CHATS
  Stream<QuerySnapshot<Map<String, dynamic>>?> getChat() {
    try {
      return _firestore
          .collection("chat_rooms")
          .where("members", arrayContains: _auth.currentUser!.uid)
          .snapshots();
    } catch (e) {
      debugPrint("Error getting chattrem $e");
    }
    return const Stream.empty();
  }

  //DELETE CHAT
  Future<void> deleteChat(String chatId) async {
    await _firestore.collection("chat_rooms").doc(chatId).delete();
  }

  //UPLOAD IMAGE
  Future<String?> uploadImage(
      MessageModel message, File imageFile, String chatId) async {
    final String currentUserEmail = _auth.currentUser!.email!;
    final String downloadUrl;

    final Reference storageRef =
        FirebaseStorage.instance.ref().child("images").child(_uuid.v4());
    final UploadTask uploadTask = storageRef.putFile(imageFile);

    try {
      await uploadTask;
      downloadUrl = await storageRef.getDownloadURL();

      MessageModel newMessage = MessageModel(
          content: downloadUrl,
          createdTime: _nowTime,
          senderId: currentUserEmail,
          messageId: message.messageId,
          receiverId: message.receiverId,
          type: message.type);

      await _firestore
          .collection("chat_rooms")
          .doc(chatId)
          .collection("messages")
          .doc(message.messageId)
          .set(newMessage.toJson());

      return downloadUrl;
    } catch (e) {
      debugPrint("Error adding image: $e");
    }
    return null;
  }

  //GET IMAGE
  Future<File?> getImage(ImageSource source) async {
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
