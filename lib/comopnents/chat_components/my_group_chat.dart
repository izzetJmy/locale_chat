// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/text_style.dart';

class MyGroupChat extends StatelessWidget {
  final bool leftOrRight;
  final String title;
  final String time;
  final String userImage;
  final String userName;

  const MyGroupChat({
    Key? key,
    required this.leftOrRight,
    required this.title,
    required this.time,
    required this.userImage,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return leftOrRight
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              contentText(size),
              const SizedBox(width: 10),
              profileInfo(size.width * 0.12),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              profileInfo(size.width * 0.12),
              const SizedBox(width: 10),
              contentText(size),
            ],
          );
  }

//Content text part of the chat
  Column contentText(Size size) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          leftOrRight ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Container(
          width: size.width * 0.765,
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
                ? const Color(0xffAAD9BB)
                : const Color(0xff939393).withOpacity(0.6),
          ),
          child: Text(
            title,
            style: singleChatCardTitleTextStyle,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          time,
          style: singleChatCardTimeTextStyle,
        )
      ],
    );
  }

//Profile info part of the chat
  Padding profileInfo(double? width) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: ProfileInfo(
        image_path: userImage,
        image_radius: 20,
        height: 4,
        showName: true,
        name: userName,
        profileNameTextStyle: groupChatCardProfileNameTextStyle,
        width: width,
      ),
    );
  }
}
