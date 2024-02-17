// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/text_style.dart';

class ProfileInfo extends StatelessWidget {
  final void Function()? onTap;

  final String image_path;
  final double? image_radius;

  final String name;
  final String date;

  final bool showCircleAvatar;
  final bool showName;
  final bool showDate;

  const ProfileInfo(
      {super.key,
      this.onTap,
      required this.image_path,
      this.image_radius,
      this.name = '',
      this.date = '',
      this.showCircleAvatar = true,
      this.showName = false,
      this.showDate = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCircleAvatar) //User's profile avatar
              InkWell(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: backgroundColor),
                  ),
                  child: CircleAvatar(
                    radius: image_radius,
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      image_path,
                      opacity: const AlwaysStoppedAnimation(0.3),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            if (showName) //User name
              Text(name, style: profileInfoNameTextStyle),
            if (showDate) //Date the account was created
              Text(
                date,
                style: profileInfoDateTextStyle,
              )
          ],
        ),
      ),
    );
  }
}
