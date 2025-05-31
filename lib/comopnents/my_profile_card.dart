import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_marquee.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/text_style.dart';

class MyProfileCard extends StatelessWidget {
  final Widget leading;
  final Widget? tittleText;
  final TextStyle? profileCardTittleTextStyle;
  final Widget? subtittleText;
  final Widget? trailing;
  final double height;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final double containerRadius;

  const MyProfileCard({
    super.key,
    required this.leading,
    this.tittleText,
    this.subtittleText,
    this.trailing,
    required this.height,
    this.onTap,
    this.profileCardTittleTextStyle,
    this.containerRadius = 20,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: profileCardColor,
        borderRadius: BorderRadius.circular(containerRadius),
        border: Border.all(width: 0, color: profileCardColor),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
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
        onLongPress: onLongPress,
        leading: leading,
        title: MyMarquee(
          textToMeasure: tittleText?.toString() ?? '',
          textStyleToMeasure: profileCardTittleTextStyle,
          child: tittleText!,
        ),
        titleTextStyle: profileCardTittleTextStyle,
        subtitle: subtittleText,
        trailing: trailing,
        subtitleTextStyle: profileCardSubTittleTextStyle,
        splashColor: Colors.transparent,
      ),
    );
  }
}
