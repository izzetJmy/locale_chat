import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_group_chat.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: MyGroupChat(
            leftOrRight: true,
            title:
                'izaefsdfdgcvghcwefewewaefsdfdgcvghcwefewewaefsdfdgcvghcwefewewaefsdfdgcvghcwefewewaefsdfdgcvghcwefewewaefsdfdgcvghcwefewewaefsdfdgcvghcwefewew',
            time: '12:24',
            userImage: 'assets/images/user_avatar.png',
            userName: 'İzzet Şef',
          ),
        ),
      ),
    );
  }
}
