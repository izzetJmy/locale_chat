import 'package:flutter/material.dart';
import 'package:locale_chat/helper/ui_helper.dart';

class MySanckbar {
  static Future<void> mySnackbar(
      BuildContext context, String text, int duration) async {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: duration),
        dismissDirection: DismissDirection.up,
        behavior: SnackBarBehavior.floating,
        width: UIHelper.getDeviceWith(context) * 0.8,
        backgroundColor: Colors.black.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
