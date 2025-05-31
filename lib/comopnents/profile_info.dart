// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/constants/colors.dart';

class ProfileInfo extends StatelessWidget {
  final void Function()? onTap;

  final String image_path;
  final double? image_radius;
  final bool isNetworkImage;

  final double height;
  final double? width;
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
      this.width,
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
                      border: Border.all(color: backgroundColor, width: 2),
                    ),
                    child: _buildProfileAvatar(),
                  ),
                ),
              SizedBox(height: height),
              if (showName) //User name
                SizedBox(
                  width: width,
                  child: Text(
                    textAlign: TextAlign.center,
                    name,
                    style: profileNameTextStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
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

    if (shouldUseNetworkImage && image_path.isNotEmpty) {
      // For network images (including Firebase Storage)
      return CircleAvatar(
        radius: image_radius,
        backgroundColor: Colors.grey[200],
        backgroundImage: Image.network(
          image_path,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: 200,
              height: 200,
              child: Center(
                child: MyCircularProgressIndicator(),
              ),
            );
          },
        ).image,
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
