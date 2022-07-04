import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/utils.dart';

Future<void> checkQuotationAndOrderDetailData(
    BuildContext context, int orderId, bool isOrderScreenData) async {
  getStringPreference('apiUrl').then((apiUrl) async {
    try {
      getStringPreference('accessToken').then((token) async {
        if (apiUrl.toString().startsWith("192")) {
          showConnectivity().then((result) async {
            if (result == ConnectivityResult.wifi) {
              await getQuotationAndOrderDetailOrderData(apiUrl, token, orderId);
            } else {
              dialog(
                  context, "Connect to Showroom Network", Colors.red.shade300);
            }
          });
        } else {
          await getQuotationAndOrderDetailOrderData(apiUrl, token, orderId);
        }
      });
    } on SocketException catch (err) {
      dialog(context, "Connect to Showroom Network", Colors.red.shade300);
    }
  });
}

Future<void> getQuotationAndOrderDetailOrderData(
  String apiUrl,
  String token,
  int? id,
) async {
  MyGetxController myGetxController = Get.put(MyGetxController());
  final response = await http.get(
      Uri.parse("http://$apiUrl/api/rental.rental/$id"),
      headers: {'Access-Token': token, 'Content-Type': 'application/http'});
  Map data = jsonDecode(response.body);

  myGetxController.quotationOrder.clear();
  myGetxController.quotationDetailOrderList.clear();
  myGetxController.quotationOrder.add(data);
  myGetxController.quotationDetailOrderList.value = data['line_ids'];
  await checkForProductDetail();
}

checkForProductDetail() {
  MyGetxController myGetxController = Get.put(MyGetxController());
  myGetxController.quotationDetailProductDetailList.clear();
  myGetxController.quotationDetailOrderList.forEach((element) {
    if (element['product_details_ids'] != []) {
      List<dynamic> data = element['product_details_ids'];
      data.forEach((value) {
        if (value['product_id']['default_code'] != null) {
          myGetxController.quotationDetailProductDetailList.add(value);
        }
      });
    }
  });
}

Future<List> addWholeSubProductInList(int lineId) async {
  List<dynamic> lst = [];
  String apiUrl = await getStringPreference('apiUrl');
  String accessToken = await getStringPreference('accessToken');
  final response = await http
      .get(Uri.parse("http://$apiUrl/api/rental.line/$lineId"), headers: {
    'Access-Token': accessToken,
  });
  var data = await jsonDecode(response.body);
  if (data != []) {
    lst.addAll(data['product_details_ids']);
  }
  return lst;
}
