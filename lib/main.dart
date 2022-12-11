import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cron/cron.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/notification/notification_database.dart';
import 'package:gj5_rental/splash.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'constant/constant.dart';
import 'login/login_page.dart';
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
  print(message.notification?.title);
  print(message.notification?.body);
  if (message.notification != null) {
    setNotification(message);
  }
}

void main() async {
  final cron = Cron();
  cron.schedule(Schedule.parse('*/59 * * * *'), () async {
    chekForWlan();
  });
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

Future<void> chekForWlan() async {
  showConnectivity().then((result) async {
    if (result == ConnectivityResult.wifi) {
      getStringPreference('apiUrl').then((serverUrl) async {
        String dbListUrl = "http://$serverUrl/api/dblist";
        final DbListResponse = await http.get(Uri.parse(dbListUrl));
        if (DbListResponse.statusCode == 200) {
          chekLogIn(serverUrl);
        }
      });
    }
  });
}

void chekLogIn(String serverUrl) {
  MyGetxController myGetxController = Get.find();
  getStringPreference('userName').then((userName) {
    getStringPreference('password').then((password) {
      getStringPreference('databaseName').then((dbName) async {
        final response = await http.post(
            Uri.parse("http://$serverUrl/api/auth/get_tokens"),
            headers: <String, String>{
              'Content-Type': 'application/http; charset=UTF-8',
            },
            body: jsonEncode({
              'db': dbName,
              'username': userName.trim(),
              'password': password.trim()
            }));
        var data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString('accessToken', data['access_token']);
        } else {
          setLogIn(false);
          removePreference();
          myGetxController.logInPageError.value = "";
          Get.deleteAll();
          Get.offAll(LogInPage());
        }
      });
    });
  });
}

setNotification(RemoteMessage message) {
  final aString =
      message.data.toString().substring(11, message.data.toString().length - 1);
  final parts = aString.split(', ');
  final keyword = parts[0];
  final orderId = parts[1].substring(
    10,
  );
  String date = DateFormat(passApiGlobalDateFormat).format(DateTime.now());
  NotificationDatabase notificationDatabase = NotificationDatabase();
  notificationDatabase.dbInsert(NotificationModel(
      title: message.notification?.title,
      body: message.notification?.body,
      date: date,
      keyword: keyword,
      orderId: orderId.toString()));
}
