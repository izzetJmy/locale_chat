import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_profile_card.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/text_style.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: backgroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Bildirimler', style: homePageTitleTextStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
              child: MyProfileCard(
                  leading: Icon(
                    CupertinoIcons.bell_fill,
                    color: backgroundColor,
                  ),
                  tittleText: const Text('denemeemedenemedeneme'),
                  profileCardTittleTextStyle: profileCardSubTittleTextStyle,
                  height: 80),
            );
          },
        ),
      ),
    );
  }
}
