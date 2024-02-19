// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/text_style.dart';

class MySingleChat extends StatelessWidget {
  final bool leftOrRight;
  final String title;
  final String time;

  const MySingleChat({
    Key? key,
    required this.leftOrRight,
    required this.title,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: leftOrRight ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            leftOrRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                  bottomLeft: leftOrRight
                      ? const Radius.circular(10)
                      : const Radius.circular(0),
                  bottomRight: leftOrRight
                      ? const Radius.circular(0)
                      : const Radius.circular(10)),
              color: leftOrRight
                  ? backgroundColor
                  : const Color(0xff939393).withOpacity(0.6),
            ),
            child: Text(
              title,
              style: singleChatCartTitleTextStyle,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            time,
            style: singleChatCartTimeTextStyle,
          )
        ],
      ),
    );
  }
}
