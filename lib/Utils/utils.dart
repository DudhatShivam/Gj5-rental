import 'dart:math' as math;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant/constant.dart';
import '../home/home.dart';
import '../main.dart';

getHeight(double height, BuildContext context) {
  return MediaQuery.of(context).size.height * height;
}

getWidth(double width, BuildContext context) {
  return MediaQuery.of(context).size.width * width;
}

bool isFromAnotherScreen = false;

Color primaryColor = Color(0xff0F052D);
Color primary2Color = Color(0xffAd2A30);

Color mainColor1 = Color(0xffFB578E);
Color mainColor2 = Color(0xffFEA78D);

Color infoColor = Color(0xff33b5e5);
Color successColor = Color(0xff00C851);
Color dangerColor = Color(0xffff4444);
Color mutedColor = Color(0xff6c757d);
Color defaultColor = Colors.black;
Color stitchingColor = Color(0xffDEA551);

int orderScreenOffset = 0;
int filterOrderScreenOffset = 0;
int deliverScreenOffset = 0;
int quotationOffset = 0;
int receiveScreenOffset = 0;
int serviceScreenOffset = 0;
int cancelOrderOffset = 0;
int productDetailOffset = 0;

makingPhoneCall(String PhoneNumber, BuildContext context) async {
  try {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: PhoneNumber,
    );
    await launchUrl(launchUri);
  } catch (e) {
    dialog(context, e.toString(), Colors.red.shade300);
  }
}

popFunction(BuildContext context, isFromAnotherScreen) async {
  if (isFromAnotherScreen) {
    pushRemoveUntilMethod(
        context,
        HomeScreen(
          userId: 0,
        ));
  } else {
    Navigator.of(context).pop();
  }
}

pushMethod(BuildContext context, Widget name) {
  // Navigator.of(context).push(SwipeablePageRoute(
  //   canOnlySwipeFromEdge: true,
  //   builder: (BuildContext context) => name,
  // ));
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => name));
}

navigatorKeyPushMethod(BuildContext context, Widget name) {
  navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => name));
}

pushRemoveUntilMethod(BuildContext context, Widget name) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => name),
      (Route<dynamic> route) => false);
}

TextStyle contactusTitleText = TextStyle(
    color: Color(0xff9C5789), fontWeight: FontWeight.w500, fontSize: 12);
TextStyle dialogTitleStyle =
    TextStyle(color: primary2Color, fontWeight: FontWeight.w500, fontSize: 24);

TextStyle primaryStyle = TextStyle(
    fontSize: 17,
    color: primaryColor.withOpacity(0.6),
    fontWeight: FontWeight.w500);
TextStyle drawerTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.blueGrey,
  fontWeight: FontWeight.w500,
);

TextStyle amountCardMainTextStyle = TextStyle(
    color: Colors.black.withOpacity(0.7),
    fontWeight: FontWeight.w500,
    fontSize: 17);
TextStyle amountCardSubTextStyle =
    TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 16);

TextStyle allCardMainText = TextStyle(
    fontSize: 17, fontWeight: FontWeight.w500, color: Colors.grey.shade600);
TextStyle allCardSubText =
    TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black);

TextStyle remarkTextStyle =
    TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: infoColor);

TextStyle deliveryDateStyle =
    TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.green);
TextStyle returnDateStyle =
    TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.red);

TextStyle pageTitleTextStyle =
    TextStyle(fontWeight: FontWeight.w500, fontSize: 22, color: primary2Color);

Icon searchIcon = Icon(
  Icons.search,
  size: 30,
  color: primary2Color,
);
Icon cancelIcon = Icon(
  Icons.cancel_outlined,
  size: 30,
  color: primary2Color,
);
Icon refreshIcon = Icon(Icons.refresh, size: 30, color: primary2Color);
Icon backArrowIcon = Icon(
  Icons.arrow_back,
  size: 30,
  color: primary2Color,
);
Icon calenderIcon = Icon(
  Icons.calendar_today,
  color: Colors.grey.shade400,
  size: 22,
);
Icon drawerMenuIcon = Icon(
  Icons.menu,
  size: 30,
  color: primary2Color,
);
Icon textFieldCancelIcon = Icon(
  Icons.cancel,
  size: 25,
  color: Colors.grey.shade400,
);

Future showConnectivity() async {
  final results = await Connectivity().checkConnectivity();
  return results;
}

Widget  CenterCircularProgressIndicator() {
  return Center(
    child: Container(
      height: 100,
      width: 100,
      child: LoadingIndicator(
        indicatorType: Indicator.pacman,
        colors: [primary2Color, mainColor1, mainColor2],
      ),
    ),
  );
}

showToast(String text) {
  return Fluttertoast.showToast(
    msg: text,
    backgroundColor: primary2Color,
    timeInSecForIosWeb: 2,
    fontSize: 17,
  );
}

Future dialog(BuildContext context, String text, Color color) {
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
                              color: color,
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
                remark != null
                    ? FittedBox(
                        child: Text(
                          remark,
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
    String token,
    bool isOrderLineScreen,
    int index,
    bool isShowFromGroupBy,
    int groupByMainListIndex) {
  return showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "This product is ready ?",
                  style: dialogTitleStyle,
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    code,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: primaryColor),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  name,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.grey.shade500),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green.shade300),
                        onPressed: () {
                          confirmOrderThumb(
                              orderId,
                              productDetailId,
                              apiUrl,
                              token,
                              context,
                              isOrderLineScreen,
                              index,
                              isShowFromGroupBy,
                              groupByMainListIndex);
                        },
                        child: Text("Yes")),
                    SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red.shade300),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
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

Future<void> setLogInData(
    String apiUrl,
    String userName,
    String password,
    String dbName,
    String accessToken,
    String uid,
    String partnerId,
    String name,
    String image,
    String branchName,
    String dateFormat,
    String pastDayOrder,
    String nextDayOder,
    bool ARUser,
    bool ARService,
    bool ARReceive,
    bool ARDeliver,
    bool ARChangeProduct,
    bool ARManager,
    bool ARCashbook) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('apiUrl', apiUrl);
  preferences.setString('branchName', branchName);
  preferences.setString('accessToken', accessToken);
  preferences.setString('uid', uid);
  preferences.setString('partnerId', partnerId);
  preferences.setString('name', name);
  preferences.setString('image', image);
  preferences.setString('pastDayOrder', pastDayOrder);
  preferences.setString('nextDayOder', nextDayOder);
  preferences.setBool('ARUser', ARUser);
  preferences.setBool('ARService', ARService);
  preferences.setBool('ARReceive', ARReceive);
  preferences.setBool('ARDeliver', ARDeliver);
  preferences.setBool('ARChangeProduct', ARChangeProduct);
  preferences.setBool('ARManager', ARManager);
  preferences.setBool("ARCashbook", ARCashbook);
  preferences.setString('userName', userName);
  preferences.setString('password', password);
  preferences.setString('databaseName', dbName);
  preferences.setString('dateFormat', dateFormat);
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
  preferences.remove('ARUser');
  preferences.remove('ARService');
  preferences.remove('ARReceive');
  preferences.remove('ARDeliver');
  preferences.remove('ARChangeProduct');
  preferences.remove('ARManager');
  preferences.remove('ARCashbook');
  preferences.remove('dateFormat');
}

Future getStringPreference(String pref) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString(pref);
}

Future getBoolPreference(String pref) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool(pref);
}

Future setLogIn(bool isLogIN) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool('LogIN', isLogIN);
}
