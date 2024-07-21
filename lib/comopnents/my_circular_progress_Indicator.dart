import 'package:flutter/material.dart';
import 'package:locale_chat/constants/colors.dart';

class MyCircularProgressIndicator extends StatelessWidget {
  const MyCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: backgroundColor,
      ),
    );
  }
}
