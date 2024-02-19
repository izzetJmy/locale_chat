import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/chat_components/my_single_chat_image.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: MySingleChatImage(
            leftOrRight: false,
            imagePath: 'assets/images/first_onboarding_page_image.png',
            time: '12:24',
            userImage: 'assets/images/user_avatar.png',
            userName: 'İzzet Şef',
          ),
        ),
      ),
    );
  }
}
