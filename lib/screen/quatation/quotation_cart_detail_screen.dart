import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:gj5_rental/screen/booking%20status/booking_status.dart';
import 'package:gj5_rental/screen/quatation/quotation_cart_add_product.dart';
import 'package:intl/intl.dart';

import '../../constant/constant.dart';
import '../../getx/getx_controller.dart';

class QuotationCartDetail extends StatefulWidget {
  final int? index;
  final String? cartOwnerName;

  const QuotationCartDetail({Key? key, this.index, this.cartOwnerName})
      : super(key: key);

  @override
  State<QuotationCartDetail> createState() => _QuotationCartDetailState();
}

class _QuotationCartDetailState extends State<QuotationCartDetail> {
  MyGetxController myGetxController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FadeInRight(
            child: FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {},
              child: Icon(
                Icons.delete,
                size: 30,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          FadeInRight(
            child: FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                pushMethod(context, QuotatiopnCartAddProduct(index: widget.index,));
                // showAddProductDialog();
              },
              child: Icon(
                Icons.add,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 10,
            ),
            ScreenAppBar(screenName: "Order Detail cart Screen"),
            SizedBox(
              height: 15,
            ),
            cartCard(myGetxController.quotationCartList, widget.index ?? 0,
                widget.cartOwnerName ?? "", Colors.grey.withOpacity(0.1))
          ],
        ),
      ),
    );
  }

}
