import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Utils/utils.dart';
import '../screen/quatation/edit_order.dart';
import 'constant.dart';

class OrderQuatationCommanCard extends StatelessWidget {
  final List<dynamic> list;
  final Color shadowColor;
  final int index;
  final bool isDeliveryScreen;
  final VoidCallback? onTap;
  final bool isOrderScreen;

  OrderQuatationCommanCard({
    Key? key,
    required this.list,
    required this.shadowColor,
    required this.index,
    required this.isDeliveryScreen,
    this.onTap,
    required this.isOrderScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SwipeActionController controller = SwipeActionController();
    return Builder(builder: (context) {
      return InkWell(
        onTap: onTap,
        child: SwipeActionCell(
          controller: controller,
          key: ObjectKey(list[index]),
          trailingActions: isDeliveryScreen == false && isOrderScreen == false
              ? <SwipeAction>[
                  // SwipeAction(
                  //     title: "Delete",
                  //     onTap: (CompletionHandler handler) async {
                  //       productDeleteDialog(list[index]['id'],index,list,context,true);
                  //       controller.closeAllOpenCell();
                  //     },
                  //     color: Colors.red),
                  SwipeAction(
                      title: "Edit",
                      onTap: (CompletionHandler handler) async {
                        controller.closeAllOpenCell();
                        pushMethod(
                            context,
                            EditOrder(
                              list: list,
                              index: index,
                            ));
                      },
                      closeOnTap: false,
                      color: Colors.blue),
                ]
              : [],
          child: Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            width: double.infinity,
            decoration: BoxDecoration(
                color: statusshadowColor(list, index),
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
                          Text(
                            list[index]['name'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: primaryColor.withOpacity(0.9)),
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: statusshadowColor(list, index),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(list[index]['state'],
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: statusColor(list, index))),
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Customer : ", style: primaryStyle),
                    SizedBox(
                      height: 7,
                    ),
                    Expanded(
                      child: Text(
                        list[index]['customer_name'] ?? "",
                        style: allCardSubText,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 7,
                ),
                Row(
                  children: [
                    Text(
                      list[index]['mobile1'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: primaryColor.withOpacity(0.9)),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                        onTap: () async {
                          // bool? res = await FlutterPhoneDirectCaller.callNumber(
                          //     list[index]['mobile1']);
                          makingPhoneCall(list[index]['mobile1'], context);
                        },
                        child: CircleAvatar(
                            radius: 13,
                            child: Icon(
                              Icons.call,
                              size: 17,
                            ))),
                    list[index]['mobile2'] != null
                        ? Row(
                            children: [
                              Text(" / "),
                              Text(
                                list[index]['mobile2'] ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: primaryColor.withOpacity(0.9)),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                  onTap: () async {
                                    // bool? res = await FlutterPhoneDirectCaller
                                    //     .callNumber(list[index]['mobile2']);
                                    makingPhoneCall(
                                        list[index]['mobile2'], context);
                                  },
                                  child: CircleAvatar(
                                      radius: 13,
                                      child: Icon(
                                        Icons.call,
                                        size: 17,
                                      ))),
                            ],
                          )
                        : Container()
                  ],
                ),
                SizedBox(
                  height: 7,
                ),
                Row(
                  children: [
                    Text(
                      list[index]['user_id']['name'] ?? "",
                      style: allCardMainText,
                    ),
                  ],
                ),
                list[index]['remarks'] == null
                    ? Container()
                    : Column(
                        children: [
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Remarks : ", style: primaryStyle),
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    list[index]['remarks'],
                                    style: remarkTextStyle,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                SizedBox(
                  height: 7,
                ),
                Divider(
                  height: 0.5,
                  color: Colors.grey.shade400,
                ),
                SizedBox(
                  height: 7,
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
                            changeDateFormat(list[index]['delivery_date']),
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
                            changeDateFormat(list[index]['return_date']),
                            style: returnDateStyle,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
