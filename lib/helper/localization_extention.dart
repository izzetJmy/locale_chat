import 'package:flutter/material.dart';
import 'package:locale_chat/provider/general_change_notifier.dart';
import 'package:provider/provider.dart';

extension StringLocalization on String {
  String locale(BuildContext context) {
    if (!context.mounted) {
      return this; // Return the original string if context is not mounted
    }

    try {
      final notifier =
          Provider.of<GeneralChangeNotifier>(context, listen: false);
      return notifier.translate(this);
    } catch (e) {
      return this; // Return the original string if provider access fails
    }
  }
}
