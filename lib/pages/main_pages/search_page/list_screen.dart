// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/comopnents/my_profile_card.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/model/async_change_notifier.dart';
import 'package:locale_chat/model/location_model.dart';
import 'package:locale_chat/model/messages_models/single_chat_model.dart';
import 'package:locale_chat/pages/chat_pages/chat_page.dart';
import 'package:locale_chat/provider/chat_change_notifier/chat_change_notifier.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  final bool isEmpty;

  const ListScreen({Key? key, required this.isEmpty}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userID = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    getOtherLocations();
    super.initState();
  }

  Stream<List<PositionModel>> getOtherLocations() {
    return _firestore.collection('location').doc(_userID).snapshots().map(
      (snapshot) {
        if (!snapshot.exists) return [];

        var data = snapshot.data();
        if (data == null || data['locations'] == null) return [];
        if (data['locations'] is Map<String, dynamic>) {
          return (data['locations'] as Map<String, dynamic>)
              .entries
              .map(
                (entry) =>
                    PositionModel.fromJson(entry.value as Map<String, dynamic>),
              )
              .toList();
        }
        if (data['locations'] is List) {
          return (data['locations'] as List<dynamic>)
              .map((value) =>
                  PositionModel.fromJson(value as Map<String, dynamic>))
              .toList();
        }

        debugPrint("data: $data");
        return [];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //final List<String> _userIDs = [];
    String createChatId(String userId1, String userId2) {
      List<String> ids = [userId1, userId2];
      ids.sort();
      return "${ids[0]}_${ids[1]}_${DateTime.now().millisecondsSinceEpoch}";
    }

    return Consumer<ChatChangeNotifier>(
      builder: (context, chatNotifier, child) {
        if (chatNotifier.state == AsyncChangeNotifierState.busy) {
          return Center(
            child: MyCircularProgressIndicator(),
          );
        }

        return StreamBuilder<List<PositionModel>>(
          stream: getOtherLocations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Hata: ${snapshot.error}"));
            }
            if (!snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Henüz biriyle tanışmadın',
                      style: homePageTitleTextStyle,
                    ),
                    Text(
                      'Hemen arama yap!',
                      style: homePageSubtitleTextStyle,
                    )
                  ],
                ),
              );
            }

            final locations = snapshot.data!;
            final List<String> userIDs = locations
                .where((location) => location.id != _userID)
                .map((location) => location.id)
                .toList();
            return StreamBuilder(
              stream: _firestore.collection('Users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Hata: ${snapshot.error}"));
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text("No data available"));
                }
                return ListView.builder(
                  itemCount: userIDs.length,
                  itemBuilder: (context, index) {
                    final userId = userIDs[index];
                    final userDoc = snapshot.data?.docs
                        .where((doc) => doc.id == userId)
                        .firstOrNull;

                    if (userDoc == null) {
                      return const SizedBox
                          .shrink(); // or any other fallback widget
                    }

                    final userData = userDoc.data();
                    final messages = _firestore
                        .collection('chat_rooms')
                        .where('members', arrayContains: _userID)
                        .snapshots()
                        .map((snapshot) => snapshot.docs
                            .where((doc) => (doc.data()['members'] as List)
                                .contains(userId))
                            .firstOrNull)
                        .map((doc) =>
                            doc?.data()['lastMessage'] as String? ??
                            'New Chat');
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      child: MyProfileCard(
                        tittleText: Text(userData['userName'] ?? 'Anoninymous'),
                        leading: ProfileInfo(
                          image_path: userData['profilePhoto'] ??
                              'assets/images/user_avatar.png',
                        ),
                        subtittleText: StreamBuilder<String>(
                          stream: messages,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Text('New Chat');
                            }
                            return Text(snapshot.data!);
                          },
                        ),
                        height: 80,
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: backgroundColor,
                        ),
                        onTap: () async {
                          final String chatId;

                          final existingChat = await FirebaseFirestore.instance
                              .collection("chat_rooms")
                              .where("members", arrayContains: _userID)
                              .get();

                          final exitingChatDoc = existingChat.docs
                              .where((doc) => (doc.data()['members'] as List)
                                  .contains(userData['id']))
                              .firstOrNull;

                          if (exitingChatDoc != null) {
                            chatId = exitingChatDoc.id;
                          } else {
                            chatId = createChatId(_userID, userData['id']);
                            final SingleChatModel chatModel = SingleChatModel(
                                chatId: chatId,
                                members: [_userID, userData['id']]);
                            chatNotifier.createChat(chatModel, chatId);
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                    drop_down_menu_list: const [],
                                    chatId: chatId,
                                    receiverId: userId,
                                    title: userData['userName'] ?? 'Anonymous',
                                    image_path: userData['profilePhoto'] ??
                                        'assets/images/user_avatar.png'),
                              ));
                        },
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
