import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/cancel_order/cancel_order.dart';
import 'package:http/http.dart' as http;

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../Order_line/orderline_constant/order_line_card.dart';
import '../booking status/booking_status.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  ScrollController scrollController = ScrollController();
  bool noData = false;

  @override
  void initState() {
    super.initState();
    productDetailOffset = 0;
    myGetxController.productDetailList.clear();
    checkWifiForProductDetailData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        productDetailOffset = productDetailOffset + 10;
        checkWifiForProductDetailData();
      }
    });
  }

  MyGetxController myGetxController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          allScreenInitialSizedBox(context),
          ScreenAppBar(
            screenName: "Product Detail",
          ),
          Expanded(
            child: Obx(() => myGetxController.productDetailList.isNotEmpty
                ? ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: myGetxController.productDetailList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return OrderLineCard(
                        orderList: myGetxController.productDetailList,
                        productList: myGetxController.productDetailList,
                        index: index,
                        isProductDetailScreen: true,
                        ARManager: false,
                        ARService: false,
                      );
                    })
                : noData == false
                    ? CenterCircularProgressIndicator()
                    : centerNoOrderText("No Data Found")),
          ),
        ],
      ),
    );
  }

  Future<void> checkWifiForProductDetailData() async {
    String apiUrl = await getStringPreference('apiUrl');
    String accessToken = await getStringPreference('accessToken');
    try {
      if (apiUrl.toString().startsWith("192")) {
        showConnectivity().then((result) async {
          if (result == ConnectivityResult.wifi) {
            getProductDetail(apiUrl, accessToken);
          } else {
            dialog(context, "Connect to Showroom Network", Colors.red.shade300);
          }
        });
      } else {
        getProductDetail(apiUrl, accessToken);
      }
    } on SocketException catch (err) {
      dialog(context, "Connect to Showroom Network", Colors.red.shade300);
    }
  }

  Future<void> getProductDetail(String apiUrl, String accessToken) async {
    String dayBefore = get5daysBeforeDate();
    String dayAfter = get7DaysAfterDate();
    String domain =
        "[('state' , 'not in' , ('draft','cancel','done')),('delivery_date' , '>=' , '$dayBefore') , ('delivery_date' , '<=' , '$dayAfter')]";
    var params = {
      'filters': domain.toString(),
      'limit': '10',
      'offset': '$productDetailOffset',
      'order': 'id desc'
    };
    Uri uri = Uri.parse("http://$apiUrl/api/product.details");
    final finalUri = uri.replace(queryParameters: params);
    final response =
        await http.get(finalUri, headers: {'Access-Token': accessToken});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['count'] > 0) {
        myGetxController.productDetailList.addAll(data['results']);
      } else {
        if (myGetxController.productDetailList.isEmpty) {
          setState(() {
            noData = true;
          });
        }
      }
    } else {
      dialog(context, "Something Went Wrong !", Colors.red.shade300);
    }
  }
}
