import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_profile_card.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/pages/onboarding_pages/onboarding_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: Scaffold(
            body: Center(
                child: MyProfileCard(
          height: 65,
          SubtittleText: Text('sdfsdfdsfsdfdsfsdfsd'),
          leading: ProfileInfo(
              image_path: 'assets/images/user_avatar.png', image_radius: 15),
          tittleText: Text('asıafnsdkj'),
          trailing: Text('svdvsdvds'),
        ))));
  }
}
