import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Utils/utils.dart';
import '../screen/quatation/edit_order.dart';
import '../screen/quatation/edit_order_line.dart';
import '../screen/quatation/quotation_const/quotation_constant.dart';
import 'constant.dart';

class OrderQuatationCommanCard extends StatelessWidget {
  final List<dynamic> list;
  final Color backGroundColor;
  final int index;
  final bool isDeliveryScreen;
  final VoidCallback? onTap;
  final bool isOrderScreen;

  OrderQuatationCommanCard({
    Key? key,
    required this.list,
    required this.backGroundColor,
    required this.index,
    required this.isDeliveryScreen,
    this.onTap,
    required this.isOrderScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SwipeActionController controller = SwipeActionController();
    String deliveryDate = DateFormat("dd/MM/yyyy")
        .format(DateTime.parse(list[index]['delivery_date']));
    String returnDate = DateFormat("dd/MM/yyyy")
        .format(DateTime.parse(list[index]['return_date']));
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
                                name: list[index]['customer_name'],
                                number: list[index]['mobile1'],
                                deliveryDate: deliveryDate,
                                returnDate: returnDate,
                                remarks: list[index]['remarks'],
                                index: index,
                                id: list[index]['id'].toString()));
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
                color:statusBackGroundColor(list, index) ,
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
                        color: statusBackGroundColor(list, index),
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
                          _makingPhoneCall(list[index]['mobile1'], context);
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
                                    _makingPhoneCall(
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
                      list[index]['user_id']['name'],
                      style: allCardSubText,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "D. Date : ",
                          style: primaryStyle,
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
        ),
      );
    });
  }
}

_makingPhoneCall(String PhoneNumber, BuildContext context) async {
  print(PhoneNumber);
  try {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: PhoneNumber,
    );
    await launchUrl(launchUri);
  } catch (e) {
    dialog(context, e.toString(), Colors.red.shade300);
  }
}
