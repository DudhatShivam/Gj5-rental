import 'dart:convert';
import 'dart:io' show Platform, SocketException, exit;
import 'dart:math' as math;

import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../screen/Order_line/orderline_constant/order_line_card.dart';

ExitDialog(BuildContext context) {
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
                        height: getHeight(0.17, context),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withOpacity(0.5), width: 2),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      Transform.rotate(
                        angle: -math.pi / 30,
                        child: Container(
                          alignment: Alignment.center,
                          height: getHeight(0.17, context),
                          decoration: BoxDecoration(
                              color: Colors.red.shade300,
                              borderRadius: BorderRadius.circular(20)),
                          child: Transform.rotate(
                            angle: -math.pi / -30,
                            child: Container(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    "Sure , Are you want to exit ?",
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: getHeight(0.015, context),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        if (Platform.isAndroid) {
                                          SystemNavigator.pop();
                                        } else if (Platform.isIOS) {
                                          exit(0);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        height: getHeight(0.05, context),
                                        width: getWidth(0.2, context),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Ok",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          height: getHeight(0.05, context),
                                          width: getWidth(0.2, context),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
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

Future<DateTime?> pickedDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030));
  return picked;
}

Future<DateTime?> picked7DateAbove(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 7)),
      lastDate: DateTime(2030));
  return picked;
}

void showInSnackBar(String value, BuildContext context) {
  Get.snackbar(
    'Error',
    value,
    colorText: Colors.white,
    duration: Duration(seconds: 3),
    backgroundColor: Colors.red.shade300,
    animationDuration: Duration(milliseconds: 800),
    snackPosition: SnackPosition.TOP,
  );
}

textFieldWidget(
    String hint,
    TextEditingController controller,
    bool isObscureText,
    bool isDense,
    Color color,
    TextInputType textInputType,
    double horizontalPadding,
    Color focusedBorderColor,
    int maxLine) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
    child: TextFormField(
      obscureText: isObscureText,
      maxLines: maxLine,
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter Value";
        }
      },
      keyboardType: textInputType,
      controller: controller,
      decoration: InputDecoration(
          suffixIcon: InkWell(
              onTap: () {
                controller.clear();
              },
              child: Icon(
                Icons.cancel,
                size: 25,
                color: Colors.grey.shade400,
              )),
          isDense: true,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          filled: true,
          fillColor: color,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: focusedBorderColor),
              borderRadius: BorderRadius.circular(10))),
    ),
  );
}

numberValidatorTextfield(
    TextEditingController textEditingController, String hint) {
  return TextFormField(
    validator: (value) {
      if (value == "") {
        return "Enter Value";
      } else if (value?.length != 10) {
        return "Enter 10 Digit Number";
      }
    },
    keyboardType: TextInputType.number,
    controller: textEditingController,
    decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        suffixIcon: InkWell(
            onTap: () {
              textEditingController.clear();
            },
            child: Icon(
              Icons.cancel,
              size: 25,
              color: Colors.grey.shade400,
            )),
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary2Color),
            borderRadius: BorderRadius.circular(10))),
  );
}

productDeleteDialog(lineId, int index, List orderDetails, BuildContext context,
    bool isDeleteOrder) async {
  return await showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            height: getHeight(0.15, context),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sure , Are you want to delete product ?",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                ),
                Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel")),
                    SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          checkWififorDeleteProduct(lineId, index, orderDetails,
                                  context, isDeleteOrder)
                              .then((value) {
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Delete")),
                  ],
                )
              ],
            ),
          ),
        );
      });
}

Future<void> checkWififorDeleteProduct(lineId, int index, List orderDetails,
    BuildContext context, bool isDeleteOrder) async {
  getStringPreference('apiUrl').then((apiUrl) async {
    try {
      getStringPreference('accessToken').then((token) async {
        if (apiUrl.toString().startsWith("192")) {
          showConnectivity().then((result) async {
            if (result == ConnectivityResult.wifi) {
              deleteProductInQuotationAndOrder(
                  lineId, index, orderDetails, token, apiUrl, isDeleteOrder);
            } else {
              dialog(
                  context, "Connect to Showroom Network", Colors.red.shade300);
            }
          });
        } else {
          deleteProductInQuotationAndOrder(
              lineId, index, orderDetails, token, apiUrl, isDeleteOrder);
        }
      });
    } on SocketException catch (err) {
      dialog(context, "Connect to Showroom Network", Colors.red.shade300);
    }
  });
}

