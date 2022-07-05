import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:intl/intl.dart';

class ServiceCard extends StatelessWidget {
  final List<dynamic> list;
  final VoidCallback? onTap;
  final int index;
  final Color backGroundColor;

  const ServiceCard(
      {Key? key,
      required this.list,
      this.onTap,
      required this.index,
      required this.backGroundColor})
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
            color: backGroundColor,
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
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    list[index]['service_type'],
                    style: TextStyle(
                        color: Colors.green.shade700,
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
                      list[index]['service_partner_id']['name'],
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
                list[index]['delivery_date'] != null
                    ? Row(
                        children: [
                          Text(
                            "D. Date : ",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600),
                          ),
                          Text(
                            DateFormat("dd/MM/yyyy").format(
                                DateTime.parse(list[index]['delivery_date'])),
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.green),
                          )
                        ],
                      )
                    : Container(),
                list[index]['return_date'] != null
                    ? Row(
                        children: [
                          Text(
                            "R. Date : ",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600),
                          ),
                          Text(
                            DateFormat("dd/MM/yyyy").format(
                                DateTime.parse(list[index]['return_date'])),
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.red),
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
                Row(
                  children: [
                    Text(
                      "Send : ",
                      style: allCardMainText,
                    ),
                    Text(
                      DateFormat("dd/MM/yyyy")
                              .format(DateTime.parse(list[index]['in_date'])) ??
                          "",
                      style: deliveryDateStyle,
                    )
                  ],
                ),
                // Row(
                //   children: [
                //     Text(
                //       "Receive : ",
                //       style: allCardMainText,
                //     ),
                //     Text(
                //       DateFormat("dd/MM/yyyy")
                //           .format(DateTime.parse(list[index]['out_date'])),
                //       style: returnDateStyle,
                //     )
                //   ],
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
