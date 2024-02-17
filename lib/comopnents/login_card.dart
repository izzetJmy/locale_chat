import 'package:flutter/material.dart';
import 'package:locale_chat/constants/colors.dart';

class MyLoginCard extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Widget column;
  const MyLoginCard({super.key, required this.padding, required this.column});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: cardBoxShadow,
          gradient: backgroundGradientColor),
      child: column,
    );
  }
}
