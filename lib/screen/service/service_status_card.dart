import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Utils/utils.dart';

class ServiceStatusCard extends StatelessWidget {
  final List<dynamic> list;
  final int index;

  const ServiceStatusCard({Key? key, required this.list, required this.index})
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              list[index]['bill_no'] != null
                  ? Text(
                      list[index]['bill_no'].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: primaryColor.withOpacity(0.9)),
                    )
                  : Container(),
              list[index]['service_no'] != null
                  ? Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        list[index]['service_no'],
                        style: deliveryDateStyle,
                      ),
                    )
                  : Container(),
              list[index]['service_type'] != null
                  ? Container(
                      alignment: Alignment.center,
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
                    )
                  : Container()
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
                    list[index]['service_partner'] ?? "",
                    style: allCardSubText,
                  ),
                ),
              ),
            ],
          ),
          list[index]['in_date'] != null
              ? Column(
                  children: [
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        Text(
                          "Send : ",
                          style: allCardMainText,
                        ),
                        Text(
                          list[index]['send_date'],
                          style: deliveryDateStyle,
                        )
                      ],
                    ),
                  ],
                )
              : Container(),
          list[index]['delivery_date'] != "" && list[index]['return_date'] != ""
              ? Column(
                  children: [
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
                              style: allCardMainText,
                            ),
                            Text(
                              list[index]['delivery_date'],
                              style: deliveryDateStyle,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "R. Date : ",
                              style: allCardMainText,
                            ),
                            Text(
                              list[index]['return_date'],
                              style: returnDateStyle,
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                )
              : Container()
        ],
      ),
    );
  }
}
