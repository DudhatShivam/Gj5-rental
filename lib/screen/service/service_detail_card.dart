import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:gj5_rental/screen/service/receive_service/receive_service_line.dart';
import 'package:intl/intl.dart';

import '../../Utils/utils.dart';

class ServiceDetailCard extends StatelessWidget {
  final List list;
  final int index;
  final bool? isServiceLineSceen;
  final bool isFromNotificationScreen;

  const ServiceDetailCard(
      {Key? key,
      required this.list,
      required this.index,
      this.isServiceLineSceen,
      required this.isFromNotificationScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SwipeActionController controller = SwipeActionController();

    return SwipeActionCell(
      controller: controller,
      key: ObjectKey(list[index]),
      trailingActions: isFromNotificationScreen == false
          ? [
              SwipeAction(
                  title: "Receive",
                  onTap: (CompletionHandler handler) async {
                    controller.closeAllOpenCell();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return ReceiveServiceLine(
                            list: list,
                            index: index,
                          );
                        });
                  },
                  closeOnTap: false,
                  color: Colors.blue)
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
                ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Partner : ",
                                        style: allCardMainText,
                                      ),
                                      Expanded(
                                        child: Text(
                                          list[index]['service_partner_id']
                                              ['name'],
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
            list[index]['remark'] != null
                ? Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Remark : ",
                            style: allCardMainText,
                          ),
                          Text(
                            list[index]['remark'],
                            style: remarkTextStyle,
                          )
                        ],
                      ),
                    ],
                  )
                : Container(),
            Row(
              mainAxisAlignment: list[index]['in_date'] != null
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.start,
              children: [
                list[index]['in_date'] != null
                    ? Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Send : ",
                                style: allCardMainText,
                              ),
                              Text(
                                DateFormat("dd/MM/yyyy").format(DateTime.parse(
                                        list[index]['in_date'])) ??
                                    "",
                                style: deliveryDateStyle,
                              )
                            ],
                          ),
                        ],
                      )
                    : Container(),
                isServiceLineSceen == false
                    ? list[index]['out_date'] != null
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Receive : ",
                                    style: allCardMainText,
                                  ),
                                  Text(
                                    DateFormat("dd/MM/yyyy").format(
                                        DateTime.parse(
                                            list[index]['out_date'])),
                                    style: returnDateStyle,
                                  )
                                ],
                              ),
                            ],
                          )
                        : Container()
                    : list[index]['service_type'] != null
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      list[index]['service_type'] == 'washing'
                                          ? successColor.withOpacity(0.2)
                                          : stitchingColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  list[index]['service_type'],
                                  style: TextStyle(
                                      color: list[index]['service_type'] ==
                                              'washing'
                                          ? successColor
                                          : stitchingColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                ),
                              ),
                            ],
                          )
                        : Container()
              ],
            ),
            Row(
              mainAxisAlignment: list[index]['delivery_date'] != null
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.start,
              children: [
                list[index]['delivery_date'] != null
                    ? Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "D Date : ",
                                style: allCardMainText,
                              ),
                              Text(
                                DateFormat("dd/MM/yyyy").format(DateTime.parse(
                                        list[index]['delivery_date'])) ??
                                    "",
                                style: deliveryDateStyle,
                              )
                            ],
                          ),
                        ],
                      )
                    : Container(),
                list[index]['return_date'] != null
                    ? Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "R Date : ",
                                style: allCardMainText,
                              ),
                              Text(
                                DateFormat("dd/MM/yyyy").format(
                                    DateTime.parse(list[index]['return_date'])),
                                style: returnDateStyle,
                              )
                            ],
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