deleteProductInQuotationAndOrder(lineId, int index, List orderDetails,
    String token, String url, bool isDeleteOrder) async {
  String uri = "";
  isDeleteOrder == true
      ? uri = "http://$url/api/rental.rental/$lineId"
      : uri = "http://$url/api/rental.line/$lineId";
  final response =
      await http.delete(Uri.parse(uri), headers: {'Access-Token': token});
  if (response.statusCode == 200) {
    orderDetails.removeAt(index);
  }
}

Widget cartCard(List<dynamic> list, int index, String cartOwnerName,
    Color backgroundColor) {
  return Container(
    padding: EdgeInsets.all(15),
    margin: EdgeInsets.only(bottom: 10),
    width: double.infinity,
    decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: Color(0xffE6ECF2), width: 0.7),
        borderRadius: BorderRadius.all(Radius.circular(5))),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Customer : ", style: primaryStyle),
                SizedBox(
                  height: 5,
                ),
                Text(
                  list[index]['name'] ?? "",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Amount : ", style: primaryStyle),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "0.0",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text("Mobile no  : ", style: primaryStyle),
            Text(
              list[index]['number'],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: primaryColor.withOpacity(0.9)),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text("Sales person name : ", style: primaryStyle),
            Text(
              cartOwnerName,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: primaryColor.withOpacity(0.9)),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Address : ", style: primaryStyle),
            Expanded(
                child: Text(
              list[index]['address'],
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: primaryColor.withOpacity(0.9)),
            ))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          height: 0.5,
          color: Colors.grey.shade400,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "D. Date : ",
                  style: primaryStyle,
                ),
                Text(
                  list[index]['ddate'],
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.green),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "R. Date : ",
                  style: primaryStyle,
                ),
                Text(
                  list[index]['rdate'],
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.red),
                )
              ],
            )
          ],
        )
      ],
    ),
  );
}

bookingStatusResponseCard(List<dynamic> responseOfApi, int index) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    padding: EdgeInsets.all(15),
    width: double.infinity,
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xffE6ECF2), width: 0.7),
        borderRadius: BorderRadius.all(Radius.circular(5))),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Text("Bill No : ", style: allCardMainText),
                  Text(
                    responseOfApi[index]['bill_no'],
                    style: allCardSubText,
                  )
                ],
              ),
            ),
            Text(
              responseOfApi[index]['status'],
              style: allCardMainText,
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Text(
              "Name : ",
              style: primaryStyle,
            ),
            Text(
              responseOfApi[index]['customer_name'],
              style: primaryStyle,
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text("D. Date : ", style: primaryStyle),
                  Text(
                    responseOfApi[index]['delivery_date'],
                    style: deliveryDateStyle,
                  )
                ],
              ),
              Row(
                children: [
                  Text("  R. Date : ", style: primaryStyle),
                  Text(
                    responseOfApi[index]['return_date'],
                    style: returnDateStyle,
                  )
                ],
              )
            ],
          ),
        )
      ],
    ),
  );
}

remarkContainer(
    BuildContext context,
    TextEditingController textEditingController,
    double size,
    double horizontalMargin,
    MainAxisAlignment mainAxisAlignment) {
  return Container(
    margin:
        EdgeInsets.symmetric(horizontal: getWidth(horizontalMargin, context)),
    child: Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Text(
          "Remark : ",
          style: primaryStyle,
        ),
        Container(
          width: getWidth(size, context),
          child: textFieldWidget(
              "Remark",
              textEditingController,
              false,
              false,
              Colors.grey.withOpacity(0.1),
              TextInputType.text,
              0,
              Colors.greenAccent,
              1),
        )
      ],
    ),
  );
}

//orderScreen

Future<void> getOrderScreenProductDetailData(
    String apiUrl, String token, int? id) async {
  MyGetxController myGetxController = Get.find();

  Map data = {};
  final response = await http.get(
      Uri.parse("http://$apiUrl/api/rental.rental/$id"),
      headers: {'Access-Token': token, 'Content-Type': 'application/http'});
  myGetxController.particularOrderData.clear();
  myGetxController.orderLineList.clear();
  data = jsonDecode(response.body);
  myGetxController.particularOrderData.add(data);
  myGetxController.orderLineList.addAll(data['line_ids']);
  checkForOrderScreenProductDetail();
}

void checkForOrderScreenProductDetail() {
  MyGetxController myGetxController = Get.find();

  myGetxController.orderLineProductList.clear();
  myGetxController.orderLineList.forEach((element) {
    if (element['product_details_ids'] != []) {
      List<dynamic> data = element['product_details_ids'];
      data.forEach((value) {
        if (value['product_id']['default_code'] != null) {
          myGetxController.orderLineProductList.add(value);
        }
      });
    }
  });
}

