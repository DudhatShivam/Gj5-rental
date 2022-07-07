import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:gj5_rental/constant/constant.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/quatation/quotation_cart_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuotationCart extends StatefulWidget {
  const QuotationCart({Key? key}) : super(key: key);

  @override
  State<QuotationCart> createState() => _QuotationCartState();
}

class _QuotationCartState extends State<QuotationCart> {
  MyGetxController myGetxController = Get.find();
  String? cartOwnerName = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 10,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: FadeInLeft(
                    child: Icon(
                      Icons.arrow_back,
                      color: primary2Color,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                FadeInLeft(
                  child: Text(
                    "Quotation Cart",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 23,
                        color: primary2Color),
                  ),
                ),
              ],
            ),
            Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.only(top: 20),
                    itemCount: myGetxController.quotationCartList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            pushMethod(
                                context,
                                QuotationCartDetail(
                                  index: index,
                                  cartOwnerName: cartOwnerName,
                                ));
                          },
                          child: cartCard(myGetxController.quotationCartList,
                              index, cartOwnerName ?? "",Colors.white));
                    }))
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      cartOwnerName = preferences.getString('name');
    });
  }
}
