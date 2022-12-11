import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:gj5_rental/constant/constant.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/booking%20status/booking_status.dart';
import 'package:http/http.dart' as http;

import '../../Utils/textfield_utils.dart';
import '../../constant/extraproduct_screen_card.dart';
import '../cancel_order/cancel_order.dart';

class ExtraProduct extends StatefulWidget {
  const ExtraProduct({Key? key}) : super(key: key);

  @override
  State<ExtraProduct> createState() => _ExtraProductState();
}

class _ExtraProductState extends State<ExtraProduct> {
  MyGetxController myGetxController = Get.put(MyGetxController());
  bool isExpandSearch = false;
  TextEditingController orderNumberController = TextEditingController();
  TextEditingController productCodeController = TextEditingController();
  bool isSearchLoadData = false;

  @override
  void initState() {
    myGetxController.noDataInExtraProductScreen.value = false;
    checkWlanForExtraProduct(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        allScreenInitialSizedBox(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ScreenAppBar(
              screenName: "Extra Product",
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    myGetxController.extraProductFilteredList.clear();

                    checkWlanForExtraProduct(false);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: refreshIcon,
                  ),
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                        isExpandSearch = !isExpandSearch;
                      });
                    },
                    child: isExpandSearch == false
                        ? FadeInRight(child: searchIcon)
                        : cancelIcon),
                SizedBox(
                  width: 15,
                )
              ],
            ),
          ],
        ),
        AnimatedSize(
          duration: Duration(milliseconds: 500),
          child: Container(
            height: isExpandSearch ? null : 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    "Find Product :",
                    style: drawerTextStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order No. :",
                        style: primaryStyle,
                      ),
                      Container(
                        width: getWidth(0.6, context),
                        child: textFieldWidget(
                            "Order Number",
                            orderNumberController,
                            false,
                            false,
                            Colors.greenAccent.withOpacity(0.3),
                            TextInputType.number,
                            0,
                            Colors.greenAccent,
                            1),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Code :",
                        style: primaryStyle,
                      ),
                      Container(
                        width: getWidth(0.6, context),
                        child: textFieldWidget(
                            "Product Code",
                            productCodeController,
                            false,
                            false,
                            Colors.greenAccent.withOpacity(0.3),
                            TextInputType.text,
                            0,
                            Colors.greenAccent,
                            1),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: primary2Color),
                        onPressed: () {
                          myGetxController.noDataInExtraProductScreen.value = false;
                          setState(() {
                            isSearchLoadData = true;
                            isExpandSearch = false;
                          });
                          checkWlanForExtraProduct(true);
                        },
                        child: Text("Search")),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Obx(() => myGetxController.extraProductList.isNotEmpty &&
                  isSearchLoadData == false
              ? myGetxController.extraProductFilteredList.isEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      itemCount: myGetxController.extraProductList.length,
                      itemBuilder: (context, index) {
                        return ExtraProductScreenCard(
                          extraProductList: myGetxController.extraProductList,
                          index: index,
                        );
                      })
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      itemCount:
                          myGetxController.extraProductFilteredList.length,
                      itemBuilder: (context, index) {
                        return ExtraProductScreenCard(
                          extraProductList:
                              myGetxController.extraProductFilteredList,
                          index: index,
                        );
                      })
              : myGetxController.noDataInExtraProductScreen.value == false
                  ? CenterCircularProgressIndicator()
                  : centerNoOrderText("No Product Found !")),
        )
      ],
    ));
  }

  void checkWlanForExtraProduct(bool isSearchData) {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                isSearchData == false
                    ? getDataOfExtraProduct(apiUrl, token)
                    : getSearchDataOfExtraProduct(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            isSearchData == false
                ? getDataOfExtraProduct(apiUrl, token)
                : getSearchDataOfExtraProduct(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  Future<void> getDataOfExtraProduct(apiUrl, token) async {
    myGetxController.extraProductList.clear();
    String domain = "[('state' , 'not in' , ['done','cancel','draft'])]";
    var params = {
      'filters': domain.toString(),
    };
    Uri uri = Uri.parse("http://$apiUrl/api/extra.product");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri, headers: {'Access-Token': token});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['count'] != 0) {
        myGetxController.extraProductList.addAll(data['results']);
      } else {
        myGetxController.noDataInExtraProductScreen.value = true;
      }
    } else {
      dialog(context, "Something Went Wrong", Colors.red.shade300);
    }
  }

  getSearchDataOfExtraProduct(apiUrl, token) async {
    String? domain;
    List datas = [];
    if (orderNumberController.text != "") {
      datas.add(
          "('order_no', 'ilike', '${orderNumberController.text}') , ('state' , 'not in' , ['done','cancel','draft'])");
    }
    if (productCodeController.text != "") {
      datas.add(
          "('p_default_code', 'ilike', '${productCodeController.text}') , ('state' , 'not in' , ['done','cancel','draft'])");
    }
    if (datas.length == 1) {
      domain = "[${datas[0]}]";
    } else if (datas.length == 2) {
      domain = "['|' , ${datas[0]} , ${datas[1]}]";
    } else {
      myGetxController.extraProductFilteredList.value = [];
    }
    var params = {'filters': domain.toString()};
    Uri uri = Uri.parse("http://$apiUrl/api/extra.product");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri,
        headers: {'Access-Token': token, 'Content-Type': 'application/http'});
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['count'] != 0) {
        myGetxController.extraProductFilteredList.clear();
        setState(() {
          isSearchLoadData = false;
        });
        myGetxController.extraProductFilteredList.addAll(data['results']);
      } else {
        setState(() {
          isSearchLoadData = false;
        });
        dialog(context, "No Product Found", Colors.red.shade300);
      }
    } else {
      setState(() {
        isSearchLoadData = false;
      });
      dialog(context, "Something Went Wrong !", Colors.red.shade300);
    }
  }
}
