import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:intl/intl.dart';

import '../../constant/constant.dart';

class ServiceCard extends StatelessWidget {
  final List<dynamic> list;
  final VoidCallback? onTap;
  final int index;
  final Color shadowColor;

  const ServiceCard(
      {Key? key,
      required this.list,
      this.onTap,
      required this.index,
      required this.shadowColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        width: double.infinity,
        decoration: BoxDecoration(
            color: shadowColor,
            border: Border.all(color: Color(0xffE6ECF2), width: 0.7),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  list[index]['name'],
                  style: allCardSubText,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.cyan.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '\u{20B9}${double.parse(list[index]['charge'].toString()).toInt()}',
                    style: TextStyle(
                        color: Colors.cyan.shade700,
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: list[index]['service_type'] == 'washing'
                        ? successColor.withOpacity(0.2)
                        : stitchingColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    list[index]['service_type'],
                    style: TextStyle(
                        color: list[index]['service_type'] == 'washing'
                            ? successColor
                            : stitchingColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 7,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Partner : ",
                  style: allCardMainText,
                ),
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      list[index]['service_partner_id']['name'] ?? "",
                      style: allCardSubText,
                    ),
                  ),
                ),
              ],
            ),
            list[index]['remarks'] != null
                ? Column(
                    children: [
                      SizedBox(
                        height: 7,
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
                                    list[index]['remarks'],
                                    style: allCardSubText,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container(),
            SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                list[index]['in_date'] != null
                    ? Row(
                        children: [
                          Text(
                            "Send : ",
                            style: allCardMainText,
                          ),
                          Text(
                            changeDateFormat(list[index]['in_date']),
                            style: deliveryDateStyle,
                          )
                        ],
                      )
                    : Container(),
                list[index]['out_date'] != null
                    ? Row(
                        children: [
                          Text(
                            "Receive : ",
                            style: allCardMainText,
                          ),
                          Text(
                            changeDateFormat(list[index]['out_date']),
                            style: returnDateStyle,
                          )
                        ],
                      )
                    : Container()
              ],
            ),
            SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                list[index]['delivery_date'] != null
                    ? Expanded(
                        child: FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "D. Date : ",
                                style: allCardMainText,
                                maxLines: 1,
                              ),
                              Text(
                                changeDateFormat(list[index]['delivery_date']),
                                style: deliveryDateStyle,
                                maxLines: 1,
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(),
                list[index]['return_date'] != null
                    ? Expanded(
                        child: FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "  R. Date : ",
                                style: allCardMainText,
                                maxLines: 1,
                              ),
                              Text(
                                changeDateFormat(list[index]['return_date']),
                                style: returnDateStyle,
                                maxLines: 1,
                              )
                            ],
                          ),
                        ),
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
