import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  void Function() onPressed;
  String buttonText;
  TextStyle textStyle;
  Color buttonColor;
  double width;
  double height;
  MyButton({
    super.key,
    required this.width,
    required this.height,
    required this.buttonColor,
    required this.onPressed,
    required this.buttonText,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                blurRadius: 3.7,
                offset: const Offset(3, 3),
                spreadRadius: 0,
                color: const Color(0xff1C2E31).withOpacity(0.4))
          ],
        ),
        child: Text(
          buttonText,
          style: textStyle,
        ),
      ),
    );
  }
}
