import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Utils/utils.dart';

class ServiceDetailCard extends StatelessWidget {
  final List list;
  final int index;
  final bool? isServiceLineSceen;

  const ServiceDetailCard(
      {Key? key,
      required this.list,
      required this.index,
      this.isServiceLineSceen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xffE6ECF2), width: 0.7),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Product : ",
                style: allCardMainText,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      list[index]['product_id']['default_code'] != null
                          ? Text(
                              "[${list[index]['product_id']['default_code']}] ",
                              style: allCardSubText,
                            )
                          : Container(),
                      Text(
                        list[index]['product_id']['name'],
                        style: allCardSubText,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          isServiceLineSceen == true
              ? Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment:
                          list[index]['service_partner_id']['name'] != null
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.start,
                      children: [
                        list[index]['service_partner_id']['name'] != null
                            ? Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Partner : ",
                                      style: allCardMainText,
                                    ),
                                    Expanded(
                                      child: Text(
                                        list[index]['service_partner_id']['name'],
                                        style: allCardSubText,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        Row(
                          children: [
                            Text(
                              "Charge : ",
                              style: allCardMainText,
                            ),
                            Text(
                              '\u{20B9}${double.parse(list[index]['charge'].toString()).toInt()}',
                              style: allCardSubText,
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                )
              : Container(),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Row(
          //       children: [
          //         Text(
          //           "Quantity : ",
          //           style: allCardMainText,
          //         ),
          //         Text(
          //           '${double.parse(list[index]['quantity'].toString()).toInt()}',
          //           style: allCardSubText,
          //         )
          //       ],
          //     ),
          //     Row(
          //       children: [
          //         Text(
          //           "Receive Qty : ",
          //           style: allCardMainText,
          //         ),
          //         Text(
          //           '${double.parse(list[index]['receive_qty'].toString()).toInt()}',
          //           style: allCardSubText,
          //         )
          //       ],
          //     )
          //   ],
          // ),
          isServiceLineSceen == false
              ? Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Charge : ",
                          style: allCardMainText,
                        ),
                        Text(
                          '\u{20B9}${double.parse(list[index]['charge'].toString()).toInt()}',
                          style: allCardSubText,
                        )
                      ],
                    ),
                  ],
                )
              : Container(),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: list[index]['in_date'] != null
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: [
              list[index]['in_date'] != null
                  ? Row(
                      children: [
                        Text(
                          "Send : ",
                          style: allCardMainText,
                        ),
                        Text(
                          DateFormat("dd/MM/yyyy").format(
                                  DateTime.parse(list[index]['in_date'])) ??
                              "",
                          style: deliveryDateStyle,
                        )
                      ],
                    )
                  : Container(),
              isServiceLineSceen == false
                  ? list[index]['out_date'] != null
                      ? Row(
                          children: [
                            Text(
                              "Receive : ",
                              style: allCardMainText,
                            ),
                            Text(
                              DateFormat("dd/MM/yyyy").format(
                                  DateTime.parse(list[index]['out_date'])),
                              style: returnDateStyle,
                            )
                          ],
                        )
                      : Container()
                  : list[index]['service_type'] != null
                      ? Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            list[index]['service_type'],
                            style: deliveryDateStyle,
                          ),
                        )
                      : Container()
            ],
          ),
        ],
      ),
    );
  }
}
