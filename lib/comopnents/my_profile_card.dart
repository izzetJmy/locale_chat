import 'package:flutter/material.dart';
import 'package:locale_chat/constants/text_style.dart';

class MyProfileCard extends StatelessWidget {
  final Widget leading;
  final Widget tittleText;
  final Widget? subtittleText;
  final Widget trailing;
  final double height;
  final void Function()? onTap;

  const MyProfileCard({
    super.key,
    required this.leading,
    required this.tittleText,
    this.subtittleText,
    required this.trailing,
    required this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 0, color: Colors.white),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      height: height,
      width: size.width * 0.9,
      child: ListTile(
        onTap: onTap,
        leading: leading,
        title: tittleText,
        titleTextStyle: profileCardTittleTextStyle,
        subtitle: subtittleText,
        trailing: trailing,
        subtitleTextStyle: profileCardSubTittleTextStyle,
      ),
    );
  }
}
