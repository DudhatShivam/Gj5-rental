import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/constant/order_quotation_detail_card.dart';
import 'package:intl/intl.dart';

import '../Utils/utils.dart';
import '../getx/getx_controller.dart';
import 'constant.dart';

class ExtraProductCard extends StatelessWidget {
  final List extraProductList;
  final int index;
  final bool? isDeliveryScreen;
  final bool? isReceiveScreen;

  ExtraProductCard(
      {Key? key,
      required this.extraProductList,
      required this.index,
      this.isDeliveryScreen,
      this.isReceiveScreen})
      : super(key: key);
  MyGetxController myGetxController = Get.find();

  @override
  Widget build(BuildContext context) {
    SwipeActionController controller = SwipeActionController();
    String deliveryDate = DateFormat(passApiGlobalDateFormat)
        .format(DateTime.parse(extraProductList[index]['delivery_date']));
    String returnDate = DateFormat(passApiGlobalDateFormat)
        .format(DateTime.parse(extraProductList[index]['return_date']));
    return SwipeActionCell(
      controller: controller,
      key: ObjectKey(extraProductList[index]),
      trailingActions: isDeliveryScreen == true || isReceiveScreen == true
          ? [
              SwipeAction(
                  title: "Select",
                  onTap: (CompletionHandler handler) async {
                    controller.closeAllOpenCell();
                    if (isReceiveScreen == true) {
                      if (myGetxController.receiveSelectedExtraProductList
                              .contains(extraProductList[index]['id']) ==
                          false) {
                        myGetxController.receiveSelectedExtraProductList
                            .add(extraProductList[index]['id']);
                      }
                    } else {
                      if (myGetxController.deliverySelectedExtraProductList
                              .contains(extraProductList[index]['id']) ==
                          false) {
                        myGetxController.deliverySelectedExtraProductList
                            .add(extraProductList[index]['id']);
                      }
                    }
                  },
                  color: Colors.blue),
            ]
          : [],
      leadingActions: isDeliveryScreen == true || isReceiveScreen == true
          ? [
              SwipeAction(
                  title: "Deselect",
                  onTap: (CompletionHandler handler) async {
                    controller.closeAllOpenCell();
                    if (isDeliveryScreen == true) {
                      if (myGetxController.deliverySelectedExtraProductList
                              .contains(extraProductList[index]['id']) ==
                          true) {
                        myGetxController.deliverySelectedExtraProductList
                            .remove(extraProductList[index]['id']);
                      }
                    } else {
                      if (myGetxController.receiveSelectedExtraProductList
                              .contains(extraProductList[index]['id']) ==
                          true) {
                        myGetxController.receiveSelectedExtraProductList
                            .remove(extraProductList[index]['id']);
                      }
                    }
                  },
                  color: Colors.red.shade400),
            ]
          : [],
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xffE6ECF2), width: 0.7),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isDeliveryScreen == true
                ? Obx(() => myGetxController.deliverySelectedExtraProductList
                            .contains(extraProductList[index]['id']) ==
                        true
                    ? selectionIndicator()
                    : Container())
                : isReceiveScreen == true
                    ? Obx(() => myGetxController.receiveSelectedExtraProductList
                                    .contains(extraProductList[index]['id']) ==
                                true ||
                            extraProductList[index]['is_receive'] == true
                        ? selectionIndicator()
                        : Container())
                    : Container(),
            Row(
              children: [
                Text("Name : ", style: primaryStyle),
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      extraProductList[index]['product_id']['display_name'],
                      style: allCardSubText,
                    ),
                  ),
                ),
              ],
            ),
            extraProductList[index]['remarks'] == null
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
                            style: remarkTextStyle,
                          ),
                          Expanded(
                            child: Text(
                              extraProductList[index]['remarks'],
                              style: allCardSubText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                height: 0.5,
                color: Colors.grey.shade400,
              ),
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
                    Text(deliveryDate, style: deliveryDateStyle),
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
                      style: returnDateStyle,
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
