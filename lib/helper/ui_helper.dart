import 'package:flutter/material.dart';

class UIHelper {
  static double getDeviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getDeviceWith(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
