import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_appbar.dart';
import 'package:locale_chat/comopnents/my_profile_card.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:provider/provider.dart';
import 'package:locale_chat/provider/notification_change_notifier/notification_change_notifier.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

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
        title: Text('Notifications', style: homePageTitleTextStyle),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: backgroundColor,
            ),
            onPressed: () {
              context
                  .read<NotificationChangeNotifier>()
                  .clearNotificationHistory();
            },
          ),
        ],
      ),
      body: Consumer<NotificationChangeNotifier>(
        builder: (context, notificationNotifier, child) {
          final notifications = notificationNotifier.notificationHistory;

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.bell_slash_fill,
                    size: 64,
                    color: backgroundColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: profileCardSubTittleTextStyle.copyWith(
                      color: backgroundColor.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 10, right: 10),
                  child: MyProfileCard(
                    leading: Icon(
                      CupertinoIcons.bell_fill,
                      color: backgroundColor,
                    ),
                    tittleText: Text(
                      notification.notification?.title ?? 'Notification',
                      style: profileCardSubTittleTextStyle,
                    ),
                    subtittleText: Text(
                      notification.notification?.body ?? '',
                      style: profileCardSubTittleTextStyle.copyWith(
                        fontSize: 14,
                        color: backgroundColor.withOpacity(0.7),
                      ),
                    ),
                    height: 80,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
