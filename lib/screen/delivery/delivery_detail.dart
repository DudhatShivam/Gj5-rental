import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/order/order_detail.dart';
import 'package:http/http.dart' as http;

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../../constant/extraproduct_card.dart';
import '../../constant/order_quotation_amount_card.dart';
import '../../constant/order_quotation_comman_card.dart';
import '../../constant/order_quotation_detail_card.dart';

class DeliveryDetailScreen extends StatefulWidget {
  final int id;
  final bool isFromAnotherScreen;

  const DeliveryDetailScreen(
      {Key? key, required this.id, required this.isFromAnotherScreen})
      : super(key: key);

  @override
  State<DeliveryDetailScreen> createState() => _DeliveryDetailScreenState();
}

class _DeliveryDetailScreenState extends State<DeliveryDetailScreen> {
  MyGetxController myGetxController = Get.find();
  bool isSelectAll = false;
  var extraProductDeliverResponse;

  @override
  void initState() {
    myGetxController.deliverySelectedExtraProductList.clear();
    clearList();
    checkWlanForData(true);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonPushMethodAppBar(
                    title: "Deliver Order",
                    isFormAnotherScreen: widget.isFromAnotherScreen),
                InkWell(
                  onTap: () {
                    isSelectAll = false;
                    checkWlanForData(true);
                  },
                  child: Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: FadeInRight(
                        child: refreshIcon,
                      )),
                )
              ],
            ),
            Obx(
              () => myGetxController.deliveryScreenParticularOrder.isNotEmpty
                  ? OrderQuatationCommanCard(
                      list: myGetxController.deliveryScreenParticularOrder,
                      shadowColor: Colors.grey.withOpacity(0.1),
                      index: 0,
                      isDeliveryScreen: true,
                      isOrderScreen: false,
                    )
                  : Container(),
            ),
            orderDetailContainer(),
            Obx(
              () => myGetxController
                      .deliveryScreenParticularOrderLineList.isNotEmpty
                  ? Row(
                      children: [
                        Checkbox(
                          activeColor: primary2Color,
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
                              orderId: widget.id ,
                              isDeliveryScreen: true,
                              isReceiveScreen: false,
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
                                    return ExtraProductCard(
                                      extraProductList: myGetxController
                                          .deliveryScreenParticularOrderLineExtraProductList,
                                      index: index,
                                      isDeliveryScreen: true,
                                    );
                                  }),
                            ],
                          ),
                        )
                      : Container()),
                  Obx(
                    () => myGetxController
                            .deliveryScreenParticularOrder.isNotEmpty
                        ? OrderQuotationAmountCard(
                            list:
                                myGetxController.deliveryScreenParticularOrder)
                        : Container(),
                  ),
                  Obx(() => myGetxController.selectedOrderLineList.isNotEmpty ||
                          myGetxController
                              .deliverySelectedExtraProductList.isNotEmpty
                      ? Container(
                          margin:
                              EdgeInsets.only(left: 15, bottom: 20, right: 15),
                          height: 45,
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                confirmationDialogForIsDeliverTrue();
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: primary2Color),
                              child: Text("DELIVER")))
                      : Container())
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  confirmationDialogForIsDeliverTrue() {
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
                    "Sure , Are you want to Deliver ?",
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
                            checkWlanForData(false);
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

  void checkWlanForData(bool isMainData) {
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                isMainData == true
                    ? getData(value, token)
                    : changeStatusToDeliver(value, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            isMainData == true
                ? getData(value, token)
                : changeStatusToDeliver(value, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  getData(
    apiUrl,
    token,
  ) async {
    myGetxController.deliveryScreenParticularOrder.clear();
    myGetxController.deliveryScreenParticularOrderLineList.clear();
    myGetxController.deliveryScreenParticularOrderLineExtraProductList.clear();
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
                List subProductList = element['product_details_ids'];
                subProductList.forEach((e) {
                  if (e['product_id']['default_code'] != null) {
                    myGetxController.selectedOrderLineSubProductList
                        .add(e['id']);
                  }
                });
              }
            }
          })
        : clearList();
  }

  clearList() {
    myGetxController.selectedOrderLineList.clear();
    myGetxController.selectedOrderLineSubProductList.clear();
  }

  Future<void> changeStatusToDeliver(apiUrl, token) async {
    if (myGetxController.selectedOrderLineList.isNotEmpty ||
        myGetxController.selectedOrderLineSubProductList.isNotEmpty) {
      String idList = myGetxController.selectedOrderLineList
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '');
      var body = {'is_deliver': 'True'};
      final response = await http.put(
        Uri.parse("http://$apiUrl/api/rental.line/$idList"),
        body: jsonEncode(body),
        headers: {
          'Access-Token': token,
        },
      );
      if (myGetxController.selectedOrderLineSubProductList.isNotEmpty) {
        if (myGetxController.deliverySelectedExtraProductList.isNotEmpty) {
          await deliverExtraProduct(apiUrl, token, false);
        }
        String productIdList = myGetxController.selectedOrderLineSubProductList
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', '');
        var body1 = {'is_deliver': 'True'};
        final response1 = await http.put(
          Uri.parse("http://$apiUrl/api/product.details/$productIdList"),
          body: jsonEncode(body1),
          headers: {
            'Access-Token': token,
          },
        );
        if (response.statusCode == 200 &&
            response1.statusCode == 200 &&
            extraProductDeliverResponse.statusCode == 200) {
          apiResponseFunction();
        } else {
          dialog(context, "Error Occur In Order Deliver", Colors.red.shade300);
        }
      } else {
        if (myGetxController.deliverySelectedExtraProductList.isNotEmpty) {
          await deliverExtraProduct(apiUrl, token, false);
          if (response.statusCode == 200 &&
              extraProductDeliverResponse.statusCode == 200) {
            apiResponseFunction();
          } else {
            dialog(
                context, "Error Occur In Order Deliver", Colors.red.shade300);
          }
        } else {
          if (response.statusCode == 200) {
            apiResponseFunction();
          } else {
            dialog(
                context, "Error Occur In Order Deliver", Colors.red.shade300);
          }
        }
      }
    } else {
      deliverExtraProduct(apiUrl, token, true);
    }
  }

  deliverExtraProduct(apiUrl, token, bool isShowMsg) async {
    String idList = myGetxController.deliverySelectedExtraProductList
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '');
    var body = {'is_deliver': 'true'};
    extraProductDeliverResponse = await http.put(
      Uri.parse("http://$apiUrl/api/extra.product/$idList"),
      body: jsonEncode(body),
      headers: {
        'Access-Token': token,
      },
    );
    if (isShowMsg == true) {
      if (extraProductDeliverResponse.statusCode == 200) {
        apiResponseFunction();
      } else {
        dialog(context, "Error Occur In Order Deliver", Colors.red.shade300);
      }
    }
  }

  apiResponseFunction() {
    myGetxController.deliverySelectedExtraProductList.clear();
    clearList();
    setState(() {
      isSelectAll = false;
    });
    dialog(context, "Order Deliver Successfully !", Colors.green.shade300);
  }
}
