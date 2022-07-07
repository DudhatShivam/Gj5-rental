import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/screen/booking%20status/booking_status.dart';
import 'package:gj5_rental/screen/quatation/quotation_const/quotation_constant.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../../getx/getx_controller.dart';
import 'package:http/http.dart' as http;

class QuotationDetailAddProduct extends StatefulWidget {
  const QuotationDetailAddProduct(
      {Key? key, this.deliveryDate, this.returnDate, this.orderId})
      : super(key: key);
  final String? deliveryDate;
  final String? returnDate;
  final int? orderId;

  @override
  State<QuotationDetailAddProduct> createState() =>
      _QuotationDetailAddProductState();
}

class _QuotationDetailAddProductState extends State<QuotationDetailAddProduct> {
  TextEditingController productSearchController = TextEditingController();
  TextEditingController rentController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  MyGetxController myGetxController = Get.find();
  String returnDate = "";
  String deliveryDate = "";
  DateTime? returnNotFormatedDate;
  DateTime? deliveryNotFormatedDate;
  List<dynamic> responseOfApi = [];
  bool isDisplayResponseApiList = false;
  int? productId;
  int? orderId;

  @override
  void initState() {
    super.initState();
    orderId = widget.orderId;
    getPreferenceProductList();
    deliveryDate = widget.deliveryDate ?? "";
    returnDate = widget.returnDate ?? "";
    deliveryNotFormatedDate = new DateFormat("dd/MM/yyyy").parse(deliveryDate);
    returnNotFormatedDate = DateFormat("dd/MM/yyyy").parse(returnDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          allScreenInitialSizedBox(context),
          ScreenAppBar(
            screenName: "Add Product in Order",
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "D Date",
                style: allCardSubText,
              ),
              Text(
                "R Date",
                style: allCardSubText,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    pickedDate(context).then((value) {
                      if (value != null) {
                        deliveryNotFormatedDate = value;
                        setState(() {
                          deliveryDate = DateFormat('dd-MM-yyyy').format(value);
                        });
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    height: 48,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      deliveryDate,
                      style: primaryStyle,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    pickedDate(context).then((value) {
                      if (value != null) {
                        returnNotFormatedDate = value;
                        setState(() {
                          returnDate = DateFormat('dd-MM-yyyy').format(value);
                        });
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    height: 48,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      returnDate,
                      style: primaryStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          productSearchTextField(),
          SizedBox(
            height: 15,
          ),
          isDisplayResponseApiList == true
              ? Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.zero,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: responseOfApi.length,
                            itemBuilder: (context, index) {
                              return bookingStatusResponseCard(
                                  responseOfApi, index);
                            }),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: getWidth(0.02, context)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rent : ",
                                style: primaryStyle,
                              ),
                              Container(
                                width: getWidth(0.33, context),
                                child: textFieldWidget(
                                    "Rent",
                                    rentController,
                                    false,
                                    false,
                                    Colors.grey.withOpacity(0.1),
                                    TextInputType.number,
                                    0,
                                    Colors.greenAccent,
                                    1),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: getWidth(0.02, context)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Remark : ",
                                style: primaryStyle,
                              ),
                              Container(
                                width: getWidth(0.33, context),
                                child: textFieldWidget(
                                    "Remark",
                                    remarkController,
                                    false,
                                    false,
                                    Colors.grey.withOpacity(0.1),
                                    TextInputType.text,
                                    0,
                                    Colors.greenAccent,
                                    1),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: SizedBox(
                              width: double.infinity,
                              height: 43,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primary2Color),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  checkWifiForAddProduct();
                                },
                                child: Text("ADD"),
                              )),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  productSearchTextField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Obx(() => SearchField(
            controller: productSearchController,
            suggestionsDecoration: BoxDecoration(
              border: Border.all(color: primary2ColorShade400),
            ),
            searchStyle: primaryStyle,
            searchInputDecoration: InputDecoration(
                suffixIcon: productSearchController.text.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          myGetxController.isSetTextFieldData.value = false;
                          productSearchController.clear();
                          FocusScope.of(context).unfocus();
                          setState(() {
                            isDisplayResponseApiList = false;
                          });
                        },
                        child: Container(
                          child: Icon(
                            Icons.cancel,
                            color: primaryColor,
                            size: 30,
                          ),
                        ),
                      )
                    : null,
                hintText: "Search Product",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primary2Color),
                )),
            onSuggestionTap: (val) {
              getResponseProductApiList();
            },
            itemHeight: 45,
            suggestions:
                myGetxController.isMainProductFalseProductList.map((e) {
              String search = "${e['default_code']} -  ${e['name']}";
              return SearchFieldListItem(search);
            }).toList(),
            suggestionAction: SuggestionAction.next,
          )),
    );
  }

  getResponseProductApiList() {
    String value = productSearchController.text.split(' ').first;
    myGetxController.isMainProductFalseProductList.forEach((element) {
      if (element['default_code'] == value) {
        productId = element['id'];
        rentController.text = element['rent'].toString();
      }
    });
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                getData(value, productId ?? 0, token);
              } else {
                responseOfApi.clear();
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            getData(value, productId ?? 0, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  getData(String apiUrl, int id, String token) async {
    print(id);
    final response = await http.put(
        Uri.parse("http://$apiUrl/api/product.product/$id/get_booking_status"),
        headers: {
          'Access-Token': token,
        }).whenComplete(() {
      setState(() {
        isDisplayResponseApiList = true;
      });
    });
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['status'] == 1) {
      responseOfApi = data['results'];
    }
  }

  checkWifiForAddProduct() {
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                addProduct(value, token);
              } else {
                responseOfApi.clear();
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            addProduct(value, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  void addProduct(String apiUrl, String token) async {
    String dDate = DateFormat('MM/dd/yyyy')
        .format(deliveryNotFormatedDate ?? DateTime.now());
    String rDate = DateFormat('MM/dd/yyyy')
        .format(returnNotFormatedDate ?? DateTime.now());
    String rent = rentController.text;
    String remark = remarkController.text;
    final response = await http.put(
        Uri.parse(
            "http://$apiUrl/api/rental.rental/$orderId/confirm_order_from_api?product_id=$productId&delivery_date=$dDate&return_date=$rDate&rent=$rent&remarks=$remark"),
        headers: {
          'Access-Token': token,
        });
    final data = jsonDecode(response.body);
    print(response.body);
    print(response.statusCode);
    if (data['status'] == 1) {
      checkQuotationAndOrderDetailData(context, orderId ?? 0, false);
      Navigator.pop(context);
    } else {
      dialog(
          context, data['msg'] ?? "Some thing went wrong", Colors.red.shade300);
    }
  }

  void getPreferenceProductList() {
    if (myGetxController.isMainProductFalseProductList.isEmpty == true) {
      getStringPreference('ProductList').then((value) async {
        Map<String, dynamic> data = await jsonDecode(value);
        print(data['count']);
        List<dynamic> lst = await data['results'];
        lst.forEach((element) {
          if (element['is_main_product'] == true) {
            myGetxController.isMainProductFalseProductList.add(element);
          }
        });
      });
    }
  }

//     .replace(queryParameters: {
// 'product_id': productId,
// 'delivery_date': deliveryDate,
// 'return_date': returnDate,
// 'rent': rentController.text
// })
}
