import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotifService {
  FirebaseMessaging? _messaging;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  initFirebase() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    NotificationSettings? settings = await _messaging?.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if (settings?.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (Platform.isAndroid) _showNotification(message);
        // notifier.value = true;
      });
    } else {
      initFirebase();
    }
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();
    _flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings),
    );
  }

  void _showNotification(RemoteMessage message) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails('Takk', 'Takk channel',
        playSound: true, importance: Importance.max, priority: Priority.max);
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(presentSound: true);
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      1,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
    );
  }

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    if (Platform.isAndroid) _showNotification(message);
  }
}
