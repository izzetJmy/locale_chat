// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:locale_chat/constants/colors.dart';

class ProfileInfo extends StatelessWidget {
  final void Function()? onTap;

  final String image_path;
  final double? image_radius;
  final bool isNetworkImage;

  final double height;
  final String name;
  final String date;

  final TextStyle? profileNameTextStyle;
  final TextStyle? profileInfoDateTextStyle;

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
      this.showDate = false,
      this.profileNameTextStyle,
      this.height = 10,
      this.isNetworkImage = false,
      this.profileInfoDateTextStyle});

  @override
  Widget build(BuildContext context) {
    return !showName && !showDate
        ? InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: backgroundColor),
              ),
              child: _buildProfileAvatar(),
            ),
          )
        : Column(
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
                    child: _buildProfileAvatar(),
                  ),
                ),
              SizedBox(height: height),
              if (showName) //User name
                Text(name, style: profileNameTextStyle),
              if (showDate) //Date the account was created
                Text(
                  date,
                  style: profileInfoDateTextStyle,
                )
            ],
          );
  }

  Widget _buildProfileAvatar() {
    // Check if the image path is a Firebase Storage URL or if isNetworkImage flag is set
    bool isFirebaseUrl =
        image_path.startsWith('https://firebasestorage.googleapis.com');
    bool shouldUseNetworkImage = isFirebaseUrl || isNetworkImage;

    debugPrint('ProfileInfo: image_path = $image_path');
    debugPrint(
        'ProfileInfo: isNetworkImage = $isNetworkImage, isFirebaseUrl = $isFirebaseUrl');

    if (shouldUseNetworkImage && image_path.isNotEmpty) {
      // For network images (including Firebase Storage)
      return CircleAvatar(
        radius: image_radius,
        backgroundColor: Colors.grey[200],
        backgroundImage: NetworkImage(
          image_path,
        ),
        onBackgroundImageError: (exception, stackTrace) {
          debugPrint('Error loading profile image: $exception');
        },
      );
    } else {
      // For asset images
      return CircleAvatar(
        radius: image_radius,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage(image_path),
      );
    }
  }
}
