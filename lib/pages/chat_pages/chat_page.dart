// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_appbar.dart';
import 'package:locale_chat/comopnents/my_text_field.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/text_style.dart';

class ChatPage extends StatefulWidget {
  final String? title;
  final String? image_path;

  //Widget for drop down menu at the top right
  final List<PopupMenuEntry<String>> drop_down_menu_list;
  final void Function(String)? onSelected;
  const ChatPage(
      {super.key,
      this.title,
      this.image_path,
      required this.drop_down_menu_list,
      this.onSelected});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: const ProfileInfo(
            image_path: 'assets/images/user_avatar.png',
            image_radius: 17,
          ),
          title: Text(
            'İzzet Şef',
            style: appBarTitleTextStyle,
          ),
          subtitle: Text(
            'Günaydın',
            style: appBarSubTitleTextStyle,
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) => widget.onSelected,
            itemBuilder: (context) => widget.drop_down_menu_list,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                thickness: 1,
                color: Color(0xffCBCBCB),
              ),
            ),
            Row(
              children: [
                //Message text field
                Expanded(
                  child: MyTextField(
                    controller: controller,
                    fillColor: backgroundColor.withOpacity(0.2),
                    hintText: 'Mesaj',
                    hintStyle: myTextFieldTextStyle,
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.emoji_emotions_outlined),
                      onPressed: () {},
                    ),
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.camera_alt), onPressed: () {}),
                    prefixIconColor: const Color(0xff939393),
                    suffixIconColor: const Color(0xff939393),
                    borderSideColor: Colors.transparent,
                  ),
                ),
                const SizedBox(width: 5),
                //Send button
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: backgroundColor),
                  child: IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.send),
                    onPressed: () {},
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
