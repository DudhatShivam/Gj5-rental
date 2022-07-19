import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/quatation/quatation.dart';
import 'package:gj5_rental/splash.dart';
import 'manage_notification.dart';

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
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(GetMaterialApp(
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import 'manage_notification.dart';
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description: 'This channel is used for important notifications.',
//     importance: Importance.max,
//     playSound: true);
//
// void main() async {
//   await init();
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//   runApp(const MyApp());
// }
//
// Future init() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   String notificationTitle = 'No Title';
//   String notificationBody = 'No Body';
//   String notificationData = 'No Data';
//   int counter = 0;
//
//   @override
//   void initState() {
//     final firebaseMessaging = FCM();
//     firebaseMessaging.setNotifications();
//     firebaseMessaging.streamCtlr.stream.listen(_changeData);
//     firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
//     firebaseMessaging.titleCtlr.stream.listen(_changeTitle);
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? androidNotification = message.notification?.android;
//       if (notification != null && androidNotification != null) {
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//                 android: AndroidNotificationDetails(channel.id, channel.name,
//                     channelDescription: channel.description,
//                     color: Colors.blue,
//                     playSound: true,
//                     icon: '@mipmap/ic_launcher')));
//       }
//     });
//     super.initState();
//   }
//
//   _changeData(String msg) => setState(() => notificationData = msg);
//
//   _changeBody(String msg) => setState(() => notificationBody = msg);
//
//   _changeTitle(String msg) => setState(() => notificationTitle = msg);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Flutter Notification Details",
//               style: Theme.of(context).textTheme.headline4,
//             ),
//             const SizedBox(height: 20),
//             Text(
//               "Notification Title:-  $notificationTitle",
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             Text(
//               "Notification Body:-  $notificationBody",
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     counter++;
//                   });
//                   showNotification();
//                 },
//                 child: Text("Increment"))
//           ],
//         ),
//       ),
//     );
//   }
//
//   void showNotification() async {
//     flutterLocalNotificationsPlugin.show(
//         0,
//         "Hello",
//         "Local Notification value ${counter}",
//         NotificationDetails(
//             android: AndroidNotificationDetails(channel.id, channel.name,
//                 channelDescription: channel.description,
//                 color: Colors.blue,
//                 playSound: true,
//                 icon: '@mipmap/ic_launcher')));
//   }
// }
