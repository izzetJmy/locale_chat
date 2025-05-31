import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> initialize() async {
    print('NotificationService: initialize başladı');

    // Check if we've already requested notification permissions
    final prefs = await SharedPreferences.getInstance();
    final hasRequestedNotificationPermission =
        prefs.getBool('hasRequestedNotificationPermission') ?? false;

    if (!hasRequestedNotificationPermission) {
      // FCM izinlerini iste
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Save that we've requested permission
      await prefs.setBool('hasRequestedNotificationPermission', true);

      print(
          'NotificationService: FCM izinleri durumu: ${settings.authorizationStatus}');
    }

    // Yerel bildirim ayarlarını yapılandır
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('NotificationService: Bildirime tıklandı: ${response.payload}');
      },
    );

    // FCM token'ı al ve Firestore'a kaydet
    String? token = await _firebaseMessaging.getToken();
    print('NotificationService: FCM Token alındı: $token');

    if (token != null && _auth.currentUser != null) {
      print('NotificationService: Token Firestore\'a kaydediliyor...');
      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .update({'token': token});
      print('NotificationService: Token başarıyla kaydedildi');
    }

    // Token yenilendiğinde güncelle
    _firebaseMessaging.onTokenRefresh.listen((String token) async {
      print('NotificationService: FCM Token yenilendi: $token');
      if (_auth.currentUser != null) {
        await _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .update({'token': token});
        print('NotificationService: Yeni token Firestore\'a kaydedildi');
      }
    });

    // Ön planda bildirim gösterme
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('NotificationService: Ön planda bildirim alındı:');
      print('NotificationService: Başlık: ${message.notification?.title}');
      print('NotificationService: İçerik: ${message.notification?.body}');
      print('NotificationService: Veri: ${message.data}');
      _showNotification(message);
    });

    // Arka planda bildirim geldiğinde
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    print('NotificationService: initialize tamamlandı');
  }

  // Sohbet topic'ine abone ol
  Future<void> subscribeToChat(String chatId) async {
    print('NotificationService: Sohbete abone olunuyor: chat_$chatId');
    await _firebaseMessaging.subscribeToTopic('chat_$chatId');
    print('NotificationService: Sohbete başarıyla abone olundu');
  }

  // Grup topic'ine abone ol
  Future<void> subscribeToGroup(String groupId) async {
    print('NotificationService: Gruba abone olunuyor: group_$groupId');
    await _firebaseMessaging.subscribeToTopic('group_$groupId');
    print('NotificationService: Gruba başarıyla abone olundu');
  }

  // Topic'ten çık
  Future<void> unsubscribeFromTopic(String topic) async {
    print('NotificationService: Topic\'ten çıkılıyor: $topic');
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print('NotificationService: Topic\'ten başarıyla çıkıldı');
  }

  // Yerel bildirim göster
  Future<void> _showNotification(RemoteMessage message) async {
    print('NotificationService: Yerel bildirim gösteriliyor');
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      print('NotificationService: Bildirim detayları:');
      print('NotificationService: Başlık: ${notification.title}');
      print('NotificationService: İçerik: ${notification.body}');

      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'Yüksek Öncelikli Bildirimler',
            channelDescription: 'Bu kanal önemli bildirimler için kullanılır',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
      print('NotificationService: Yerel bildirim başarıyla gösterildi');
    }
  }
}

// Arka plan mesaj işleyici
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('NotificationService: Arka planda mesaj alındı:');
  print('NotificationService: Mesaj ID: ${message.messageId}');
  print('NotificationService: Başlık: ${message.notification?.title}');
  print('NotificationService: İçerik: ${message.notification?.body}');
  print('NotificationService: Veri: ${message.data}');
}
