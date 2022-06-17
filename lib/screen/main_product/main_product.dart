import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/booking%20status/booking_status.dart';
import 'package:gj5_rental/screen/main_product/main_product_detail_screen.dart';
import 'package:http/http.dart' as http;

class MainProductScreen extends StatefulWidget {
  const MainProductScreen({Key? key}) : super(key: key);

  @override
  State<MainProductScreen> createState() => _MainProductScreenState();
}

class _MainProductScreenState extends State<MainProductScreen> {
  MyGetxController myGetxController = Get.find();

  @override
  void initState() {
    super.initState();
    checkWifiForgetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).padding.top + 10,
        ),
        ScreenAppBar(
          screenName: "Product Type",
        ),
        Obx(() => myGetxController.mainProductList.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  itemCount: myGetxController.mainProductList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        pushMethod(
                            context,
                            MainProductdetailScreen(
                                productTypeCode: myGetxController
                                    .mainProductList[index]['product_type']));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        padding: EdgeInsets.all(15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200.withOpacity(0.5),
                            border: Border.all(
                                color: Color(0xffE6ECF2), width: 0.7),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Text(
                          myGetxController.mainProductList[index]
                              ['product_type'],
                          style: primaryStyle,
                        ),
                      ),
                    );
                  },
                ),
              )
            : Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )),
      ],
    ));
  }

  Future<void> checkWifiForgetData() async {
    String apiUrl = await getStringPreference('apiUrl');
    String accessToken = await getStringPreference('accessToken');
    try {
      if (apiUrl.toString().startsWith("192")) {
        showConnectivity().then((result) async {
          if (result == ConnectivityResult.wifi) {
            getMainProduct(apiUrl, accessToken);
          } else {
            dialog(context, "Connect to Showroom Network");
          }
        });
      } else {
        getMainProduct(apiUrl, accessToken);
      }
    } on SocketException catch (err) {
      dialog(context, "Connect to Showroom Network");
    }
  }

  Future<void> getMainProduct(String apiUrl, String accessToken) async {
    myGetxController.mainProductList.clear();
    final response = await http.get(
        Uri.parse("http://$apiUrl/api/product.type"),
        headers: {'Access-Token': accessToken});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<dynamic> lst = data['results'];
      if (lst.isNotEmpty) {
        myGetxController.mainProductList.addAll(data['results']);
      }
    }
  }

}
