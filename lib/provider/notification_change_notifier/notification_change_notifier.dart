import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationChangeNotifier extends ChangeNotifier {
  bool _isNotificationEnabled = true;
  String? _fcmToken;
  List<RemoteMessage> _notificationHistory = [];
  final _firebaseMessaging = FirebaseMessaging.instance;

  bool get isNotificationEnabled => _isNotificationEnabled;
  String? get fcmToken => _fcmToken;
  List<RemoteMessage> get notificationHistory => _notificationHistory;

  NotificationChangeNotifier() {
    _loadNotificationSettings();
    _initializeFCM();
    _setupMessageHandlers();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isNotificationEnabled = prefs.getBool('isNotificationEnabled') ?? true;
    notifyListeners();
  }

  Future<void> _initializeFCM() async {
    // Bildirim izinlerini iste
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // FCM token'ı al
    _fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token: $_fcmToken');

    // Arka planda bildirim gösterme izni
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    notifyListeners();
  }

  void _setupMessageHandlers() {
    // Uygulama ön plandayken gelen mesajlar için
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (_isNotificationEnabled) {
        _handleMessage(message);
      }
    });

    // Uygulama arka plandayken gelen mesajlar için
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (_isNotificationEnabled) {
        _handleMessage(message);
      }
    });

    // Uygulama kapalıyken gelen mesajlar için
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null && _isNotificationEnabled) {
        _handleMessage(message);
      }
    });
  }

  void _handleMessage(RemoteMessage message) {
    // Bildirimi geçmişe ekle
    addNotificationToHistory(message);

    // Bildirim içeriğini kontrol et
    if (message.notification != null) {
      print('Bildirim başlığı: ${message.notification?.title}');
      print('Bildirim içeriği: ${message.notification?.body}');
    }

    // Mesaj verilerini kontrol et
    if (message.data.isNotEmpty) {
      print('Mesaj verileri: ${message.data}');
    }
  }

  // Belirli bir sohbete abone ol
  Future<void> subscribeToChat(String chatId) async {
    await _firebaseMessaging.subscribeToTopic('chat_$chatId');
  }

  // Belirli bir gruba abone ol
  Future<void> subscribeToGroup(String groupId) async {
    await _firebaseMessaging.subscribeToTopic('group_$groupId');
  }

  // Sohbetten aboneliği kaldır
  Future<void> unsubscribeFromChat(String chatId) async {
    await _firebaseMessaging.unsubscribeFromTopic('chat_$chatId');
  }

  // Gruptan aboneliği kaldır
  Future<void> unsubscribeFromGroup(String groupId) async {
    await _firebaseMessaging.unsubscribeFromTopic('group_$groupId');
  }

  Future<void> toggleNotifications() async {
    _isNotificationEnabled = !_isNotificationEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotificationEnabled', _isNotificationEnabled);
    notifyListeners();
  }

  void addNotificationToHistory(RemoteMessage message) {
    _notificationHistory.insert(0, message);
    if (_notificationHistory.length > 50) {
      _notificationHistory.removeLast();
    }
    notifyListeners();
  }

  void clearNotificationHistory() {
    _notificationHistory.clear();
    notifyListeners();
  }

  Future<void> refreshFCMToken() async {
    _fcmToken = await _firebaseMessaging.getToken();
    notifyListeners();
  }
}
