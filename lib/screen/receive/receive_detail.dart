import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../../constant/extraproduct_card.dart';
import '../../constant/order_quotation_amount_card.dart';
import '../../constant/order_quotation_comman_card.dart';
import '../../constant/order_quotation_detail_card.dart';
import '../../getx/getx_controller.dart';
import '../booking status/booking_status.dart';

class ReceiveDetail extends StatefulWidget {
  final int orderId;

  const ReceiveDetail({Key? key, required this.orderId}) : super(key: key);

  @override
  State<ReceiveDetail> createState() => _ReceiveDetailState();
}

class _ReceiveDetailState extends State<ReceiveDetail> {
  MyGetxController myGetxController = Get.find();

  @override
  void initState() {
    clearList();
    checkWlanForData(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          allScreenInitialSizedBox(context),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ScreenAppBar(
                screenName: "Receive Detail",
              ),
              InkWell(
                onTap: () {
                  checkWlanForData(false);
                },
                child: Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: FadeInRight(child: refreshIcon)),
              )
            ],
          ),
          Obx(
            () => myGetxController.receiveParticularOrderList.isNotEmpty
                ? OrderQuatationCommanCard(
                    list: myGetxController.receiveParticularOrderList,
                    backGroundColor: Colors.grey.withOpacity(0.1),
                    index: 0,
                    isDeliveryScreen: true,
                    isOrderScreen: false,
                  )
                : Container(),
          ),
          orderDetailContainer(),
          Expanded(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myGetxController.receiveOrderLineList.isNotEmpty
                        ? ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount:
                                myGetxController.receiveOrderLineList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return OrderQuotationDetailCard(
                                orderDetailsList:
                                    myGetxController.receiveOrderLineList,
                                index: index,
                                productDetail:
                                    myGetxController.receiveSubProductList,
                                isOrderScreen: false,
                                orderId: widget.orderId ?? 0,
                                isDeliveryScreen: false,
                                isReceiveScreen: true,
                              );
                            })
                        : Container(),
                    myGetxController.receiveExtraProductList.isNotEmpty
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
                                        .receiveExtraProductList.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return ExtraProductCard(
                                        extraProductList: myGetxController
                                            .receiveExtraProductList,
                                        index: index,
                                      );
                                    }),
                              ],
                            ),
                          )
                        : Container(),
                    myGetxController.receiveParticularOrderList.isNotEmpty
                        ? OrderQuotationAmountCard(
                            list: myGetxController.receiveParticularOrderList)
                        : Container(),
                    myGetxController.receiveSelectedOrderLineList.isNotEmpty ||
                            myGetxController
                                .receiveSelectedSubProductList.isNotEmpty
                        ? Container(
                            margin: EdgeInsets.only(
                                left: 15, bottom: 20, right: 15),
                            height: 45,
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  confirmationDialogForIsReceive();
                                },
                                child: Text("RECEIVE")))
                        : Container()
                  ],
                )),
          ))
        ],
      ),
    );
  }

  void checkWlanForData(bool isChangeStatusToReceive) {
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                isChangeStatusToReceive == false
                    ? getData(value, token)
                    : changeStatusToReceive(value, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            isChangeStatusToReceive == false
                ? getData(value, token)
                : changeStatusToReceive(value, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  confirmationDialogForIsReceive() {
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
                    "Sure , Are you want to Receive ?",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 19,
                    ),
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
                            Navigator.pop(context);
                            checkWlanForData(true);
                          },
                          child: Text("Ok")),
                      SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red.shade300),
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

  Future<void> getData(apiUrl, token) async {
    myGetxController.receiveParticularOrderList.clear();
    myGetxController.receiveOrderLineList.clear();
    myGetxController.receiveExtraProductList.clear();
    int id = widget.orderId;
    Map data = {};
    final response = await http.get(
        Uri.parse("http://$apiUrl/api/rental.rental/$id"),
        headers: {'Access-Token': token, 'Content-Type': 'application/http'});

    data = jsonDecode(response.body);
    myGetxController.receiveParticularOrderList.add(data);
    myGetxController.receiveOrderLineList.addAll(data['line_ids']);
    myGetxController.receiveExtraProductList.addAll(data['extra_product_ids']);
    getDataForProductDetail();
  }

  void getDataForProductDetail() {
    myGetxController.receiveSubProductList.clear();
    myGetxController.receiveOrderLineList.forEach((element) {
      if (element['product_details_ids'] != []) {
        List<dynamic> data = element['product_details_ids'];
        data.forEach((value) {
          if (value['product_id']['default_code'] != null) {
            myGetxController.receiveSubProductList.add(value);
          }
        });
      }
    });
  }

  clearList() {
    myGetxController.receiveSelectedOrderLineList.clear();
    myGetxController.receiveSelectedSubProductList.clear();
  }

  changeStatusToReceive(apiUrl, token) async {
    String idList = myGetxController.receiveSelectedOrderLineList
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '');
    var body = {'is_receive': 'True'};
    final response = await http.put(
      Uri.parse("http://$apiUrl/api/rental.line/$idList"),
      body: jsonEncode(body),
      headers: {
        'Access-Token': token,
      },
    );
    if (myGetxController.receiveSelectedSubProductList.isNotEmpty) {
      String productIdList = myGetxController.receiveSelectedSubProductList
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '');
      var body1 = {'is_receive': 'True'};
      final response1 = await http.put(
        Uri.parse("http://$apiUrl/api/product.details/$productIdList"),
        body: jsonEncode(body1),
        headers: {
          'Access-Token': token,
        },
      );
      if (response.statusCode == 200 && response1.statusCode == 200) {
        apiResponseFunction();
      } else {
        if (myGetxController.receiveSelectedOrderLineList.isEmpty) {
          apiResponseFunction();
        } else {
          dialog(context, "Error Occur In Order Receive", Colors.red.shade300);
        }
      }
    } else {
      if (response.statusCode == 200) {
        apiResponseFunction();
      } else {
        dialog(context, "Error Occur In Order Receive", Colors.red.shade300);
      }
    }
  }

  void apiResponseFunction() {
    clearList();
    dialog(context, "Order Received Successfully !", Colors.green.shade300);
  }
}
