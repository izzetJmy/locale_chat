// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final String hintText;
  final bool obscureText;
  final Color fillColor;
  final Color prefixIconColor;
  final Color suffixIconColor;
  final Color borderSideColor;
  final TextStyle hintStyle;
  final String? Function(String?)? validatorFunction;
  final double borderRadius;
  const MyTextField({
    Key? key,
    required this.controller,
    required this.prefixIcon,
    this.suffixIcon,
    required this.hintText,
    this.obscureText = false,
    this.validatorFunction,
    this.fillColor = Colors.white,
    this.prefixIconColor = const Color(0xffC4C4C4),
    this.suffixIconColor = const Color(0xffC4C4C4),
    this.borderSideColor = const Color(0xffD3D3D3),
    this.hintStyle = const TextStyle(color: Color(0xffD3D3D3), fontSize: 18),
    this.borderRadius = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: size.height * 0.052,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
              blurRadius: 8,
              offset: const Offset(0, 3),
              spreadRadius: 0,
              color: const Color(0xff1C2E31).withOpacity(0.1)),
          const BoxShadow(color: Colors.white)
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validatorFunction,
        cursorColor: Colors.grey,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          prefixIconColor: prefixIconColor,
          suffixIconColor: suffixIconColor,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: hintStyle,
          fillColor: fillColor,
          filled: true,
          contentPadding: const EdgeInsets.all(0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderSideColor,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderSideColor,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