Future<void> checkWlanForDataOrderDetailScreen(
    BuildContext context, int id) async {
  getStringPreference('apiUrl').then((apiUrl) async {
    try {
      getStringPreference('accessToken').then((token) async {
        if (apiUrl.toString().startsWith("192")) {
          showConnectivity().then((result) async {
            if (result == ConnectivityResult.wifi) {
              getOrderScreenProductDetailData(apiUrl, token, id);
            } else {
              dialog(
                  context, "Connect to Showroom Network", Colors.red.shade300);
            }
          });
        } else {
          getOrderScreenProductDetailData(apiUrl, token, id);
        }
      });
    } on SocketException catch (err) {
      dialog(context, "Connect to Showroom Network", Colors.red.shade300);
    }
  });
}

checkWlanForConfirmOrderThumbAndWaiting(
    int orderId,
    int productDetailId,
    BuildContext context,
    bool isIconThumb,
    String dropDownValue,
    String reason,
    String productCode,
    String productName,
    bool isOrderLineScreen,
    int index,
    bool isShowFromGroupBy,
    int groupByMainListIndex) {
  getStringPreference('apiUrl').then((apiUrl) async {
    try {
      getStringPreference('accessToken').then((token) async {
        if (apiUrl.toString().startsWith("192")) {
          showConnectivity().then((result) async {
            if (result == ConnectivityResult.wifi) {
              isIconThumb == true
                  ? orderReadyConfirmationDialog(
                      context,
                      productCode,
                      productName,
                      orderId,
                      productDetailId,
                      apiUrl,
                      token,
                      isOrderLineScreen,
                      index,
                      isShowFromGroupBy,
                      groupByMainListIndex)
                  : submitReasonForWaiting(
                      orderId,
                      productDetailId,
                      apiUrl,
                      token,
                      context,
                      dropDownValue,
                      reason,
                      isOrderLineScreen,
                      index,
                      isShowFromGroupBy,
                      groupByMainListIndex);
            } else {
              dialog(
                  context, "Connect to Showroom Network", Colors.red.shade300);
            }
          });
        } else {
          isIconThumb == true
              ? orderReadyConfirmationDialog(
                  context,
                  productCode,
                  productName,
                  orderId,
                  productDetailId,
                  apiUrl,
                  token,
                  isOrderLineScreen,
                  index,
                  isShowFromGroupBy,
                  groupByMainListIndex)
              : submitReasonForWaiting(
                  orderId,
                  productDetailId,
                  apiUrl,
                  token,
                  context,
                  dropDownValue,
                  reason,
                  isOrderLineScreen,
                  index,
                  isShowFromGroupBy,
                  groupByMainListIndex);
        }
      });
    } on SocketException catch (err) {
      dialog(context, "Connect to Showroom Network", Colors.red.shade300);
    }
  });
}

confirmOrderThumb(
    int orderId,
    int productDetailId,
    String apiUrl,
    String token,
    BuildContext context,
    bool isOrderLineScreen,
    int index,
    bool isShowFromGroupBy,
    int groupByMainListIndex) async {
  final response = await http.put(
      Uri.parse(
          "http://$apiUrl/api/rental.line/$productDetailId/btn_ready_api"),
      headers: {
        'Access-Token': token,
      });
  if (response.statusCode == 200) {
    Navigator.pop(context);
    isOrderLineScreen == true
        ? isShowFromGroupBy == true
            ? setDataOfUpdatedIdInGroupByListOrderLineScreen(
                productDetailId, index, groupByMainListIndex)
            : setDataOfUpdatedIdInOrderLineScreen(productDetailId, index)
        : checkWlanForDataOrderDetailScreen(context, orderId);
  } else {
    dialog(context, "Something Went Wrong !", Colors.red.shade300);
  }
}

