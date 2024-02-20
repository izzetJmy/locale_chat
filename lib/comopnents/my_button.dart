import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function() onPressed;
  final String buttonText;
  final TextStyle textStyle;
  final Color? buttonColor;
  final Gradient? buttonGradient;
  final double width;
  final double height;
  const MyButton({
    super.key,
    required this.width,
    required this.height,
    required this.buttonColor,
    required this.onPressed,
    required this.buttonText,
    required this.textStyle,
    this.buttonGradient,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor,
          gradient: buttonGradient,
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
