import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locale_chat/model/message_model.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid uuid = const Uuid();
  DateTime nowTime = DateTime.now();

  //SEND MESSAGE
  Future<void> sendMessage(MessageModel message) async {
    final String currentUserEmail = _auth.currentUser!.email!;
    MessageModel newMessage = MessageModel(
        chatId: message.chatId,
        content: message.content,
        createdTime: nowTime,
        senderId: currentUserEmail,
        messageId: message.messageId,
        receiverId: message.receiverId,
        type: message.type);

    await _firestore
        .collection("chat_rooms")
        .doc(message.chatId)
        .collection("messages")
        .add(newMessage.toJson());
  }

  //GET MESSAGE
  Stream<QuerySnapshot> getMessage(MessageModel message) {
    return _firestore
        .collection("chat_rooms")
        .doc(message.chatId)
        .collection("messages")
        .orderBy(message.createdTime, descending: false)
        .snapshots();
  }

  //UPLOAD IMAGE
  Future<String?> uploadImage(MessageModel message, File imageFile) async {
    final String currentUserEmail = _auth.currentUser!.email!;
    final String downloadUrl;

    final Reference storageRef =
        FirebaseStorage.instance.ref().child("images").child(uuid.v4());
    final UploadTask uploadTask = storageRef.putFile(imageFile);

    try {
      await uploadTask;
      downloadUrl = await storageRef.getDownloadURL();

      MessageModel newMessage = MessageModel(
          chatId: message.chatId,
          content: downloadUrl,
          createdTime: nowTime,
          senderId: currentUserEmail,
          messageId: message.messageId,
          receiverId: message.receiverId,
          type: message.type);

      await _firestore
          .collection("chat_rooms")
          .doc(message.chatId)
          .collection("messages")
          .add(newMessage.toJson());

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

  //GET CHATS
  Stream<DocumentSnapshot<Map<String, dynamic>>?> getChat(String chatId) {
    try {
      return _firestore.collection("chat_rooms").doc(chatId).snapshots();
    } catch (e) {
      debugPrint("Error getting chattrem $e");
    }
    return const Stream.empty();
  }

  //DELETE CHAT
  Future<void> deleteChat(String chatId) async {
    await _firestore.collection("chat_rooms").doc(chatId).delete();
  }
}
