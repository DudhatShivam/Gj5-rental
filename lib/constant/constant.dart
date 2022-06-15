import 'dart:convert';
import 'dart:io' show Platform, SocketException, exit;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/quatation/edit_order_line.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:gj5_rental/screen/quatation/quotation_detail.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../screen/order/order_detail.dart';
import '../screen/quatation/edit_order.dart';
import '../screen/quatation/quotation_const/quotation_constant.dart';

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
                                  onTap: () {
                                    print("sdsa");
                                  },
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
                                        print("syss");
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
                                        height: getHeight(0.045, context),
                                        width: getWidth(0.09, context),
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
                                          height: getHeight(0.045, context),
                                          width: getWidth(0.09, context),
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
          return "plzz fill";
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
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusedBorderColor),
          )),
    ),
  );
}


numberValidatorTextfield(
    TextEditingController textEditingController, String hint) {
  return TextFormField(
    validator: (value) {
      if (value == "") {
        return "plzz fill";
      } else if (value?.length != 10) {
        return "plzz enter 10 digit number";
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
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal.shade400),
        )),
  );
}

productDeleteDialog(
    lineId, int index, List orderDetails, BuildContext context) async {
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
                          checkWififorDeleteProduct(
                                  lineId, index, orderDetails, context)
                              .then((value) {
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Ok")),
                  ],
                )
              ],
            ),
          ),
        );
      });
}

Future<void> checkWififorDeleteProduct(
    lineId, int index, List orderDetails, BuildContext context) async {
  getStringPreference('apiUrl').then((apiUrl) async {
    try {
      getStringPreference('accessToken').then((token) async {
        if (apiUrl.toString().startsWith("192")) {
          showConnectivity().then((result) async {
            if (result == ConnectivityResult.wifi) {
              deleteProductInQuotationAndOrder(
                  lineId, index, orderDetails, token, apiUrl);
            } else {
              dialog(context, "Connect to Showroom Network");
            }
          });
        } else {
          deleteProductInQuotationAndOrder(
              lineId, index, orderDetails, token, apiUrl);
        }
      });
    } on SocketException catch (err) {
      dialog(context, "Connect to Showroom Network");
    }
  });
}

