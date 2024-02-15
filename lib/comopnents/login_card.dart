import 'package:flutter/material.dart';

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
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            color: Colors.black12.withOpacity(0.05),
            offset: const Offset(4, 4),
            spreadRadius: 2,
          )
        ],
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 227, 255, 238).withOpacity(0.4),
            const Color.fromARGB(255, 226, 255, 237).withOpacity(0.6)
          ],
          begin: FractionalOffset.topLeft,
          end: FractionalOffset.bottomRight,
        ),
      ),
      child: column,
    );
  }
}
