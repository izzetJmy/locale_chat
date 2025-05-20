import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locale_chat/model/messages_models/message_model.dart';
import 'package:locale_chat/model/messages_models/single_chat_model.dart';

class SingleChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateTime _nowTime = DateTime.now();

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    try {
      return _firestore
          .collection("Users")
          .snapshots(); // Fixed collection name to match other code
    } catch (e) {
      debugPrint('Error getting all users: $e');
      return const Stream.empty();
    }
  }

  //CREATE CHAT
  Future<void> createChat(SingleChatModel chatModel, String chatId) async {
    await _firestore
        .collection("chat_rooms")
        .doc(chatId)
        .set(chatModel.toJson());
  }

  Stream<QuerySnapshot> getUserChats(String userID) {
    return _firestore
        .collection("chat_rooms")
        .where("members", arrayContains: userID)
        .snapshots();
  }

  //SEND MESSAGE
  Future<void> sendMessage(MessageModel message, String chatId) async {
    final User currentUser = _auth.currentUser!;

    MessageModel newMessage = MessageModel(
        content: message.content,
        createdTime: DateTime.now(),
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

    //Update last message and last message time
    await _firestore.collection("chat_rooms").doc(chatId).update({
      "lastMessage":
          message.type == MessageType.PHOTO ? "Photo" : message.content,
      "lastMessageTime": _nowTime
    });
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
    var imageName = DateTime.now().millisecondsSinceEpoch.toString();
    final String currentUserEmail = _auth.currentUser!.email!;

    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('chats/$chatId/images/$imageName');
    final uploadTask = imageRef.putFile(imageFile);
    final TaskSnapshot taskSnapshot = await uploadTask;
    final String downloadURL = await taskSnapshot.ref.getDownloadURL();

    MessageModel newMessage = MessageModel(
        content: downloadURL,
        createdTime: DateTime.now(),
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

    return downloadURL;
  }

  //GET IMAGE
  Future<File?> getImage(ImageSource source) async {
    debugPrint(_auth.currentUser?.email);
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

  Future<List<String>> getAllImagesFromFolder(String folderPath) async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('User not authenticated');
      }
      final storageRef = FirebaseStorage.instance.ref();
      final folderRef = storageRef.child(folderPath);
      final result = await folderRef.listAll();
      List<String> imageUrls = [];
      for (var item in result.items) {
        try {
          final downloadUrl = await item.getDownloadURL();
          imageUrls.add(downloadUrl);
        } catch (e) {
          debugPrint("Error getting download URL for ${item.name}: $e");
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
