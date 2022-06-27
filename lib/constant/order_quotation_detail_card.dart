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
import '../screen/quatation/edit_order_line.dart';
import '../screen/quatation/quotation_const/quotation_constant.dart';
import 'constant.dart';

class OrderQuotationDetailCard extends StatelessWidget {
  final List<dynamic> orderDetailsList;
  final int index;
  final List productDetail;
  final bool isOrderScreen;
  final int orderId;
  final bool isDeliveryScreen;

  OrderQuotationDetailCard({
    Key? key,
    required this.orderDetailsList,
    required this.index,
    required this.productDetail,
    required this.isOrderScreen,
    required this.orderId,
    required this.isDeliveryScreen,
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
      trailingActions: isDeliveryScreen == false && isOrderScreen == false
          ? <SwipeAction>[
              SwipeAction(
                  title: "Delete",
                  onTap: (CompletionHandler handler) async {
                    controller.closeAllOpenCell();
                    productDeleteDialog(orderDetailsList[index]['id'], index,
                        orderDetailsList, context,false);
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
                            lineId: orderDetailsList[index]['id'],
                            deliveryDate: orderDetailsList[index]
                                ['delivery_date'],
                            returnDate: orderDetailsList[index]['return_date'],
                            remark: orderDetailsList[index]['remarks'],
                            wholeSubProductList: value,
                            productName: orderDetailsList[index]['product_id']
                                ['name'],
                            productCode: orderDetailsList[index]['product_id']
                                ['default_code'],
                          ));
                    });
                  },
                  closeOnTap: false,
                  color: Colors.blue),
            ]
          : orderDetailsList[index]['state'] == "ready" && isOrderScreen == false && isDeliveryScreen == true
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
                        }
                        print(myGetxController.selectedOrderLineList);
                      },
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
                    }
                    print(myGetxController.selectedOrderLineList);
                  },
                  color: Colors.red.shade400),
            ]
          : [],
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
            color: orderDetailsList[index]['state'] == "ready"
                ? Colors.green.shade100.withOpacity(0.5)
                : orderDetailsList[index]['state'] == "waiting"
                    ? Colors.deepOrange.shade100.withOpacity(0.5)
                    : Colors.white,
            border: Border.all(color: Color(0xffE6ECF2), width: 0.7),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isDeliveryScreen == true
                ? Obx(() => myGetxController.selectedOrderLineList
                            .contains(orderDetailsList[index]['id']) ==
                        true
                    ? Container(
                        width: double.infinity,
                        height: 3,
                        color: Colors.blue.shade400,
                        margin: EdgeInsets.only(bottom: 10),
                      )
                    : Container())
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Code : ",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600),
                    ),
                    Text(
                      orderDetailsList[index]['product_id']['default_code'],
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    orderDetailsList[index]['state'],
                    style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
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
                Text(
                  "Product : ",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600),
                ),
                Expanded(
                  child: Text(
                    orderDetailsList[index]['product_id']['name'],
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
            orderDetailsList[index]['remarks'] == null
                ? Container()
                : Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Remark : ",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600),
                          ),
                          Expanded(
                            child: Text(
                              orderDetailsList[index]['remarks'],
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
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
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600),
                    ),
                    Text(
                      deliveryDate,
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
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600),
                    ),
                    Text(
                      returnDate,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.red),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
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
                            height: 40,
                            margin: EdgeInsets.only(right: 5, bottom: 5),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.primaries[
                                      Random().nextInt(Colors.primaries.length)]
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              e['product_id']['default_code'],
                              style: TextStyle(
                                  color:
                                      ([...Colors.primaries]..shuffle()).first,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
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
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600),
                      ),
                      Expanded(
                        child: Text(
                          orderDetailsList[index]['reason'],
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
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
}
