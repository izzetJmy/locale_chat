import 'package:flutter/material.dart';

// Light mode colors
Color lightBackgroundColor = const Color(0xffAAD9BB);
Color lightButtonColor = const Color(0xffAAD9BB);

// Dark mode colors
Color darkBackgroundColor = const Color.fromARGB(255, 53, 53, 53);
Color darkButtonColor = const Color.fromARGB(255, 53, 53, 53);

Color lightAppBarColor = Colors.white;
Color darkAppBarColor = const Color.fromARGB(255, 53, 53, 53);

Color lightProfileCardColor = Color.fromARGB(208, 255, 255, 255);
Color darkProfileCardColor = const Color.fromARGB(255, 53, 53, 53);

Color lightDefaultTextColor = const Color(0xff939393);
Color darkDefaultTextColor = Colors.white;

Color lightIconColor = const Color(0xffAAD9BB);
Color darkIconColor = Colors.white;

Color lightGeneralBackgroundColor = Colors.white;
Color darkGeneralBackgroundColor = const Color(0xFF1F1F1F);

Color defaultTextColor = lightDefaultTextColor;

// Current theme colors (will be updated based on theme mode)
Color backgroundColor = lightBackgroundColor;
Color buttonColor = lightButtonColor;
Color appBarColor = lightAppBarColor;
Color profileCardColor = lightProfileCardColor;
Color iconColor = lightIconColor;
Color generalBackgroundColor = lightGeneralBackgroundColor;

// Light mode gradients
Gradient lightBackgroundGradient = LinearGradient(
  colors: [
    const Color.fromARGB(255, 227, 255, 238).withOpacity(0.4),
    const Color.fromARGB(255, 226, 255, 237).withOpacity(0.6)
  ],
  begin: FractionalOffset.topLeft,
  end: FractionalOffset.bottomRight,
);

// Dark mode gradients
Gradient darkBackgroundGradient = LinearGradient(
  colors: [
    const Color(0xFF2C2C2C).withOpacity(0.4),
    const Color(0xFF1F1F1F).withOpacity(0.6)
  ],
  begin: FractionalOffset.topLeft,
  end: FractionalOffset.bottomRight,
);

// Current theme gradient
Gradient backgroundGradientColor = lightBackgroundGradient;

// Light mode bottom navigator gradient
Gradient lightBottomNavigatorBarBackgroundGradient = LinearGradient(
  colors: [
    const Color.fromARGB(255, 187, 221, 202).withOpacity(0.4),
    const Color.fromARGB(255, 197, 228, 210).withOpacity(0.6)
  ],
  begin: FractionalOffset.topLeft,
  end: FractionalOffset.bottomRight,
);

// Dark mode bottom navigator gradient
Gradient darkBottomNavigatorBarBackgroundGradient = LinearGradient(
  colors: [
    const Color(0xFF2C2C2C).withOpacity(0.4),
    const Color(0xFF1F1F1F).withOpacity(0.6)
  ],
  begin: FractionalOffset.topLeft,
  end: FractionalOffset.bottomRight,
);

// Current bottom navigator gradient
Gradient bottomNavigatorBarBackgroundGradientColor =
    lightBottomNavigatorBarBackgroundGradient;

// Shadows
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

// Function to update theme colors
void updateThemeColors(bool isDarkMode) {
  backgroundColor = isDarkMode ? darkBackgroundColor : lightBackgroundColor;
  buttonColor = isDarkMode ? darkButtonColor : lightButtonColor;
  backgroundGradientColor =
      isDarkMode ? darkBackgroundGradient : lightBackgroundGradient;
  bottomNavigatorBarBackgroundGradientColor = isDarkMode
      ? darkBottomNavigatorBarBackgroundGradient
      : lightBottomNavigatorBarBackgroundGradient;
  appBarColor = isDarkMode ? darkAppBarColor : lightAppBarColor;
  profileCardColor = isDarkMode ? darkProfileCardColor : lightProfileCardColor;
  defaultTextColor = isDarkMode ? darkDefaultTextColor : lightDefaultTextColor;
  iconColor = isDarkMode ? darkIconColor : lightIconColor;
  generalBackgroundColor =
      isDarkMode ? darkGeneralBackgroundColor : lightGeneralBackgroundColor;
}
