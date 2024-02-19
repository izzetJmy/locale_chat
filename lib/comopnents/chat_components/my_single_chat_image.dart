// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/text_style.dart';

class MySingleChatImage extends StatelessWidget {
  final bool leftOrRight;
  final String imagePath;
  final String time;
  final String userImage;
  final String userName;

  const MySingleChatImage({
    Key? key,
    required this.leftOrRight,
    required this.time,
    required this.userImage,
    required this.userName,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return contentImage(size);
  }

//Image part of the chat
  Align contentImage(Size size) {
    return Align(
      alignment: leftOrRight ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            leftOrRight ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color:
                      leftOrRight ? backgroundColor : const Color(0xff939393),
                  width: 2),
            ),
            child: Image(
              width: size.width * 0.5,
              height: size.height * 0.22,
              image: AssetImage(imagePath),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            time,
            style: singleChatCardTimeTextStyle,
          )
        ],
      ),
    );
  }
}
