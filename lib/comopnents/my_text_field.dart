import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final String hintText;
  final String? Function(String?)? validatorFunction;

  const MyTextField({
    super.key,
    required this.prefixIcon,
    this.suffixIcon,
    required this.hintText,
    required this.validatorFunction,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.052,
      child: TextFormField(
        validator: validatorFunction,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
        ),
      ),
    );
  }
}
