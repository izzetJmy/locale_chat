import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_appbar.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_profile_card.dart';
import 'package:locale_chat/comopnents/my_text_field.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/image_path.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/helper/ui_helper.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  TextEditingController controller = TextEditingController();
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: backgroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Grup Oluştur', style: homePageTitleTextStyle),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
              top: UIHelper.getDeviceHeight(context) * 0.01,
              bottom: UIHelper.getDeviceHeight(context) * 0.05,
              left: UIHelper.getDeviceHeight(context) * 0.03,
              right: UIHelper.getDeviceHeight(context) * 0.03),
          child: Column(
            children: [
              //Create group photo
              ProfileInfo(
                image_path: ImagePath.user_avatar,
                image_radius: 40,
              ),
              const SizedBox(height: 10),
              //Create group name
              MyTextField(
                prefixIcon: Icon(
                  Icons.group,
                  color: backgroundColor,
                ),
                controller: controller,
                hintText: 'Grup adı',
                borderRadius: 10,
                borderSideColor: Colors.transparent,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  thickness: 1,
                  color: Color(0xffCBCBCB),
                ),
              ),
              //Add user for group
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      child: MyProfileCard(
                        height: 80,
                        leading: const ProfileInfo(
                            image_path: 'assets/images/user_avatar.png'),
                        tittleText: const Text('Asım Şef'),
                        subtittleText: const Text('selam'),
                        trailing: Icon(
                          isCheck
                              ? Icons.check_box_outline_blank
                              : Icons.check_box,
                          color: backgroundColor,
                        ),
                        onTap: () {
                          setState(() {
                            isCheck = !isCheck;
                            debugPrint(isCheck.toString());
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              //Button of create group
              MyButton(
                height: UIHelper.getDeviceHeight(context) * 0.06,
                width: UIHelper.getDeviceHeight(context) * 0.25,
                buttonColor: backgroundColor,
                buttonText: 'Oluştur',
                textStyle: onboardingPageButtonTextTextStyle,
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
