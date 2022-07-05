import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Utils/utils.dart';

class ServiceDetailCard extends StatelessWidget {
  final List list;
  final int index;

  const ServiceDetailCard({Key? key, required this.list, required this.index})
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
                      Text(
                        "[${list[index]['product_id']['default_code']}] ",
                        style: allCardSubText,
                      ),
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
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Quantity : ",
                    style: allCardMainText,
                  ),
                  Text(
                    '${double.parse(list[index]['quantity'].toString()).toInt()}',
                    style: allCardSubText,
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Receive Qty : ",
                    style: allCardMainText,
                  ),
                  Text(
                    '${double.parse(list[index]['receive_qty'].toString()).toInt()}',
                    style: allCardSubText,
                  )
                ],
              )
            ],
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
                    "Charge : ",
                    style: allCardMainText,
                  ),
                  Text(
                    '\u{20B9}${double.parse(list[index]['charge'].toString()).toInt()}',
                    style: allCardSubText,
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Amount : ",
                    style: allCardMainText,
                  ),
                  Text(
                    '\u{20B9}${double.parse(list[index]['amount'].toString()).toInt()}',
                    style: allCardSubText,
                  )
                ],
              )
            ],
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
              Row(
                children: [
                  Text(
                    "Receive : ",
                    style: allCardMainText,
                  ),
                  Text(
                    DateFormat("dd/MM/yyyy")
                            .format(DateTime.parse(list[index]['out_date'])) ??
                        "",
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