deleteProductInQuotationAndOrder(
    lineId, int index, List orderDetails, String token, String url) async {
  final response = await http.delete(
      Uri.parse("http://$url/api/rental.line/$lineId"),
      headers: {'Access-Token': token});
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

Future getDraftOrderData(
    BuildContext context, String apiUrl, String accessToken, int id) async {
  try {
    MyGetxController myGetxController = Get.find();
    String domain = "[('state','=','draft')]";
    var params = {'filters': domain.toString()};
    Uri uri = Uri.parse("http://$apiUrl/api/rental.rental");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri, headers: {
      'Access-Token': accessToken,
      'Content-Type': 'application/http',
      'Connection': 'keep-alive'
    });
    Map<String, dynamic> data = await jsonDecode(response.body);
    myGetxController.quotationData.addAll(data['results']);
    if (id != 0) {
      for (int i = 0; i < myGetxController.quotationData.length; i++) {
        if (myGetxController.quotationData[i]['id'] == id) {
          pushMethod(
              context,
              QuatationDetailScreen(
                id: myGetxController.quotationData[i]['id'],
              ));
        }
      }
    }
  } catch (e) {
    print(e);
  }
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
                  Text("Bill No : ", style: primaryStyle),
                  Text(
                    responseOfApi[index]['bill_no'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: primaryColor.withOpacity(0.9)),
                  )
                ],
              ),
            ),
            Text("Status : ", style: primaryStyle),
            Text(
              responseOfApi[index]['status'],
              style: TextStyle(
                  fontSize: 17,
                  color: primaryColor.withOpacity(0.6),
                  fontWeight: FontWeight.w500),
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
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600),
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("D. Date : ", style: primaryStyle),
                Text(
                  responseOfApi[index]['delivery_date'],
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.green),
                )
              ],
            ),
            Row(
              children: [
                Text("R. Date : ", style: primaryStyle),
                Text(
                  responseOfApi[index]['return_date'],
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
          "Remark :  ",
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
    print("inseide call");
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

void checkWlanForDataOrderDetailScreen(BuildContext context, int id) {
  getStringPreference('apiUrl').then((apiUrl) async {
    try {
      getStringPreference('accessToken').then((token) async {
        if (apiUrl.toString().startsWith("192")) {
          showConnectivity().then((result) async {
            if (result == ConnectivityResult.wifi) {
              getOrderScreenProductDetailData(apiUrl, token, id);
            } else {
              dialog(context, "Connect to Showroom Network");
            }
          });
        } else {
          getOrderScreenProductDetailData(apiUrl, token, id);
        }
      });
    } on SocketException catch (err) {
      dialog(context, "Connect to Showroom Network");
    }
  });
}

checkWlanForConfirmOrderThumbAndWaiting(
    int orderId,
    int productDetailId,
    BuildContext context,
    bool isIconThumb,
    String dropDownValue,
    String reason) {
  getStringPreference('apiUrl').then((apiUrl) async {
    try {
      getStringPreference('accessToken').then((token) async {
        if (apiUrl.toString().startsWith("192")) {
          showConnectivity().then((result) async {
            if (result == ConnectivityResult.wifi) {
              isIconThumb == true
                  ? confirmOrderThumb(
                      orderId, productDetailId, apiUrl, token, context)
                  : submitReasonForWaiting(orderId, productDetailId, apiUrl,
                      token, context, dropDownValue, reason);
            } else {
              dialog(context, "Connect to Showroom Network");
            }
          });
        } else {
          isIconThumb == true
              ? confirmOrderThumb(
                  orderId, productDetailId, apiUrl, token, context)
              : submitReasonForWaiting(orderId, productDetailId, apiUrl, token,
                  context, dropDownValue, reason);
        }
      });
    } on SocketException catch (err) {
      dialog(context, "Connect to Showroom Network");
    }
  });
}

confirmOrderThumb(int orderId, int productDetailId, String apiUrl, String token,
    BuildContext context) async {
  final response = await http.put(
      Uri.parse(
          "http://$apiUrl/api/rental.line/$productDetailId/btn_ready_api"),
      headers: {
        'Access-Token': token,
      });
  if (response.statusCode == 200) {
    checkWlanForDataOrderDetailScreen(context, orderId);
  } else {
    dialog(context, "Something went wrong");
  }
}

popUpForWaitingThumbInOrderScreen(
    BuildContext context, int productDetailId, int orderId) {
  MyGetxController myGetxController = Get.find();

  TextEditingController reasonController = TextEditingController(
      text: myGetxController.waitingThumbPopUpSelectedValue.value);
  return showDialog(
      context: context,
      builder: (_) {
        return Obx(() => Dialog(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  height: getHeight(0.30, context),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Select Reason",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
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
                          onPressed: () {
                            checkWlanForConfirmOrderThumbAndWaiting(
                                orderId,
                                productDetailId,
                                context,
                                false,
                                myGetxController
                                    .waitingThumbPopUpSelectedValue.value,
                                reasonController.text);
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
    String reason) async {
  print(dropDownValue);
  print(reason);
  final response = await http.put(
      Uri.parse(
          "http://$apiUrl/api/rental.line/$productDetailId/btn_waiting_api?reason=$dropDownValue&waiting_reason=$reason"),
      headers: {
        'Access-Token': token,
      });
  print(response.statusCode);
  if (response.statusCode == 200) {
    checkWlanForDataOrderDetailScreen(context, orderId);
    Navigator.pop(context);
  } else {
    FocusScope.of(context).unfocus();
    dialog(context, "something went wrong");
  }
}
