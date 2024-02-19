import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_single_chat.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MySingleChat(
            leftOrRight: true,
            title: 'izaerrwerwefsdfdsfsef',
            time: '12:24',
          ),
        ),
      ),
    );
  }
}
