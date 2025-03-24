import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_profile_card.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/provider/chat_change_notifier/chat_change_notifier.dart';
import 'package:provider/provider.dart';

class GroupScreenWidget extends StatelessWidget {
  const GroupScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatChangeNotifier>(
      builder: (context, chatNotifier, child) {
        // Check if chats list is empty
        bool isEmpty =
            chatNotifier.chats == null || chatNotifier.chats!.isEmpty;

        if (isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Henüz bir grupta değilsin',
                  style: homePageTitleTextStyle,
                ),
                Text(
                  'hemen yeni bir grup oluştur.',
                  style: homePageSubtitleTextStyle,
                )
              ],
            ),
          );
        } else {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 10, // This would be the actual group count
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: MyProfileCard(
                  leading: const ProfileInfo(
                    image_path: 'assets/images/user_avatar.png',
                  ),
                  tittleText: const Text('Grup Adı'),
                  subtittleText: const Text('4 kişi var'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: backgroundColor,
                  ),
                  height: 80,
                ),
              );
            },
          );
        }
      },
    );
  }
}
