import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:gj5_rental/notification/notification_database.dart';
import 'package:gj5_rental/splash.dart';
import 'package:intl/intl.dart';

import 'drawer_pages/change_theme_screen.dart';
import 'notification/notification_model.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    playSound: true);
var androidInit = AndroidInitializationSettings("@mipmap/ic_launcher");
var iosInit = IOSInitializationSettings();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message.notification != null) {
    setNotification(message);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(GetMaterialApp(
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));
}

setNotification(RemoteMessage message) {
  final aString =
      message.data.toString().substring(11, message.data.toString().length - 1);
  final parts = aString.split(', ');
  final keyword = parts[0];
  final orderId = parts[1].substring(
    10,
  );
  String date = DateFormat("dd/MM/yyyy").format(DateTime.now());
  NotificationDatabase notificationDatabase = NotificationDatabase();
  notificationDatabase.dbInsert(NotificationModel(
      title: message.notification?.title,
      body: message.notification?.body,
      date: date,
      keyword: keyword,
      orderId: orderId.toString()));
}
