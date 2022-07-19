import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Utils/utils.dart';

class ExtraProductCard extends StatelessWidget {
  final List extraProductList;
  final int index;

  const ExtraProductCard(
      {Key? key, required this.extraProductList, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String deliveryDate = DateFormat("dd/MM/yyyy")
        .format(DateTime.parse(extraProductList[index]['delivery_date']));
    String returnDate = DateFormat("dd/MM/yyyy")
        .format(DateTime.parse(extraProductList[index]['return_date']));
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
            children: [
              Text("Name : ", style: primaryStyle),
              Text(
                "[KALGI] Safa Ni Kalgi",
                style: allCardSubText,
              ),
            ],
          ),
          extraProductList[index]['remarks'] == null
              ? Container()
              : Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Remark : ",
                          style: remarkTextStyle,
                        ),
                        Expanded(
                          child: Text(
                            extraProductList[index]['remarks'],
                            style: allCardSubText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              height: 0.5,
              color: Colors.grey.shade400,
            ),
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
                  Text(deliveryDate, style: deliveryDateStyle),
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
