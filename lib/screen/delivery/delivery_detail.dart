import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/booking%20status/booking_status.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../Utils/utils.dart';
import '../../constant/order_quotation_comman_card.dart';
import '../../constant/order_quotation_detail_card.dart';

class DeliveryDetailScreen extends StatefulWidget {
  final int id;

  const DeliveryDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<DeliveryDetailScreen> createState() => _DeliveryDetailScreenState();
}

class _DeliveryDetailScreenState extends State<DeliveryDetailScreen> {
  MyGetxController myGetxController = Get.find();
  bool isSelectAll = false;

  @override
  void initState() {
    myGetxController.selectedOrderLineList.clear();
    myGetxController.deliveryScreenParticularOrder.clear();
    myGetxController.deliveryScreenParticularOrderLineList.clear();
    myGetxController.deliveryScreenParticularOrderLineExtraProductList.clear();
    checkWlanForData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 10,
          ),
          ScreenAppBar(
            screenName: "Deliver Order",
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => myGetxController.deliveryScreenParticularOrder.isNotEmpty
                ? OrderQuatationCommanCard(
                    list: myGetxController.deliveryScreenParticularOrder,
                    backGroundColor: Colors.grey.withOpacity(0.1),
                    index: 0,
                    isDeliveryScreen: true,
                    isOrderScreen: false,
                  )
                : Container(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Text(
              "Order Details : ",
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 21),
            ),
          ),
          Obx(
            () => myGetxController
                    .deliveryScreenParticularOrderLineList.isNotEmpty
                ? Row(
                    children: [
                      Checkbox(
                        value: isSelectAll,
                        onChanged: (value) {
                          setState(() {
                            isSelectAll = value ?? true;
                          });
                          selectWholeItem();
                        },
                      ),
                      Text(
                        "Select all",
                        style: primaryStyle,
                      )
                    ],
                  )
                : Container(),
          ),
          Expanded(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => myGetxController
                        .deliveryScreenParticularOrderLineList.isNotEmpty
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: myGetxController
                            .deliveryScreenParticularOrderLineList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return OrderQuotationDetailCard(
                            orderDetailsList: myGetxController
                                .deliveryScreenParticularOrderLineList,
                            index: index,
                            productDetail: myGetxController
                                .deliveryScreenParticularOrderLineProductList,
                            isOrderScreen: false,
                            orderId: widget.id ?? 0,
                            isDeliveryScreen: true,
                          );
                        })
                    : Container()),
                Obx(() => myGetxController
                        .deliveryScreenParticularOrderLineExtraProductList
                        .isNotEmpty
                    ? Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Extra Product : ",
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 21),
                                ),
                              ),
                            ),
                            ListView.builder(
                                padding: EdgeInsets.only(bottom: 15),
                                itemCount: myGetxController
                                    .deliveryScreenParticularOrderLineExtraProductList
                                    .length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  String deliveryDate = DateFormat("dd/MM/yyyy")
                                      .format(DateTime.parse(myGetxController
                                              .deliveryScreenParticularOrderLineExtraProductList[
                                          index]['delivery_date']));
                                  String returnDate = DateFormat("dd/MM/yyyy")
                                      .format(DateTime.parse(myGetxController
                                              .deliveryScreenParticularOrderLineExtraProductList[
                                          index]['return_date']));
                                  return Container(
                                    padding: EdgeInsets.all(15),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Color(0xffE6ECF2),
                                            width: 0.7),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text("Name : ",
                                                style: primaryStyle),
                                            Text(
                                              "[KALGI] Safa Ni Kalgi",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  color: primaryColor
                                                      .withOpacity(0.9)),
                                            ),
                                          ],
                                        ),
                                        myGetxController.deliveryScreenParticularOrderLineExtraProductList[
                                                    index]['remarks'] ==
                                                null
                                            ? Container()
                                            : Column(
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Remark : ",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors
                                                                .grey.shade600),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          myGetxController
                                                                  .deliveryScreenParticularOrderLineExtraProductList[
                                                              index]['remarks'],
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "D. Date : ",
                                                  style: primaryStyle,
                                                ),
                                                Text(
                                                  deliveryDate,
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                  returnDate,
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.red),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ],
                        ),
                      )
                    : Container()),
                Obx(() => myGetxController.selectedOrderLineList.isNotEmpty
                    ? Container(
                        margin:
                            EdgeInsets.only(left: 15, bottom: 20, right: 15),
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              print("pressed");
                              checkWlanForChangeStatusToDeliver();
                            },
                            child: Text("Deliver")))
                    : Container())
              ],
            ),
          )),
        ],
      ),
    );
  }

  void checkWlanForData() {
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                getData(value, token);
              } else {
                dialog(context, "Connect to Showroom Network");
              }
            });
          } else {
            getData(value, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network");
      }
    });
  }

  Future<void> getData(
    apiUrl,
    token,
  ) async {
    int id = widget.id;
    Map data = {};
    final response = await http.get(
        Uri.parse("http://$apiUrl/api/rental.rental/$id"),
        headers: {'Access-Token': token, 'Content-Type': 'application/http'});

    data = jsonDecode(response.body);
    myGetxController.deliveryScreenParticularOrder.add(data);
    myGetxController.deliveryScreenParticularOrderLineList
        .addAll(data['line_ids']);
    myGetxController.deliveryScreenParticularOrderLineExtraProductList
        .addAll(data['extra_product_ids']);
    getDataForProductDetail();
  }

  void getDataForProductDetail() {
    myGetxController.deliveryScreenParticularOrderLineProductList.clear();
    myGetxController.deliveryScreenParticularOrderLineList.forEach((element) {
      if (element['product_details_ids'] != []) {
        List<dynamic> data = element['product_details_ids'];
        data.forEach((value) {
          if (value['product_id']['default_code'] != null) {
            myGetxController.deliveryScreenParticularOrderLineProductList
                .add(value);
          }
        });
      }
    });
  }

  void selectWholeItem() {
    List<dynamic> dataList =
        myGetxController.deliveryScreenParticularOrderLineList;
    isSelectAll == true
        ? dataList.forEach((element) {
            if (element['state'] == 'ready') {
              if (myGetxController.selectedOrderLineList
                      .contains(element['id']) ==
                  false) {
                myGetxController.selectedOrderLineList.add(element['id']);
              }
            }
          })
        : myGetxController.selectedOrderLineList.clear();
  }

  void checkWlanForChangeStatusToDeliver() {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                changeStatusToDeliver(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network");
              }
            });
          } else {
            changeStatusToDeliver(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network");
      }
    });
  }

  Future<void> changeStatusToDeliver(apiUrl, token) async {
    for (int i = 0; i < myGetxController.selectedOrderLineList.length; i++) {
      print(myGetxController.selectedOrderLineList[i]);
      var body = {'is_deliver': 'True', 'deliver_qty': '1'};
      final response = await http.put(
        Uri.parse(
            "http://$apiUrl/api/rental.line/${myGetxController.selectedOrderLineList[i]}"),
        body: jsonEncode(body),
        headers: {
          'Access-Token': token,
        },
      );
      print(response.statusCode);
      print(response.body);
    }
  }
}
