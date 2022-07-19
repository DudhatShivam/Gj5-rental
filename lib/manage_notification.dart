// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:gj5_rental/Utils/utils.dart';
//
// import '../main.dart';
// import 'counter2.dart';
//
// class Counter extends StatefulWidget {
//   const Counter({Key? key}) : super(key: key);
//
//   @override
//   State<Counter> createState() => _CounterState();
// }
//
// class _CounterState extends State<Counter> {
//   int counter = 0;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     var init = InitializationSettings(android: androidInit, iOS: iosInit);
//     flutterLocalNotificationsPlugin.initialize(init,
//         onSelectNotification: select);
//
//     // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     //   RemoteNotification? notification = message.notification;
//     //   AndroidNotification? androidNotification = message.notification?.android;
//     //   if (notification != null && androidNotification != null) {
//     //     flutterLocalNotificationsPlugin.show(
//     //         notification.hashCode,
//     //         notification.title,
//     //         notification.body,
//     //         NotificationDetails(
//     //             android: AndroidNotificationDetails(channel.id, channel.name,
//     //                 channelDescription: channel.description,
//     //                 color: Colors.blue,
//     //                 playSound: true,
//     //                 icon: '@mipmap/launcher_icon')));
//     //   }
//     // });
//     // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     //   RemoteNotification? notification = message.notification;
//     //   AndroidNotification? androidNotification = message.notification?.android;
//     //   if (notification != null && androidNotification != null) {
//     //     setState(() {
//     //       showDialog(
//     //           context: context,
//     //           builder: (_) {
//     //             return AlertDialog(
//     //               title: Text(notification.title.toString()),
//     //               content: SingleChildScrollView(
//     //                 child: Column(
//     //                   crossAxisAlignment: CrossAxisAlignment.start,
//     //                   children: [Text(notification.body.toString())],
//     //                 ),
//     //               ),
//     //             );
//     //           });
//     //     });
//     //   }
//     // });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             setState(() {
//               counter++;
//             });
//             showNotification();
//           },
//           child: Text("Increment"),
//         ),
//       ),
//     );
//   }
//
//   void showNotification() async {
//     try {
//       flutterLocalNotificationsPlugin.show(
//           0,
//           "Hello",
//           "Testing Purpose value ${counter}",
//           payload: "$counter",
//           NotificationDetails(
//               android: AndroidNotificationDetails(channel.id, channel.name,
//                   channelDescription: channel.description,
//                   color: Colors.blue,
//                   playSound: true,
//                   icon: '@mipmap/ic_launcher')));
//     } catch (e) {
//       print("Try error${e}");
//     }
//   }
//
//   Future<void> select(payload) async {
//     showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               content: Text("Notification clicked ${payload}"),
//             ));
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:gj5_rental/screen/order/order_detail.dart';
import 'main.dart';

class FCM {
  setNotifications(BuildContext context) {
    forgroundNotification(context);
    backgroundNotification(context);
  }

  forgroundNotification(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification?.android;
      if (notification != null && androidNotification != null) {
        await flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            payload: message.data.toString(),
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    color: Colors.blue,
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));
      }
    });
  }

  backgroundNotification(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) async {
        await Firebase.initializeApp();
        print(message.notification?.title);
        print(message.notification?.body);
        navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (_) => OrderDetail(
                  id: int.parse(message.notification  ?.title ?? ""),
                  idFromAnotherScreen: false,
                )));
      },
    );
  }
}
