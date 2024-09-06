import 'package:flutter/material.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:locale_chat/provider/chat_change_notifier/chat_change_notifier.dart';
import 'package:locale_chat/provider/group_change_notifier/group_change_notifier.dart';
import 'package:locale_chat/provider/location_change_notifier/locaiton_change_notifier.dart';
import 'package:provider/provider.dart';

class RootPage extends StatelessWidget {
  final AuthChangeNotifier authChangeNotifier;
  final ChatChangeNotifier chatChangeNotifier;
  final GroupChangeNotifier groupChangeNotifier;
  final LocationChangeNotifier locationChangeNotifier;
  final Widget child;

  const RootPage({
    super.key,
    required this.authChangeNotifier,
    required this.chatChangeNotifier,
    required this.groupChangeNotifier,
    required this.locationChangeNotifier,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<AuthChangeNotifier>.value(
          value: authChangeNotifier),
      ChangeNotifierProvider<ChatChangeNotifier>.value(
          value: chatChangeNotifier),
      ChangeNotifierProvider<GroupChangeNotifier>.value(
          value: groupChangeNotifier),
      ChangeNotifierProvider<LocationChangeNotifier>.value(
          value: locationChangeNotifier),
    ], child: child);
  }
}
