import 'package:flutter/material.dart';
import 'package:locale_chat/constants/colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget title;
  final List<Widget>? actions;
  final double? elevation;
  const MyAppBar({
    super.key,
    this.leading,
    required this.title,
    this.actions,
    this.elevation = 4,
  }) : preferredSize = const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: leading,
      title: title,
      centerTitle: true,
      actions: actions,
      elevation: elevation,
      surfaceTintColor: appBarColor,
      shadowColor: Colors.grey.shade400,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
    );
  }

  @override
  final Size preferredSize;
}
