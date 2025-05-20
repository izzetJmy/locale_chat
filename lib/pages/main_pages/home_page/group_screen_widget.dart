import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/comopnents/my_profile_card.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/image_path.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/model/async_change_notifier.dart';
import 'package:locale_chat/model/messages_models/group_chat_model.dart';
import 'package:locale_chat/pages/group_pages/group_page.dart';
import 'package:locale_chat/provider/chat_change_notifier/chat_change_notifier.dart';
import 'package:provider/provider.dart';

class GroupScreenWidget extends StatelessWidget {
  const GroupScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatChangeNotifier>(
      builder: (context, chatNotifier, child) {
        // Show loading indicator when loading
        if (chatNotifier.state == AsyncChangeNotifierState.busy) {
          return Center(
            child: MyCircularProgressIndicator(),
          );
        }
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream:
              FirebaseFirestore.instance.collection('group_rooms').snapshots(),
          builder: (BuildContext context, snapshot) {
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
            final groups = snapshot.data!.docs
                .map((doc) => GroupChatModel.fromJson(doc.data()))
                .toList();
            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: MyProfileCard(
                    leading: ProfileInfo(
                      image_path:
                          group.groupProfilePhoto ?? ImagePath.group_avatar,
                    ),
                    tittleText: Text(group.groupName),
                    height: 80,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupPage(group: group)),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
        // Check if chats list is empty
      },
    );
  }
}
