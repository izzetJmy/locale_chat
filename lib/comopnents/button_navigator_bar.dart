import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/constants/colors.dart';

class MyNavigatorBar extends StatefulWidget {
  final int pageIndex;
  final Function(int) onTap;
  const MyNavigatorBar(
      {super.key, required this.pageIndex, required this.onTap});
  @override
  State<MyNavigatorBar> createState() => _MyNavigatorBarState();
}

class _MyNavigatorBarState extends State<MyNavigatorBar> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
          left: size.width * 0.22,
          right: size.width * 0.22,
          bottom: Platform.isAndroid ? 16 : 8),

      //Bottom Navigation Bar
      child: BottomAppBar(
        shadowColor: Colors.black,
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: bottomNavigatorBarBoxShadow,
            gradient: bottomNavigatorBarBackgroundGradientColor,
          ),
          height: size.height * 0.07,
          child: Row(
            children: [
              navItem(
                CupertinoIcons.home,
                widget.pageIndex == 1,
                onTap: () => widget.onTap(1),
              ),
              SizedBox(width: size.width * 0.12),
              navItem(
                CupertinoIcons.person,
                widget.pageIndex == 2,
                onTap: () => widget.onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

//This function to create clickable icon
  Widget navItem(IconData icon, bool selected, {Function()? onTap}) {
    return Expanded(
        child: InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Icon(
        icon,
        color: selected
            ? Colors.black.withOpacity(0.8)
            : const Color.fromARGB(255, 175, 173, 173),
        size: 25,
      ),
    ));
  }
}
