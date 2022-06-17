import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Utils/utils.dart';
import 'constant.dart';

class OrderLineCard extends StatelessWidget {
  final List<dynamic> orderList;
  final List<dynamic> productList;
  final int index;

  OrderLineCard(
      {Key? key,
      required this.orderList,
      required this.productList,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String deliveryDate = DateFormat("dd/MM/yyyy")
        .format(DateTime.parse(orderList[index]['delivery_date']));
    String returnDate = DateFormat("dd/MM/yyyy")
        .format(DateTime.parse(orderList[index]['return_date']));
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
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
                      orderList[index]['rental_id']['name'] ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: primaryColor.withOpacity(0.9)),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  orderList[index]['state'],
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text("Code : ", style: primaryStyle),
              Expanded(
                child: Text(
                  orderList[index]['product_id']['default_code'],
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
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
              Text("Product : ", style: primaryStyle),
              Expanded(
                child: Text(
                  orderList[index]['product_id']['name'],
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text("Customer : ", style: primaryStyle),
              Expanded(
                child: Text(
                  orderList[index]['partner_id']['name'],
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          orderList[index]['remarks'] != null
              ? Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Text("Remarks : ", style: primaryStyle),
                      Expanded(
                        child: Text(
                          orderList[index]['remarks'],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          orderList[index]['waiting_reason'] != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Text("Waiting reason : ", style: primaryStyle),
                      Expanded(
                        child: Text(
                          orderList[index]['waiting_reason'],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          Divider(
            height: 0.5,
            color: Colors.grey.shade400,
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
                    style: primaryStyle,
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
                    style: primaryStyle,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: productList.map((e) {
                return e['origin_product_id'] ==
                        orderList[index]['product_id']['id']
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
                                color: ([...Colors.primaries]..shuffle()).first,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                        ),
                      )
                    : Container();
              }).toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                      orderList[index]['state'] != "deliver" &&
                      orderList[index]['state'] != "receive" &&
                      orderList[index]['state'] != "cancel"
                  ? InkWell(
                      onTap: () {
                      },
                      child: Icon(
                        Icons.settings,
                        size: 28,
                      ),
                    )
                  : Container(),
              SizedBox(
                width: 10,
              ),
              orderList[index]['state'] != "waiting" &&
                      orderList[index]['state'] != "deliver" &&
                      orderList[index]['state'] != "receive" &&
                      orderList[index]['state'] != "cancel"
                  ? InkWell(
                      onTap: () {
                        // popUpForWaitingThumbInOrderScreen(
                        //     context,
                        //     orderList[index]['id'],
                        //     orderId,
                        //     orderList[index]['product_id']
                        //     ['default_code'],
                        //     orderList[index]['product_id']
                        //     ['name']);
                      },
                      child: Icon(
                        Icons.lock_clock,
                        size: 28,
                      ),
                    )
                  : Container(),
              SizedBox(
                width: 10,
              ),
              orderList[index]['state'] != "ready" &&
                      orderList[index]['state'] != "deliver" &&
                      orderList[index]['state'] != "receive" &&
                      orderList[index]['state'] != "cancel"
                  ? InkWell(
                      onTap: () {
                        checkWlanForConfirmOrderThumbAndWaiting(
                            orderList[index]['rental_id']['id'],
                            orderList[index]['id'],
                            context,
                            true,
                            "",
                            "",
                            orderList[index]['product_id']
                                ['default_code'],
                            orderList[index]['product_id']['name']);
                      },
                      child: Icon(
                        Icons.thumb_up_alt_rounded,
                        size: 28,
                      ),
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }
}
