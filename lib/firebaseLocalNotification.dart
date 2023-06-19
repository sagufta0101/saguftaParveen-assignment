import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vivatech/main.dart';

class FirebaseNotification {
  static final FirebaseNotification _singleton =
      FirebaseNotification._internal();
  FirebaseNotification._internal();
  factory FirebaseNotification() {
    return _singleton;
  }
  FirebaseMessaging? _firebaseMessaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> showNotification(String title, String message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      platformChannelSpecifics,
      payload: 'notification',
    );
  }

  void setUpFirebase(onDidReceiveLocalNotification) {
    tz.initializeTimeZones();
    _firebaseMessaging = FirebaseMessaging.instance;
    firebaseCloudMessagingListeners();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    _register();
  }

  _register() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        !kIsWeb && Platform.isLinux
            ? null
            : await flutterLocalNotificationsPlugin
                .getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      print("Going to Launch the APP");
      print(notificationAppLaunchDetails?.payload ?? '');
    }
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging?.getToken();
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging!.getToken().then((token) async {
      if (token != null) _uploadToken(token);
    });

    _firebaseMessaging?.onTokenRefresh.listen((token) async {
      _uploadToken(token);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      displayNotification(message);
    });
  }

  _uploadToken(String token) async {}

  get androidNotificationDetails => AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        playSound: true,
        icon: "@mipmap/ic_launcher",
        channelShowBadge: true,
        enableLights: true,
        importance: Importance.max,
        usesChronometer: false,
      );

  Future displayNotification(RemoteMessage message) async {
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSPlatformChannelSpecifics,
    );

    RemoteNotification notification = message.notification!;

    await flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: notification.body,
    );
  }

  void iOSPermission() {}

  Future<void> clearAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      // Navigator.pushNamed(_context!, WASplashScreen.tag);
    }
  }
}
