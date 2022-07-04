import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gj5_rental/Utils/utils.dart';

class ServiceDetailCard extends StatefulWidget {
  const ServiceDetailCard({Key? key}) : super(key: key);

  @override
  State<ServiceDetailCard> createState() => _ServiceDetailCardState();
}

class _ServiceDetailCardState extends State<ServiceDetailCard> {
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
                        "[ CH-67 ] ",
                        style: allCardSubText,
                      ),
                      Text(
                        "Zery Green Color Hathivalu Work",
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
                    "1",
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
                    "2",
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
                    "200",
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
                    "100",
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
                    "D. Date : ",
                    style: allCardMainText,
                  ),
                  Text(
                    "deliveryDate",
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
                    "returnDate",
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
