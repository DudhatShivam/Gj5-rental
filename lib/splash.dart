import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gj5_rental/login/login_page.dart';
import 'package:gj5_rental/screen/Order_line/notification_orderline.dart';
import 'package:gj5_rental/screen/cancel_order/cancel_order_detail.dart';
import 'package:gj5_rental/screen/delivery/delivery_detail.dart';
import 'package:gj5_rental/screen/order/order_detail.dart';
import 'package:gj5_rental/screen/receive/receive_detail.dart';
import 'package:gj5_rental/screen/service_line/notification_show_serviceline.dart';

import 'Utils/utils.dart';
import 'home/home.dart';
import 'main.dart';
import 'notification/manage_notification.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;
  int seconds = 60;

  var init = InitializationSettings(android: androidInit, iOS: iosInit);
  FCM firebaseMessaging = FCM();

  void initState() {
    // TODO: implement initState
    super.initState();
    flutterLocalNotificationsPlugin.initialize(init,
        onSelectNotification: notificationClick);
    Timer(Duration(seconds: 2), () {
      getLogIn().then((value) {
        if (value == true) {
          pushFunction();
        } else {
          pushMethod(context, LogInPage());
        }
      });
    });
    firebaseMessaging.setNotifications(context);
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Column(
            children: [
              Expanded(
                  child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                  Image.asset(
                    "assets/images/gj5_logo.png",
                    height: getHeight(0.3, context),
                    width: getHeight(0.3, context),
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.17,
                  ),
                  Text(
                    "Welcome to GJ-5 ",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                        letterSpacing: 2,
                        color: Color(0xff9A2929)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: Color(0xff9A2929),
                      )),
                ],
              )),
              Text(
                "Powered by Laxicon Solution",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    letterSpacing: 0.5,
                    color: Colors.grey.shade500),
              ),
              Text(
                "www.laxicon.in",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    letterSpacing: 0.5,
                    color: Colors.grey.shade700),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> notificationClick(payload) async {
    final aString = payload.substring(11, payload.length - 1);
    final parts = aString.split(', ');
    final keyword = parts[0];
    final orderId = parts[1].substring(
      10,
    );
    notificationClickNavigation(keyword, orderId);
  }

  void pushFunction() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      RemoteNotification? notification = message?.notification;
      AndroidNotification? android = message?.notification?.android;
      if (notification != null && android != null) {
        notificationClick(message?.data.toString());
      } else {
        pushRemoveUntilMethod(
            context,
            HomeScreen(
              userId: 0,
            ));
      }
    });
  }
}

notificationClickNavigation(keyword, orderId) {
  if (keyword == "confirm_order") {
    navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) => OrderDetail(
            idFromAnotherScreen: true, id: int.parse(orderId.toString()))));
  } else if (keyword == "deliver_order") {
    navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) => DeliveryDetailScreen(
            isFromAnotherScreen: true, id: int.parse(orderId.toString()))));
  } else if (keyword == "receive_order") {
    navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) => ReceiveDetail(
            isFromAnotherScreen: true,
            orderId: int.parse(orderId.toString()))));
  } else if (keyword == "cancel_order") {
    navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) => CancelOrderDetailScreen(
            isFromAnotherScreen: true,
            orderId: int.parse(orderId.toString()))));
  } else if (keyword == "service_order") {
    navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) =>
            NotificationServiceLine(id: int.parse(orderId.toString()))));
  } else if (keyword == "order_line") {
    navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) =>
            NotificationOrderLine(id: int.parse(orderId.toString()))));
  }
}
