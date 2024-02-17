import 'package:flutter/material.dart';

Color backgroundColor = const Color(0xffAAD9BB);

Gradient backgroundGradientColor = LinearGradient(
  colors: [
    const Color.fromARGB(255, 227, 255, 238).withOpacity(0.4),
    const Color.fromARGB(255, 226, 255, 237).withOpacity(0.6)
  ],
  begin: FractionalOffset.topLeft,
  end: FractionalOffset.bottomRight,
);

Gradient bottomNavigatorBarBackgroundGradientColor = LinearGradient(
  colors: [
    const Color.fromARGB(255, 187, 221, 202).withOpacity(0.4),
    const Color.fromARGB(255, 197, 228, 210).withOpacity(0.6)
  ],
  begin: FractionalOffset.topLeft,
  end: FractionalOffset.bottomRight,
);

List<BoxShadow>? cardBoxShadow = [
  BoxShadow(
    blurRadius: 3,
    color: Colors.black12.withOpacity(0.05),
    offset: const Offset(4, 4),
    spreadRadius: 2,
  )
];

List<BoxShadow>? bottomNavigatorBarBoxShadow = [
  BoxShadow(
    color: Colors.grey.shade400,
    blurRadius: 3,
    offset: const Offset(0, 3),
  ),
  const BoxShadow(
    color: Colors.white,
  )
];

List<BoxShadow>? searchButtonBoxShadow = [
  BoxShadow(
    blurRadius: 5,
    color: Colors.grey.shade400,
    offset: const Offset(0, 3),
  )
];
