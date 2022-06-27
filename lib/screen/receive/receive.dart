import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:http/http.dart' as http;
import '../../Utils/utils.dart';
import '../Order_line/orderline_constant/order_line_card.dart';

class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({Key? key}) : super(key: key);

  @override
  State<ReceiveScreen> createState() => _RceiveScreenState();
}

class _RceiveScreenState extends State<ReceiveScreen> {
  MyGetxController myGetxController = Get.find();
  String? gender;
  String? selectedValue;
  List lst = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("coming soon",style: primaryStyle,),
      ),
    );
  }

}
