import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../provider/notification_change_notifier/notification_change_notifier.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirimler'),
        actions: [
          Consumer<NotificationChangeNotifier>(
            builder: (context, notifier, child) {
              return IconButton(
                icon: Icon(
                  notifier.isNotificationEnabled
                      ? Icons.notifications_active
                      : Icons.notifications_off,
                ),
                onPressed: () => notifier.toggleNotifications(),
              );
            },
          ),
        ],
      ),
      body: Consumer<NotificationChangeNotifier>(
        builder: (context, notifier, child) {
          if (notifier.notificationHistory.isEmpty) {
            return const Center(
              child: Text('Henüz bildirim yok'),
            );
          }

          return ListView.builder(
            itemCount: notifier.notificationHistory.length,
            itemBuilder: (context, index) {
              final message = notifier.notificationHistory[index];
              final notification = message.notification;

              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.notifications),
                ),
                title: Text(notification?.title ?? 'Bildirim'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification?.body ?? ''),
                    if (message.sentTime != null)
                      Text(
                        timeago.format(message.sentTime!, locale: 'tr'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Bildirimi sil
                    notifier.clearNotificationHistory();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
