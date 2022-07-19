import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/home/home.dart';
import 'package:gj5_rental/screen/booking%20status/booking_status.dart';
import 'package:http/http.dart' as http;
import 'package:gj5_rental/constant/order_quotation_comman_card.dart';
import 'dart:math' as math;
import 'package:gj5_rental/constant/order_quotation_detail_card.dart';
import '../../constant/constant.dart';
import '../../constant/order_quotation_amount_card.dart';
import '../../constant/order_quotation_comman_card.dart';
import '../quatation/quotation_const/quotation_constant.dart';
import 'order.dart';

class OrderDetail extends StatefulWidget {
  final int? id;
  final bool idFromAnotherScreen;

  const OrderDetail({Key? key, this.id, required this.idFromAnotherScreen})
      : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  Map<String, dynamic>? data = {};
  MyGetxController myGetxController = Get.find();

  @override
  void initState() {
    print(widget.id);
    super.initState();
    checkWlanForDataOrderDetailScreen(context, widget.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => popFunction(context, widget.idFromAnotherScreen),
      child: Scaffold(
          body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          allScreenInitialSizedBox(context),
          CommonPushMethodAppBar(
              title: "Order Detail",
              isFormAnotherScreen: widget.idFromAnotherScreen),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => myGetxController.particularOrderData.isNotEmpty
                ? OrderQuatationCommanCard(
                    list: myGetxController.particularOrderData,
                    isOrderScreen: true,
                    backGroundColor: Colors.grey.withOpacity(0.1),
                    index: 0,
                    isDeliveryScreen: false)
                : Container(),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Product Details : ",
              style: pageTitleTextStyle,
            ),
          ),
          Expanded(
            child: Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      myGetxController.orderLineList.isNotEmpty
                          ? ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.zero,
                              itemCount: myGetxController.orderLineList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return OrderQuotationDetailCard(
                                  orderDetailsList:
                                      myGetxController.orderLineList,
                                  index: index,
                                  productDetail:
                                      myGetxController.orderLineProductList,
                                  isOrderScreen: true,
                                  orderId: widget.id ?? 0,
                                  isDeliveryScreen: false,
                                  isReceiveScreen: false,
                                );
                              })
                          : Container(),
                      myGetxController.particularOrderData.isNotEmpty
                          ? OrderQuotationAmountCard(
                              list: myGetxController.particularOrderData)
                          : Container(),
                      SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                )),
          ),
        ],
      )),
    );
  }
}

class CommonPushMethodAppBar extends StatelessWidget {
  final String title;
  final bool isFormAnotherScreen;

  const CommonPushMethodAppBar(
      {Key? key, required this.title, required this.isFormAnotherScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        InkWell(
            onTap: () {
              popFunction(context, isFromAnotherScreen);
            },
            child: FadeInLeft(child: backArrowIcon)),
        SizedBox(
          width: 10,
        ),
        FadeInLeft(
          child: Text(
            title,
            style: pageTitleTextStyle,
          ),
        ),
      ],
    );
  }
}