popUpForWaitingThumbInOrderScreen(
    BuildContext context,
    int productDetailId,
    int orderId,
    String productCode,
    String productName,
    bool isOrderLineScreen,
    index,
    bool isShowFromGroupBy,
    int groupByMainListIndex) {
  MyGetxController myGetxController = Get.find();

  TextEditingController reasonController = TextEditingController(
      text: myGetxController.waitingThumbPopUpSelectedValue.value);
  return showDialog(
      context: context,
      builder: (_) {
        return Obx(() => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Select Reason",
                        style: dialogTitleStyle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Select :    ",
                            style: primaryStyle,
                          ),
                          Expanded(
                              child: Container(
                            color: Colors.grey.withOpacity(0.1),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                items: <String>[
                                  'Return',
                                  'Concept',
                                  'Repairing',
                                  'Gotvu'
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(value),
                                    ),
                                  );
                                }).toList(),
                                value: myGetxController
                                    .waitingThumbPopUpSelectedValue.value,
                                onChanged: (val) {
                                  reasonController.text = val ?? "";
                                  myGetxController
                                      .waitingThumbPopUpSelectedValue
                                      .value = val ?? "";
                                },
                                hint: Text("Select"),
                              ),
                            ),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "Reason :  ",
                            style: primaryStyle,
                          ),
                          Expanded(
                              child: textFieldWidget(
                                  "Reason",
                                  reasonController,
                                  false,
                                  false,
                                  Colors.grey.withOpacity(0.1),
                                  TextInputType.text,
                                  0,
                                  Colors.greenAccent,
                                  1))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade300),
                          onPressed: () {
                            checkWlanForConfirmOrderThumbAndWaiting(
                                orderId,
                                productDetailId,
                                context,
                                false,
                                myGetxController
                                    .waitingThumbPopUpSelectedValue.value,
                                reasonController.text,
                                productCode,
                                productName,
                                true,
                                index,
                                isShowFromGroupBy,
                                groupByMainListIndex);
                          },
                          child: Text("Submit"))
                    ],
                  ),
                ),
              ),
            ));
      });
}

submitReasonForWaiting(
    int orderId,
    int productDetailId,
    String apiUrl,
    String token,
    BuildContext context,
    String dropDownValue,
    String reason,
    bool isOrderLineScreen,
    index,
    bool isShowFromGroupBy,
    int groupByMainListIndex) async {
  final response = await http.put(
      Uri.parse(
          "http://$apiUrl/api/rental.line/$productDetailId/btn_waiting_api?reason=$dropDownValue&waiting_reason=$reason"),
      headers: {
        'Access-Token': token,
      });
  if (response.statusCode == 200) {

    isOrderLineScreen == true
        ? isShowFromGroupBy == true
            ? setDataOfUpdatedIdInGroupByListOrderLineScreen(
                productDetailId, index, groupByMainListIndex)
            : setDataOfUpdatedIdInOrderLineScreen(productDetailId, index)
        : checkWlanForDataOrderDetailScreen(context, orderId);
    Navigator.pop(context);
  } else {
    FocusScope.of(context).unfocus();
    dialog(context, "Something Went Wrong !", Colors.red.shade300);
  }
}

get5daysBeforeDate() {
  DateTime dateTime = DateTime.now().subtract(Duration(days: 5));
  return DateFormat('dd/MM/yyyy').format(dateTime);
}

get7DaysAfterDate() {
  DateTime dateTime2 = DateTime.now().add(Duration(days: 7));
  return DateFormat('dd/MM/yyyy').format(dateTime2);
}

orderDetailContainer() {
  return Padding(
    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
    child: FadeInLeft(
      child: Text(
        "Order Details : ",
        style: pageTitleTextStyle,
      ),
    ),
  );
}

drawerFilterContainer(String texts, BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: 10, vertical: getHeight(0.011, context)),
    child: Text(
      texts,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

allScreenInitialSizedBox(BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).padding.top + 10,
  );
}

Color statusBackGroundColor(List list, int index) {
  Color color;
  list[index]['state'] == 'done' || list[index]['state'] == 'cancel'
      ? color = mutedColor.withOpacity(0.08)
      : list[index]['state'] == 'confirm'
          ? color = infoColor.withOpacity(0.08)
          : list[index]['state'] == 'return' ||
                  list[index]['state'] == 'pending'
              ? color = dangerColor.withOpacity(0.08)
              : list[index]['state'] == 'ready'
                  ? color = successColor.withOpacity(0.15)
                  : color = defaultColor.withOpacity(0.08);
  return color;
}

Color statusColor(List list, int index) {
  Color color;
  list[index]['state'] == 'done' || list[index]['state'] == 'cancel'
      ? color = mutedColor
      : list[index]['state'] == 'confirm'
          ? color = infoColor
          : list[index]['state'] == 'return' ||
                  list[index]['state'] == 'pending'
              ? color = dangerColor
              : list[index]['state'] == 'ready'
                  ? color = successColor
                  : color = defaultColor;
  return color;
}
