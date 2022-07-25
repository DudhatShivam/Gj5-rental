import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Utils/utils.dart';
import 'constant.dart';

class ExtraProductScreenCard extends StatelessWidget {
  final List extraProductList;
  final int index;

  const ExtraProductScreenCard(
      {Key? key, required this.extraProductList, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String deliveryDate = DateFormat("dd/MM/yyyy")
        .format(DateTime.parse(extraProductList[index]['delivery_date']));
    String returnDate = DateFormat("dd/MM/yyyy")
        .format(DateTime.parse(extraProductList[index]['return_date']));
    return Container(
      padding: EdgeInsets.all(getWidth(0.01, context)),
      margin: EdgeInsets.symmetric(
          horizontal: getWidth(0.018, context), vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(
          color: statusBackGroundColor(extraProductList, index),
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
                      extraProductList[index]['rental_id']['name'],
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
                  color: statusBackGroundColor(extraProductList, index),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(extraProductList[index]['state'],
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: statusColor(extraProductList, index))),
              )
            ],
          ),
          SizedBox(
            height: 7,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Product : ", style: primaryStyle),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        "[${extraProductList[index]['product_id']['default_code']}] ",
                        style: allCardSubText,
                      ),
                      Text(
                        extraProductList[index]['product_id']['name'],
                        style: allCardSubText,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          extraProductList[index]['origin_product_id']['id'] != null
              ? Column(
                  children: [
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Origin Product : ", style: primaryStyle),
                        Text(
                          "[${extraProductList[index]['origin_product_id']['default_code'] ?? ""}] "
                          "",
                          style: allCardSubText,
                        ),
                        Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              extraProductList[index]['origin_product_id']
                                      ['name'] ??
                                  "",
                              style: allCardSubText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Container(),
          extraProductList[index]['remarks'] == null
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
                              extraProductList[index]['remarks'],
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
    );
  }
}
