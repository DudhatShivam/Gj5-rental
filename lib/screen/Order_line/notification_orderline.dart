import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/constant/constant.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:http/http.dart' as http;

import '../../Utils/utils.dart';
import '../order/order_detail.dart';
import 'orderline_constant/order_line_card.dart';

class NotificationOrderLine extends StatefulWidget {
  final int id;

  const NotificationOrderLine({Key? key, required this.id}) : super(key: key);

  @override
  State<NotificationOrderLine> createState() => _NotificationOrderLineState();
}

class _NotificationOrderLineState extends State<NotificationOrderLine> {
  MyGetxController myGetxController = Get.put(MyGetxController());
  bool ARService = false;
  bool ARManager = false;

  @override
  void initState() {
    super.initState();
    getAccessRight();
    checkWlanForNotificationOrderLine();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => popFunction(context, true),
        child: Scaffold(
          body: Column(
            children: [
              allScreenInitialSizedBox(context),
              CommonPushMethodAppBar(
                  title: "Order Line", isFormAnotherScreen: true),
              Obx(() => ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  scrollDirection: Axis.vertical,
                  itemCount: myGetxController.orderLineScreenList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return OrderLineCard(
                      orderList: myGetxController.orderLineScreenList,
                      productList: myGetxController.orderLineScreenProductList,
                      index: index,
                      isProductDetailScreen: false,
                      isShowFromGroupBy: false,
                      ARManager: ARManager,
                      ARService: ARService,
                    );
                  }))
            ],
          ),
        ));
  }

  void checkWlanForNotificationOrderLine() {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                getDataOfOrderLine(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            getDataOfOrderLine(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  Future<void> getDataOfOrderLine(apiUrl, token) async {
    myGetxController.orderLineScreenList.clear();
    myGetxController.orderLineScreenProductList.clear();
    final response = await http.get(
        Uri.parse("http://$apiUrl/api/rental.line/${widget.id}"),
        headers: {
          'Access-Token': token,
        });
    if (response.statusCode == 200) {
      myGetxController.orderLineScreenList.add(jsonDecode(response.body));
      addDataInOrderLineProductList(myGetxController.orderLineScreenList);
    } else {
      dialog(context, "Something Went Wrong", Colors.red.shade300);
    }
  }

  Future<void> getAccessRight() async {
    ARManager = await getBoolPreference('ARManager');
    ARService = await getBoolPreference('ARService');
  }
}
