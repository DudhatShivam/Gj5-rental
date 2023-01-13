import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../../Utils/textfield_utils.dart';
import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../../getx/getx_controller.dart';

class MainProductdetailScreen extends StatefulWidget {
  const MainProductdetailScreen({Key? key, required this.productTypeCode})
      : super(key: key);
  final String productTypeCode;

  @override
  State<MainProductdetailScreen> createState() =>
      _MainProductdetailScreenState();
}

class _MainProductdetailScreenState extends State<MainProductdetailScreen> {
  MyGetxController myGetxController = Get.find();
  TextEditingController codeController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  bool noData = false;
  bool isExpandSearch = false;

  @override
  void initState() {
    super.initState();
    checkWifiForgetData(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          allScreenInitialSizedBox(context),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: FadeInLeft(child: backArrowIcon)),
                    SizedBox(
                      width: 10,
                    ),
                    FadeInLeft(
                      child: Text("Product", style: pageTitleTextStyle),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          checkWifiForgetData(false);
                        },
                        child: FadeInRight(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: refreshIcon,
                        ))),
                    InkWell(
                        onTap: () {
                          setState(() {
                            isExpandSearch = !isExpandSearch;
                          });
                        },
                        child: isExpandSearch == false
                            ? FadeInRight(child: searchIcon)
                            : cancelIcon)
                  ],
                )
              ],
            ),
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
                          "Code : ",
                          style: primaryStyle,
                        ),
                        Container(
                          width: getWidth(0.6, context),
                          child: textFieldWidget(
                              "Product Code",
                              codeController,
                              false,
                              false,
                              Colors.greenAccent.withOpacity(0.3),
                              TextInputType.text,
                              0,
                              Colors.greenAccent,
                              1,""),
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
                          "Product :",
                          style: primaryStyle,
                        ),
                        Container(
                          width: getWidth(0.6, context),
                          child: textFieldWidget(
                              "Product Name",
                              productNameController,
                              false,
                              false,
                              Colors.greenAccent.withOpacity(0.3),
                              TextInputType.text,
                              0,
                              Colors.greenAccent,
                              1,""),
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
                            setState(() {
                              isExpandSearch=false;
                            });
                            checkWifiForgetData(true);
                          },
                          child: Text("Search")),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(() => myGetxController.mainProductDetailList.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    padding: isExpandSearch == false
                        ? EdgeInsets.symmetric(vertical: 15)
                        : EdgeInsets.zero,
                    itemCount: myGetxController.mainProductDetailList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        padding: EdgeInsets.all(15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200.withOpacity(0.5),
                            border: Border.all(
                                color: Color(0xffE6ECF2), width: 0.7),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    FadeInLeft(
                                      child: Text(
                                        "Code : ",
                                        style: primaryStyle,
                                      ),
                                    ),
                                    FadeInLeft(
                                      child: FittedBox(
                                        child: Container(
                                          width: getWidth(0.3, context),
                                          child: Text(
                                            myGetxController
                                                    .mainProductDetailList[index]
                                                ['default_code'] ?? "",
                                            style: allCardSubText,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    FadeInRight(
                                      child: Text(
                                        "Rent : ",
                                        style: primaryStyle,
                                      ),
                                    ),
                                    FadeInRight(
                                      child: Text(
                                        myGetxController
                                            .mainProductDetailList[index]
                                                ['rent']
                                            .toString(),
                                        style: deliveryDateStyle,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FadeInLeft(
                                    child:
                                        Text("Name : ", style: primaryStyle)),
                                Expanded(
                                  child: FadeInRight(
                                    child: Text(
                                      myGetxController
                                          .mainProductDetailList[index]['name'] ?? "",
                                      style: allCardSubText,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : noData == true
                  ? Expanded(
                      child: Center(
                      child: Text(
                        "No Product !",
                        style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
                      ),
                    ))
                  : Expanded(
                      child: CenterCircularProgressIndicator(),
                    )),
        ],
      ),
    );
  }

  Future<void> checkWifiForgetData(bool isSearchClick) async {
    String apiUrl = await getStringPreference('apiUrl');
    String accessToken = await getStringPreference('accessToken');
    try {
      if (apiUrl.toString().startsWith("192")) {
        showConnectivity().then((result) async {
          if (result == ConnectivityResult.wifi) {
            isSearchClick == false
                ? getMainProductList(apiUrl, accessToken)
                : searchProduct(apiUrl, accessToken);
          } else {
            dialog(context, "Connect to Showroom Network", Colors.red.shade300);
          }
        });
      } else {
        isSearchClick == false
            ? getMainProductList(apiUrl, accessToken)
            : searchProduct(apiUrl, accessToken);
      }
    } on SocketException catch (err) {
      dialog(context, "Connect to Showroom Network", Colors.red.shade300);
    }
  }

  Future<void> getMainProductList(String apiUrl, String accessToken) async {
    myGetxController.mainProductDetailList.clear();
    String code = widget.productTypeCode;
    String domain = "[('product_type_code', '=', '$code')]";
    var params = {'filters': domain.toString()};
    Uri uri = Uri.parse("http://$apiUrl/api/product.product");
    final finalUri = uri.replace(queryParameters: params);
    final response =
        await http.get(finalUri, headers: {'Access-Token': accessToken});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['count'] != 0) {
        myGetxController.mainProductDetailList.addAll(data['results']);
      } else {
        setState(() {
          noData = true;
        });
      }
    }
  }

  Future<void> searchProduct(String apiUrl, String token) async {
    String code = widget.productTypeCode;

    String? domain;
    List datas = [];

    if (codeController.text != "") {
      datas.add("('default_code', 'ilike', '${codeController.text}')");
    }
    if (productNameController.text != "") {
      datas.add("('name', 'ilike', '${productNameController.text}')");
    }

    if (datas.length == 1) {
      domain = "[${datas[0]},('product_type_code', '=', '$code')]";
    } else if (datas.length == 2) {
      domain =
          "[('product_type_code', '=', '$code'), '|' ,${datas[0]} , ${datas[1]}]";
    } else {
      myGetxController.mainProductDetailList.value = [];
    }
    var params = {'filters': domain.toString()};
    Uri uri = Uri.parse("http://$apiUrl/api/product.product");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri, headers: {
      'Access-Token': token,
      'Connection': 'keep-alive',
      'Content-Type': 'application/http'
    });
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['count'] != 0) {
      myGetxController.mainProductDetailList.clear();
      myGetxController.mainProductDetailList.value = data['results'];
    } else {
      dialog(context, "Product Not Found", Colors.red.shade300);
    }
  }
}
