import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../Utils/utils.dart';
import '../../../constant/constant.dart';
import '../../../getx/getx_controller.dart';
import '../../order/order_detail.dart';
import 'order_line_service_popup.dart';

class OrderLineCard extends StatelessWidget {
  final List<dynamic> orderList;
  final List<dynamic> productList;
  final int index;
  final bool isProductDetailScreen;
  final bool? isShowFromGroupBy;
  final int? groupByMainListIndex;
  final bool ARService;
  final bool ARManager;

  OrderLineCard(
      {Key? key,
      required this.orderList,
      required this.productList,
      required this.index,
      required this.isProductDetailScreen,
      this.isShowFromGroupBy,
      this.groupByMainListIndex,
      required this.ARService,
      required this.ARManager})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
          color: statusshadowColor(orderList, index),
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
                    Text("Order No : ", style: primaryStyle),
                    InkWell(
                      onTap: () {
                        pushMethod(
                            context,
                            OrderDetail(
                                idFromAnotherScreen: false,
                                id: orderList[index]['rental_id']['id']));
                      },
                      child: Text(
                        orderList[index]['rental_id']['name'] ?? "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            decoration: TextDecoration.underline,
                            color: infoColor),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusshadowColor(orderList, index),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: isProductDetailScreen == false
                    ? Text(
                        orderList[index]['state'],
                        style: TextStyle(
                            color: statusColor(orderList, index),
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      )
                    : Text(
                        orderList[index]['state'],
                        style: TextStyle(
                            color: statusColor(orderList, index),
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
              )
            ],
          ),
          Row(
            children: [
              Text("Code : ", style: primaryStyle),
              Expanded(
                child: isProductDetailScreen == false
                    ? Text(
                        orderList[index]['product_id']['default_code'],
                        style: allCardSubText,
                      )
                    : Text(
                        orderList[index]['origin_product_id']['default_code'],
                        style: allCardSubText,
                      ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Product : ", style: primaryStyle),
              Expanded(
                child: Text(
                  orderList[index]['product_id']['name'] ?? "",
                  style: allCardSubText,
                ),
              ),
            ],
          ),
          isProductDetailScreen == true
              ? Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text("Type : ", style: primaryStyle),
                            Text(
                              orderList[index]['product_type'] ?? "",
                              style: allCardSubText,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                                "${orderList[index]['quantity'].toString()}/",
                                style: allCardSubText),
                            Text(
                              orderList[index]['qty_available'].toString(),
                              style: allCardSubText,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                )
              : Container(),
          isProductDetailScreen == false
              ? Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text("Customer : ", style: primaryStyle),
                        Expanded(
                          child: Text(
                            orderList[index]['partner_id']['name'] ?? "",
                            style: allCardSubText,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Container(),
          SizedBox(
            height: 10,
          ),
          orderList[index]['remarks'] != null
              ? Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Text("Remarks : ", style: primaryStyle),
                      Expanded(
                        child: Text(
                          orderList[index]['remarks'],
                          style: remarkTextStyle,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          isProductDetailScreen == false
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    orderList[index]['waiting_reason'] != null &&
                            orderList[index]['state'] == "waiting"
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Text("Waiting reason : ", style: primaryStyle),
                                Expanded(
                                  child: Text(
                                    orderList[index]['waiting_reason'],
                                    style: allCardSubText,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    Divider(
                      height: 0.5,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "D. Date : ",
                                style: primaryStyle,
                              ),
                              Text(
                                changeDateFormat(orderList[index]['delivery_date']),
                                style: deliveryDateStyle,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "  R. Date : ",
                                style: primaryStyle,
                              ),
                              Text(
                                changeDateFormat(orderList[index]['return_date']),
                                style: returnDateStyle,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: productList.map((e) {
                          return e['origin_product_id'] ==
                                  orderList[index]['product_id']['id']
                              ? GestureDetector(
                                  onDoubleTap: () {
                                    orderDetailDialog(
                                        context,
                                        e['product_id']['default_code'],
                                        e['product_type'],
                                        e['remarks']);
                                  },
                                  child: Container(
                                    height: 40,
                                    margin:
                                        EdgeInsets.only(right: 5, bottom: 5),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.primaries[Random()
                                              .nextInt(Colors.primaries.length)]
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      e['product_id']['default_code'],
                                      style: TextStyle(
                                          color: ([...Colors.primaries]
                                                ..shuffle())
                                              .first,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                  ),
                                )
                              : Container();
                        }).toList(),
                      ),
                    ),
                    ARService == true || ARManager == true
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  chekWlanToNotifyToAll(
                                      orderList[index]['id'], context);
                                },
                                child: Icon(
                                  Icons.notifications_active,
                                  size: 28,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              orderList[index]['state'] != "service" &&
                                      orderList[index]['state'] != "deliver" &&
                                      orderList[index]['state'] != "receive" &&
                                      orderList[index]['state'] != "cancel"
                                  ? InkWell(
                                      onTap: () {
                                        checkWlanForServicePopUpInOrderLine(
                                            context,
                                            orderList[index]['id'],
                                            index,
                                            isShowFromGroupBy ?? false,
                                            groupByMainListIndex ?? 0);
                                      },
                                      child: Icon(
                                        Icons.settings,
                                        size: 28,
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                width: 10,
                              ),
                              orderList[index]['state'] != "waiting" &&
                                      orderList[index]['state'] != "deliver" &&
                                      orderList[index]['state'] != "receive" &&
                                      orderList[index]['state'] != "cancel"
                                  ? InkWell(
                                      onTap: () {
                                        popUpForWaitingThumbInOrderScreen(
                                            context,
                                            orderList[index]['id'],
                                            orderList[index]['rental_id']['id'],
                                            orderList[index]['product_id']
                                                ['default_code'],
                                            orderList[index]['product_id']
                                                ['name'],
                                            true,
                                            index,
                                            isShowFromGroupBy ?? false,
                                            groupByMainListIndex ?? 0);
                                      },
                                      child: Icon(
                                        Icons.lock_clock,
                                        size: 28,
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                width: 10,
                              ),
                              orderList[index]['state'] != "ready" &&
                                      orderList[index]['state'] != "deliver" &&
                                      orderList[index]['state'] != "receive" &&
                                      orderList[index]['state'] != "cancel"
                                  ? InkWell(
                                      onTap: () {
                                        checkWlanForConfirmOrderThumbAndWaiting(
                                            orderList[index]['rental_id']['id'],
                                            orderList[index]['id'],
                                            context,
                                            true,
                                            "",
                                            "",
                                            orderList[index]['product_id']
                                                ['default_code'],
                                            orderList[index]['product_id']
                                                ['name'],
                                            true,
                                            index,
                                            isShowFromGroupBy ?? false,
                                            groupByMainListIndex ?? 0);
                                      },
                                      child: Icon(
                                        Icons.thumb_up_alt_rounded,
                                        size: 28,
                                      ),
                                    )
                                  : Container(),
                            ],
                          )
                        : Container()
                  ],
                )
              : Container()
        ],
      ),
    );
  }
}

void chekWlanToNotifyToAll(int rentalLineId, BuildContext context) {
  getStringPreference('apiUrl').then((apiUrl) async {
    try {
      getStringPreference('accessToken').then((token) async {
        if (apiUrl.toString().startsWith("192")) {
          showConnectivity().then((result) async {
            if (result == ConnectivityResult.wifi) {
              notifyToAll(apiUrl, token, rentalLineId, context);
            } else {
              dialog(
                  context, "Connect to Showroom Network", Colors.red.shade300);
            }
          });
        } else {
          notifyToAll(apiUrl, token, rentalLineId, context);
        }
      });
    } on SocketException catch (err) {
      dialog(context, "Connect to Showroom Network", Colors.red.shade300);
    }
  });
}

notifyToAll(apiUrl, token, int rentalLineId, BuildContext context) async {
  final response = await http.put(
    Uri.parse(
        "http://$apiUrl/api/rental.line/$rentalLineId/send_msg_to_all_user"),
    headers: {'Access-Token': token},
  );
  if (response.statusCode == 200) {
    dialog(context, "Notification Sent Successfully", Colors.green.shade300);
  } else {
    dialog(context, "Error In Sending Notification", Colors.red.shade300);
  }
}

void cheCkWlanForOrderLineData(BuildContext context, bool isLoadAll) {
  getStringPreference('apiUrl').then((value) async {
    try {
      getStringPreference('accessToken').then((token) async {
        if (value.toString().startsWith("192")) {
          showConnectivity().then((result) async {
            if (result == ConnectivityResult.wifi) {
              getDataForOrderLine(value, token, context, isLoadAll);
            } else {
              dialog(
                  context, "Connect to Showroom Network", Colors.red.shade300);
            }
          });
        } else {
          getDataForOrderLine(value, token, context, isLoadAll);
        }
      });
    } on SocketException catch (err) {
      dialog(context, "Connect to Showroom Network", Colors.red.shade300);
    }
  });
}

checkWlanForServicePopUpInOrderLine(BuildContext context, int orderId,
    int index, bool isShowFromGroupBy, int groupByMainListIndex) {
  getStringPreference('apiUrl').then((value) async {
    try {
      getStringPreference('accessToken').then((token) async {
        if (value.toString().startsWith("192")) {
          showConnectivity().then((result) async {
            if (result == ConnectivityResult.wifi) {
              showDialog(
                  context: context,
                  builder: (_) {
                    return OrderLineServicePopUp(
                      orderId: orderId,
                      index: index,
                      isShowFromGroupBy: isShowFromGroupBy,
                      groupByMainListIndex: groupByMainListIndex,
                    );
                  });
            } else {
              dialog(
                  context, "Connect to Showroom Network", Colors.red.shade300);
            }
          });
        } else {
          showDialog(
              context: context,
              builder: (_) {
                return OrderLineServicePopUp(
                  orderId: orderId,
                  index: index,
                  isShowFromGroupBy: isShowFromGroupBy,
                );
              });
        }
      });
    } on SocketException catch (err) {
      dialog(context, "Connect to Showroom Network", Colors.red.shade300);
    }
  });
}

int orderLineOffset = 0;

Future<void> getDataForOrderLine(
    apiUrl, token, BuildContext context, bool isLoadAll) async {
  String dayBefore = get5daysBeforeDate();
  String dayAfter = get7DaysAfterDate();
  String domain;
  var params;
  MyGetxController myGetxController = Get.find();
  domain =
      "[('order_status' , 'not in' , ('draft','cancel','done')), ('state' , 'not in' , ('cancel','receive','deliver')),('delivery_date' , '>=' , '$dayBefore') , ('delivery_date' , '<=' , '$dayAfter')]";

  isLoadAll == false
      ? params = {
          'filters': domain.toString(),
          'limit': '5',
          'offset': '$orderLineOffset',
          'order': 'id desc'
        }
      : params = {
          'filters': domain.toString(),
        };
  Uri uri = Uri.parse("http://$apiUrl/api/rental.line");
  final finalUri = uri.replace(queryParameters: params);
  final response = await http.get(finalUri, headers: {
    'Access-Token': token,
  });
  myGetxController.noDataInOrderLine.value = false;
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    if (data['count'] > 0) {
      myGetxController.orderLineScreenList.addAll(data['results']);
      addDataInOrderLineProductList(data['results']);
    } else {
      if (myGetxController.orderLineScreenList.isEmpty) {
        dialog(context, "No Data Found !", Colors.red.shade300);
      }
    }
    print(response.body);
  } else {
    dialog(context, "Something Went Wrong !", Colors.red.shade300);
  }
}

void addDataInOrderLineProductList(List productList) {
  MyGetxController myGetxController = Get.find();
  productList.forEach((element) {
    if (element['product_details_ids'] != []) {
      List<dynamic> data = element['product_details_ids'];
      data.forEach((value) {
        if (value['product_id']['default_code'] != null) {
          myGetxController.orderLineScreenProductList.add(value);
        }
      });
    }
  });
}

void setDataOfUpdatedIdInOrderLineScreen(int orderId, int index) {
  MyGetxController myGetxController = Get.find();
  getStringPreference('apiUrl').then((apiUrl) async {
    getStringPreference('accessToken').then((token) async {
      final response = await http
          .get(Uri.parse("http://$apiUrl/api/rental.line/$orderId"), headers: {
        'Access-Token': token,
        'Content-Type': 'application/http',
        'Connection': 'keep-alive'
      });
      if (response.statusCode == 200) {
        myGetxController.orderLineScreenList.removeAt(index);
        myGetxController.orderLineScreenList
            .insert(index, jsonDecode(response.body));
      }
    });
  });
}

void setDataOfUpdatedIdInGroupByListOrderLineScreen(
    int orderId, int index, int groupByMainListIndex) {
  MyGetxController myGetxController = Get.find();
  Map data = myGetxController.groupByList[groupByMainListIndex];
  List list = data['data'];
  getStringPreference('apiUrl').then((apiUrl) async {
    getStringPreference('accessToken').then((token) async {
      final response = await http
          .get(Uri.parse("http://$apiUrl/api/rental.line/$orderId"), headers: {
        'Access-Token': token,
        'Content-Type': 'application/http',
        'Connection': 'keep-alive'
      });
      if (response.statusCode == 200) {
        list.removeAt(index);
        list.insert(index, jsonDecode(response.body));
        myGetxController.groupByList.removeAt(groupByMainListIndex);
        myGetxController.groupByList.insert(groupByMainListIndex, data);
      }
    });
  });
}
