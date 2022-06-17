import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../constant/constant.dart';

getHeight(double height, BuildContext context) {
  return MediaQuery.of(context).size.height * height;
}

getWidth(double width, BuildContext context) {
  return MediaQuery.of(context).size.height * width;
}

Color primaryColor = Color(0xff0F052D);

Color newStatusColor = Color(0xff2F8DFA);
Color confirmStatusColor = Color(0xff8B572A);
Color waitingStatusColor = Color(0xffA9DACC);
Color readyToDeliveryStatusColor = Color(0xffEB648B);
Color partiallyDeliverStatusColor = Color(0xffF8C753);
Color DeliverStatusColor = Color(0xffFEB7E30);
Color partiallyReceivedStatusColor = Color(0xffFEB7E30);
Color doneStatusColor = Colors.green;
Color cancelledStatusColor = Color(0xffD5001A);

pushMethod(BuildContext context, Widget name) {
  // Navigator.of(context).push(SwipeablePageRoute(
  //   canOnlySwipeFromEdge: true,
  //   builder: (BuildContext context) => name,
  // ));
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => name));
}

pushRemoveUntilMethod(BuildContext context, Widget name) {
  Navigator.of(context).pushAndRemoveUntil(
      SwipeablePageRoute(builder: (context) => name),
      (Route<dynamic> route) => false);
}

TextStyle primaryStyle = TextStyle(
    fontSize: 17,
    color: primaryColor.withOpacity(0.6),
    fontWeight: FontWeight.w500);
TextStyle drawerTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.blueGrey,
  fontWeight: FontWeight.w500,
);

Future showConnectivity() async {
  final results = await Connectivity().checkConnectivity();
  return results;
}

Future dialog(BuildContext context, String text) {
  return showGeneralDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
            opacity: a1.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(25),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withOpacity(0.5), width: 2),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              text,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.transparent),
                            ),
                          ],
                        ),
                      ),
                      Transform.rotate(
                        angle: -math.pi / 50,
                        child: Container(
                          padding: EdgeInsets.all(25),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red.shade300,
                              borderRadius: BorderRadius.circular(20)),
                          child: Transform.rotate(
                            angle: -math.pi / -50,
                            child: Container(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  text,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
      );
    },
    transitionDuration: Duration(milliseconds: 300),
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return Text("");
    },
  );
}

Future orderDetailDialog(
    BuildContext context, String code, String name, String? remark) {
  return showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          alignment: Alignment.center,
          child: Container(
            height: getHeight(0.14, context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  code,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: primaryColor),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  name,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: primaryColor),
                ),
                remark == ""
                    ? FittedBox(
                        child: Text(
                          remark ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: primaryColor),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        );
      });
}

Future orderReadyConfirmationDialog(
    BuildContext context,
    String code,
    String name,
    int orderId,
    int productDetailId,
    String apiUrl,
    String token) {
  print("confirmation dialog called");
  return showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sure , are you want to confirm ?",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.blue),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  code,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: primaryColor),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  name,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: primaryColor),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          confirmOrderThumb(
                              orderId, productDetailId, apiUrl, token, context);
                        },
                        child: Text("Ok")),
                    SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel")),
                  ],
                )
              ],
            ),
          ),
        );
      });
}

Future deliverScreenOrderLineSelectionDialog(
    BuildContext context, int orderId) {
  MyGetxController myGetxController = Get.find();
  return showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Do you also want to add subProduct?",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.blue),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (myGetxController.selectedOrderLineList
                                  .contains(orderId) ==
                              false) {
                            myGetxController.selectedOrderLineList.add(orderId);
                          }
                          print(myGetxController.selectedOrderLineList);
                        },
                        child: Text("Ok")),
                    SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel")),
                  ],
                )
              ],
            ),
          ),
        );
      });
}

Future<void> setLogInData(String apiUrl, String accessToken, String uid,
    String partnerId, String name, String image, String branchName,String pastDayOrder,String nextDayOder) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('apiUrl', apiUrl);
  preferences.setString('branchName', branchName);
  preferences.setString('accessToken', accessToken);
  preferences.setString('uid', uid);
  preferences.setString('partnerId', partnerId);
  preferences.setString('name', name);
  preferences.setString('image', image).whenComplete(() => print("image set"));
  preferences.setString('pastDayOrder', pastDayOrder);
  preferences.setString('nextDayOder', nextDayOder);
}

Future<void> removePreference() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.remove('apiUrl');
  preferences.remove('branchName');
  preferences.remove('ProductList');
  preferences.remove('accessToken');
  preferences.remove('uid');
  preferences.remove('partnerId');
  preferences.remove('name');
  preferences.remove('image');
  preferences.remove('pastDayOrder');
  preferences.remove('nextDayOder');
  preferences.remove('LogIN');
  preferences.remove('cartList');
}

Future getStringPreference(String pref) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString(pref);
}

Future setLogIn(bool isLogIN) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool('LogIN', isLogIN).whenComplete(() => print("LogInSet"));
}

Future getLogIn() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool('LogIN');
}
