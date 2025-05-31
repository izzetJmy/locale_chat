// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/comopnents/my_profile_card.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/languages_keys.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/helper/localization_extention.dart';
import 'package:locale_chat/model/async_change_notifier.dart';
import 'package:locale_chat/model/messages_models/single_chat_model.dart';
import 'package:locale_chat/model/user_model.dart';
import 'package:locale_chat/pages/chat_pages/chat_page.dart';
import 'package:locale_chat/provider/chat_change_notifier/chat_change_notifier.dart';
import 'package:provider/provider.dart';

class ChatScreenWidget extends StatelessWidget {
  const ChatScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final String currentUserId = _auth.currentUser!.uid;

    String createChatId(String userId1, String userId2) {
      List<String> ids = [userId1, userId2];
      ids.sort();
      return "${ids[0]}_${ids[1]}_${DateTime.now().millisecondsSinceEpoch}";
    }

    return Consumer<ChatChangeNotifier>(
      builder: (context, chatNotifier, child) {
        // Show loading indicator when loading
        if (chatNotifier.state == AsyncChangeNotifierState.busy) {
          return Center(
            child: MyCircularProgressIndicator(),
          );
        }

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('Users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: MyCircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.errorsSearchNoOneToChat.locale(context),
                      style: homePageTitleTextStyle,
                    ),
                    Text(
                      LocaleKeys.errorsSearchSearchForPeople.locale(context),
                      style: homePageSubtitleTextStyle,
                    )
                  ],
                ),
              );
            }
            final users = snapshot.data!.docs
                .map((doc) => UserModel.fromJson(doc.data()))
                .toList();
            users.removeWhere((user) => user.id == currentUserId);
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final messages = FirebaseFirestore.instance
                    .collection('chat_rooms')
                    .where("members", arrayContains: currentUserId)
                    .snapshots()
                    .map((snapshot) => snapshot.docs
                        .where(
                          (doc) =>
                              (doc.data()['members'] as List).contains(user.id),
                        )
                        .firstOrNull)
                    .map((doc) =>
                        doc?.data()['lastMessage'] as String? ?? 'New Chat');

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: MyProfileCard(
                    leading: ProfileInfo(
                      image_path: user.profilePhoto,
                    ),
                    tittleText: Text(user.userName),
                    subtittleText: StreamBuilder<String>(
                        stream: messages,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text(
                              LocaleKeys.chatNewChat.locale(context),
                            );
                          }
                          return Text(snapshot.data!);
                        }),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: backgroundColor,
                    ),
                    height: 80,
                    onTap: () async {
                      final String chatId;

                      final existingChat = await FirebaseFirestore.instance
                          .collection("chat_rooms")
                          .where("members", arrayContains: currentUserId)
                          .get();

                      final exitingChatDoc = existingChat.docs
                          .where((doc) =>
                              (doc.data()['members'] as List).contains(user.id))
                          .firstOrNull;

                      if (exitingChatDoc != null) {
                        chatId = exitingChatDoc.id;
                      } else {
                        chatId = createChatId(currentUserId, user.id);
                        final SingleChatModel chatModel = SingleChatModel(
                            chatId: chatId, members: [currentUserId, user.id]);
                        chatNotifier.createChat(chatModel, chatId);
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            drop_down_menu_list: const [],
                            chatId: chatId,
                            receiverId: user.id,
                            title: user.userName,
                            image_path: user.profilePhoto,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

                    // Get the other user's ID (assuming the first member is the current user)
                    // final otherUserID = chat.members
                    //     .firstWhere((id) => id != _auth.currentUser!.uid);
                    // return FutureBuilder(
                    //   future: authNotifier.getUserInfo(otherUserID),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState == ConnectionState.waiting) {
                    //       return Center(child: MyCircularProgressIndicator());
                    //     }
                    //     if (snapshot.hasError) {
                    //       return Center(child: Text(snapshot.error.toString()));
                    //     }
                    //     if (snapshot.hasData || snapshot.data == null) {
                    //       return const Center(child: Text('User not found'));
                    //     }
                    //     final otherUser = snapshot.data;
                   
 