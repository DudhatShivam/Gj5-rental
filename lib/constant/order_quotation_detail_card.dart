import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:intl/intl.dart';

import '../Utils/utils.dart';
import '../screen/order/change_product/change_product_dialog.dart';
import '../screen/quatation/edit_order_line.dart';
import '../screen/quatation/quotation_const/quotation_constant.dart';
import '../screen/receive/dialog_select_subproduct.dart';
import 'constant.dart';

class OrderQuotationDetailCard extends StatelessWidget {
  final List<dynamic> orderDetailsList;
  final int index;
  final List productDetail;
  final bool isOrderScreen;
  final int orderId;
  final bool isDeliveryScreen;
  final bool isReceiveScreen;
  final bool? isFromBookingOrderScreen;
  final bool? ARChangeProduct;

  OrderQuotationDetailCard({
    Key? key,
    required this.orderDetailsList,
    required this.index,
    required this.productDetail,
    required this.isOrderScreen,
    required this.orderId,
    required this.isDeliveryScreen,
    required this.isReceiveScreen,
    this.isFromBookingOrderScreen,
    this.ARChangeProduct,
  }) : super(key: key);

  MyGetxController myGetxController = Get.find();

  @override
  Widget build(BuildContext context) {
    String deliveryDate = DateFormat("dd/MM/yyyy")
        .format(DateTime.parse(orderDetailsList[index]['delivery_date']));
    String returnDate = DateFormat("dd/MM/yyyy")
        .format(DateTime.parse(orderDetailsList[index]['return_date']));
    SwipeActionController controller = SwipeActionController();
    return SwipeActionCell(
      controller: controller,
      key: ObjectKey(orderDetailsList[index]),
      trailingActions: isDeliveryScreen == false &&
              isOrderScreen == false &&
              isReceiveScreen == false
          ? <SwipeAction>[
              SwipeAction(
                  title: "Delete",
                  onTap: (CompletionHandler handler) async {
                    controller.closeAllOpenCell();
                    productDeleteDialog(orderDetailsList[index]['id'], index,
                        orderDetailsList, context, false);
                  },
                  color: Colors.red),
              SwipeAction(
                  title: "Edit",
                  onTap: (CompletionHandler handler) async {
                    controller.closeAllOpenCell();
                    await addWholeSubProductInList(
                            orderDetailsList[index]['id'])
                        .then((value) {
                      pushMethod(
                          context,
                          EditOrderLine(
                            orderId: orderId,
                            lineId: orderDetailsList[index]['id'],
                            deliveryDate: orderDetailsList[index]
                                ['delivery_date'],
                            returnDate: orderDetailsList[index]['return_date'],
                            remark: orderDetailsList[index]['remarks'],
                            rent: orderDetailsList[index]['rent'],
                            wholeSubProductList: value,
                            productName: orderDetailsList[index]['product_id']
                                ['name'],
                            productCode: orderDetailsList[index]['product_id']
                                ['default_code'],
                            isFromBookingOrderScreen:
                                isFromBookingOrderScreen ?? false,
                          ));
                    });
                  },
                  closeOnTap: false,
                  color: Colors.blue),
            ]
          : orderDetailsList[index]['state'] == "ready" &&
                  isDeliveryScreen == true
              ? [
                  SwipeAction(
                      title: "Select",
                      onTap: (CompletionHandler handler) async {
                        controller.closeAllOpenCell();
                        if (myGetxController.selectedOrderLineList
                                .contains(orderDetailsList[index]['id']) ==
                            false) {
                          myGetxController.selectedOrderLineList
                              .add(orderDetailsList[index]['id']);
                          List subProductList =
                              orderDetailsList[index]['product_details_ids'];
                          if (subProductList.isNotEmpty) {
                            subProductList.forEach((element) {
                              if (element['product_id']['default_code'] !=
                                  null) {
                                myGetxController.selectedOrderLineSubProductList
                                    .add(element['id']);
                              }
                            });
                          }
                        }
                      },
                      color: Colors.blue),
                ]
              : (orderDetailsList[index]['state'] == "deliver" ||
                          orderDetailsList[index]['state'] == "receive") &&
                      isReceiveScreen == true
                  ? [
                      SwipeAction(
                          title: "Select",
                          onTap: (CompletionHandler handler) async {
                            controller.closeAllOpenCell();
                            getSubProduct(
                                orderDetailsList[index]['is_receive']
                                    .toString(),
                                orderDetailsList[index]['id'],
                                orderDetailsList[index]['product_id']
                                    ['default_code'],
                                orderDetailsList,
                                index,
                                productDetail,
                                context);
                          },
                          color: Colors.blue),
                    ]
                  : (orderDetailsList[index]['state'] != "deliver" &&
                              orderDetailsList[index]['state'] != "receive") &&
                          isOrderScreen == true &&
                          ARChangeProduct == true
                      ? [
                          SwipeAction(
                              onTap: (CompletionHandler handler) async {
                                controller.closeAllOpenCell();
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return ChangeProductDialog(
                                          orderDetailList: orderDetailsList,
                                          productId: orderDetailsList[index]
                                              ['product_id']['id'],
                                          index: index);
                                    });
                              },
                              icon: Icon(
                                Icons.published_with_changes,
                                color: Colors.white,
                                size: 30,
                              ),
                              color: Colors.blue),
                        ]
                      : [],
      leadingActions: isDeliveryScreen == true &&
              orderDetailsList[index]['state'] == "ready"
          ? <SwipeAction>[
              SwipeAction(
                  title: "Deselect",
                  onTap: (CompletionHandler handler) async {
                    controller.closeAllOpenCell();
                    if (myGetxController.selectedOrderLineList
                            .contains(orderDetailsList[index]['id']) ==
                        true) {
                      myGetxController.selectedOrderLineList
                          .remove(orderDetailsList[index]['id']);
                      List subProductList =
                          orderDetailsList[index]['product_details_ids'];
                      if (subProductList.isNotEmpty) {
                        subProductList.forEach((element) {
                          if (myGetxController.selectedOrderLineSubProductList
                                  .contains(element['id']) ==
                              true) {
                            myGetxController.selectedOrderLineSubProductList
                                .remove(element['id']);
                          }
                        });
                      }
                    }
                  },
                  color: Colors.red.shade400),
            ]
          : (orderDetailsList[index]['state'] == "deliver" ||
                      orderDetailsList[index]['state'] == "receive") &&
                  isReceiveScreen == true
              ? [
                  SwipeAction(
                      title: "Deselect",
                      onTap: (CompletionHandler handler) async {
                        controller.closeAllOpenCell();
                        if (myGetxController.receiveSelectedOrderLineList
                                .contains(orderDetailsList[index]['id']) ==
                            true) {
                          myGetxController.receiveSelectedOrderLineList
                              .remove(orderDetailsList[index]['id']);
                          List subProductList =
                              orderDetailsList[index]['product_details_ids'];
                          deSelectSubProduct(subProductList);
                        } else {
                          List subProductList =
                              orderDetailsList[index]['product_details_ids'];
                          deSelectSubProduct(subProductList);
                        }
                      },
                      color: Colors.red.shade400),
                ]
              : [],
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
            color: statusBackGroundColor(orderDetailsList, index),
            border: Border.all(color: Color(0xffE6ECF2), width: 0.7),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isDeliveryScreen == true
                ? Obx(() => myGetxController.selectedOrderLineList
                            .contains(orderDetailsList[index]['id']) ==
                        true
                    ? selectionIndicator()
                    : Container())
                : isReceiveScreen == true
                    ? Obx(() => myGetxController.receiveSelectedOrderLineList
                                    .contains(orderDetailsList[index]['id']) ==
                                true ||
                            orderDetailsList[index]['is_receive'] == true
                        ? selectionIndicator()
                        : Container())
                    : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Code : ",
                      style: allCardMainText,
                    ),
                    Text(
                      orderDetailsList[index]['product_id']['default_code'],
                      style: allCardSubText,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.cyan.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '\u{20B9}${double.parse(orderDetailsList[index]['rent'].toString()).toInt()}',
                    style: TextStyle(
                        color: Colors.cyan.shade700,
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusBackGroundColor(orderDetailsList, index),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    orderDetailsList[index]['state'],
                    style: TextStyle(
                        color: statusColor(orderDetailsList, index),
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Product : ",
                  style: allCardMainText,
                ),
                Flexible(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      orderDetailsList[index]['product_id']['name'],
                      style: allCardSubText,
                    ),
                  ),
                ),
              ],
            ),
            orderDetailsList[index]['remarks'] == null
                ? Container()
                : Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Remark : ",
                            style: allCardMainText,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text(
                                    orderDetailsList[index]['remarks'],
                                    style: remarkTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            SizedBox(
              height: 5,
            ),
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "D. Date : ",
                        style: allCardMainText,
                      ),
                      Text(
                        deliveryDate,
                        style: deliveryDateStyle,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "  R. Date : ",
                        style: allCardMainText,
                      ),
                      Text(
                        returnDate,
                        style: returnDateStyle,
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: productDetail.map((e) {
                  return e['origin_product_id'] ==
                          orderDetailsList[index]['product_id']['id']
                      ? GestureDetector(
                          onDoubleTap: () {
                            orderDetailDialog(
                                context,
                                e['product_id']['default_code'],
                                e['product_type'],
                                e['remarks']);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 5, bottom: 5),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.primaries[
                                      Random().nextInt(Colors.primaries.length)]
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: IntrinsicWidth(
                              child: Column(
                                children: [
                                  Text(
                                    e['product_id']['default_code'],
                                    style: TextStyle(
                                        color: ([...Colors.primaries]
                                              ..shuffle())
                                            .first,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                  isReceiveScreen == true
                                      ? Obx(() => myGetxController
                                                      .receiveSelectedSubProductList
                                                      .contains(e['id']) ==
                                                  true ||
                                              e['is_receive'] == true
                                          ? Container(
                                              height: 3,
                                              color: Colors.blue,
                                            )
                                          : Container())
                                      : Container()
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container();
                }).toList(),
              ),
            ),
            isOrderScreen == true &&
                    orderDetailsList[index]['state'] == "waiting"
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Waiting Reason : ",
                        style: allCardMainText,
                      ),
                      Expanded(
                        child: Text(
                          orderDetailsList[index]['reason'],
                          style: allCardSubText,
                        ),
                      )
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  void getSubProduct(
      String orderLineIsReceive,
      int orderLineId,
      String defaultCode,
      List<dynamic> orderDetailsList,
      int index,
      List<dynamic> productDetail,
      BuildContext context) {
    List<dynamic> subProductList = [];
    productDetail.forEach((element) {
      if (element['origin_product_id'] ==
              orderDetailsList[index]['product_id']['id'] &&
          element['is_receive'] == null) {
        subProductList.add({
          'id': element['id'],
          'default_code': element['product_id']['default_code'],
          'isChecked': false
        });
      }
    });
    if (orderLineIsReceive == "null" || subProductList.isNotEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogSelectSubProduct(
              subProductList: subProductList,
              orderLineId: orderLineId,
              defaultCode: defaultCode,
              orderLineIsReceive: orderLineIsReceive,
            );
          });
    }
  }

  void deSelectSubProduct(List<dynamic> subProductList) {
    if (subProductList.isNotEmpty) {
      subProductList.forEach((element) {
        if (myGetxController.receiveSelectedSubProductList
                .contains(element['id']) ==
            true) {
          myGetxController.receiveSelectedSubProductList.remove(element['id']);
        }
      });
    }
  }
}

selectionIndicator() {
  return Container(
    width: double.infinity,
    height: 3,
    color: Colors.blue.shade400,
    margin: EdgeInsets.only(bottom: 10),
  );
}
