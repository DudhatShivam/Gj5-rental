import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/screen/order/order_detail.dart';
import 'package:http/http.dart' as http;

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../../constant/order_quotation_amount_card.dart';
import '../../constant/order_quotation_comman_card.dart';
import '../../constant/order_quotation_detail_card.dart';
import '../../getx/getx_controller.dart';

class CancelOrderDetailScreen extends StatefulWidget {
  final int orderId;
  final bool isFromAnotherScreen;

  const CancelOrderDetailScreen(
      {Key? key, required this.orderId, required this.isFromAnotherScreen})
      : super(key: key);

  @override
  State<CancelOrderDetailScreen> createState() =>
      _CancelOrderDetailScreenState();
}

class _CancelOrderDetailScreenState extends State<CancelOrderDetailScreen> {
  MyGetxController myGetxController = Get.find();

  @override
  void initState() {
    clearList();
    chekWlanForCancelDetailOrderData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => popFunction(context, widget.isFromAnotherScreen),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            allScreenInitialSizedBox(context),
            CommonPushMethodAppBar(
                title: "Cancelled Order Detail",
                isFormAnotherScreen: widget.isFromAnotherScreen),
            Obx(
              () => myGetxController.cancelParticularOrderList.isNotEmpty
                  ? OrderQuatationCommanCard(
                      list: myGetxController.cancelParticularOrderList,
                      isOrderScreen: false,
                      shadowColor: Colors.grey.withOpacity(0.1),
                      index: 0,
                      isDeliveryScreen: false)
                  : Container(),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Order Details : ",
                style: pageTitleTextStyle,
              ),
            ),
            Expanded(
              child: Obx(() => SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        myGetxController
                                .cancelParticularOrderLineList.isNotEmpty
                            ? ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.zero,
                                itemCount: myGetxController
                                    .cancelParticularOrderLineList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return OrderQuotationDetailCard(
                                    orderDetailsList: myGetxController
                                        .cancelParticularOrderLineList,
                                    index: index,
                                    productDetail: myGetxController
                                        .cancelParticularOrderProductList,
                                    isOrderScreen: true,
                                    orderId: widget.orderId,
                                    isDeliveryScreen: false,
                                    isReceiveScreen: false,
                                  );
                                })
                            : Container(),
                        myGetxController.cancelParticularOrderList.isNotEmpty
                            ? OrderQuotationAmountCard(
                                list:
                                    myGetxController.cancelParticularOrderList)
                            : Container(),
                        SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void chekWlanForCancelDetailOrderData() {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                getCancelOrderDetailData(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            getCancelOrderDetailData(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  getCancelOrderDetailData(String apiUrl, String token) async {
    final response = await http.get(
        Uri.parse("http://$apiUrl/api/rental.rental/${widget.orderId}"),
        headers: {'Access-Token': token, 'Content-Type': 'application/http'});
    Map data = jsonDecode(response.body);
    myGetxController.cancelParticularOrderList.add(data);
    myGetxController.cancelParticularOrderLineList.value = data['line_ids'];
    await checkForCancelOrderProductDetail();
  }

  checkForCancelOrderProductDetail() {
    myGetxController.cancelParticularOrderLineList.forEach((element) {
      if (element['product_details_ids'] != []) {
        List<dynamic> data = element['product_details_ids'];
        data.forEach((value) {
          if (value['product_id']['default_code'] != null) {
            myGetxController.cancelParticularOrderProductList.add(value);
          }
        });
      }
    });
  }

  void clearList() {
    myGetxController.cancelParticularOrderLineList.clear();
    myGetxController.cancelParticularOrderList.clear();
    myGetxController.cancelParticularOrderProductList.clear();
  }
}
