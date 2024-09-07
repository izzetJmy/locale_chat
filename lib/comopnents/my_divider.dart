import 'package:flutter/material.dart';
import 'package:locale_chat/helper/ui_helper.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Divider(
            endIndent: UIHelper.getDeviceWith(context) * 0.03,
            indent: UIHelper.getDeviceWith(context) * 0.3,
            thickness: 2,
            color: const Color(0xffD7D7D7),
          ),
        ),
        Text(
          'OR',
          style: TextStyle(
              fontSize: UIHelper.getDeviceHeight(context) * 0.023,
              color: const Color(0xffD7D7D7),
              fontFamily: 'Roboto'),
        ),
        Expanded(
          child: Divider(
            endIndent: UIHelper.getDeviceWith(context) * 0.3,
            indent: UIHelper.getDeviceWith(context) * 0.03,
            thickness: 2,
            color: const Color(0xffD7D7D7),
          ),
        )
      ],
    );
  }
}
