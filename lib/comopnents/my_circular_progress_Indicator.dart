import 'package:flutter/material.dart';
import 'package:locale_chat/constants/colors.dart';

// ignore: must_be_immutable
class MyCircularProgressIndicator extends StatelessWidget {
  Color? progressIndicatorColor = backgroundColor;
  final double? height;
  final double? width;
  MyCircularProgressIndicator({
    Key? key,
    this.progressIndicatorColor,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: CircularProgressIndicator(
          color: progressIndicatorColor,
        ),
      ),
    );
  }
}
