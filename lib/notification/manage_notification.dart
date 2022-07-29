
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
        navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (_) => OrderDetail(
                  id: int.parse(message.notification  ?.title ?? ""),
                  idFromAnotherScreen: false,
                )));
      },
    );
  }
}
