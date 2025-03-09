// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/model/async_change_notifier.dart';
import 'package:locale_chat/pages/control_page.dart';
import 'package:locale_chat/provider/chat_change_notifier/chat_change_notifier.dart';
import 'package:locale_chat/provider/group_change_notifier/group_change_notifier.dart';
import 'package:locale_chat/provider/location_change_notifier/locaiton_change_notifier.dart';
import 'package:provider/provider.dart';

class AuthControlPage extends StatelessWidget {
  const AuthControlPage({super.key});
//ilk önce onboarding sayfaları gösterilcek o yüzden initial_page sayıfasına gidicek
//sonra login olup olmadığına bakacak eğer login olduysa auth controle page gidecek
//auth controlde de bir sorun yoksa sonra control page sayfasına gidecek
  @override
  Widget build(BuildContext context) {
    return Consumer3<ChatChangeNotifier, GroupChangeNotifier,
        LocationChangeNotifier>(
      builder: (context, chats, groups, locations, child) {
        if (chats.state != AsyncChangeNotifierState.idle ||
            groups.state != AsyncChangeNotifierState.idle ||
            locations.state != AsyncChangeNotifierState.idle) {
          return Scaffold(
            body: Center(
              child: MyCircularProgressIndicator(),
            ),
          );
        }
        return const ControlPage();
      },
    );
  }
}
