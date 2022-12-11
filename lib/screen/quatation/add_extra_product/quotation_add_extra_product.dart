import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

import '../../../Utils/textfield_utils.dart';
import '../../../Utils/utils.dart';
import '../../../constant/constant.dart';
import '../../../getx/getx_controller.dart';
import '../../booking status/booking_status.dart';
import '../../main_product/main_product.dart';
import '../quotation_const/quotation_constant.dart';

class QuotationAddExtraProduct extends StatefulWidget {
  const QuotationAddExtraProduct({Key? key}) : super(key: key);

  @override
  State<QuotationAddExtraProduct> createState() =>
      _QuotationAddExtraProductState();
}

class _QuotationAddExtraProductState extends State<QuotationAddExtraProduct> {
  MyGetxController myGetxController = Get.find();
  TextEditingController productSearchController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController rentController = TextEditingController();
  String? selectedValue;
  String? originalProductSelectedValue;

  @override
  void initState() {
    super.initState();
    myGetxController.orginalProductList.clear();
    myGetxController.quotationMainProductList.clear();
    myGetxController.quotationMainProductTypeList.clear();
    getData();
    myGetxController.quotationDetailOrderList.forEach((element) {
      myGetxController.orginalProductList
          .add(element['product_id']['display_name']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
            allScreenInitialSizedBox(context),
            ScreenAppBar(
              screenName: "Add Extra Product",
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: getWidth(0.25, context),
                        child: Text(
                          "Original product : ",
                          style: primaryStyle,
                        ),
                      ),
                      Expanded(
                        child: Obx(() => Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10)),
                              height: 55,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  buttonDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  dropdownDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  hint: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Select Original Product',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                                  items: myGetxController.orginalProductList
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15),
                                              child: Container(
                                                width: getWidth(0.52, context),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Text(
                                                    item,
                                                    style: primaryStyle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  value: originalProductSelectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      originalProductSelectedValue =
                                          value as String;
                                    });
                                  },
                                  buttonHeight: 40,
                                  buttonWidth: getWidth(0.25, context),
                                  itemHeight: 40,
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Type :",
                        style: primaryStyle,
                      ),
                      Obx(() => Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10)),
                            height: 55,
                            width: getWidth(0.68, context),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                buttonDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Select Product Type',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                                items: myGetxController
                                    .quotationMainProductTypeList
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Text(
                                              item,
                                              style: primaryStyle,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                value: selectedValue,
                                onChanged: (value) {
                                  myGetxController.quotationMainProductList
                                      .clear();
                                  setState(() {
                                    productSearchController.clear();
                                    selectedValue = value as String;
                                    checkWlanForGetProductData(false);
                                  });
                                },
                                buttonHeight: 40,
                                buttonWidth: getWidth(0.25, context),
                                itemHeight: 40,
                              ),
                            ),
                          )),
                    ],
                  ),
                  Obx(() => myGetxController.quotationMainProductList.isNotEmpty
                      ? Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Product :  ",
                                  style: primaryStyle,
                                ),
                                Container(
                                  width: getWidth(0.68, context),
                                  child: SearchField(
                                    controller: productSearchController,
                                    maxSuggestionsInViewPort: 8,
                                    suggestionsDecoration: BoxDecoration(
                                      border: Border.all(color: primary2Color),
                                    ),
                                    searchStyle: primaryStyle,
                                    searchInputDecoration: InputDecoration(
                                        suffixIcon: productSearchController
                                                .text.isNotEmpty
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    productSearchController
                                                        .clear();
                                                    rentController.clear();
                                                  });
                                                  FocusScope.of(context)
                                                      .unfocus();
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
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16),
                                        filled: true,
                                        fillColor: Colors.grey.withOpacity(0.1),
                                        border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: primary2Color),
                                        )),
                                    onSuggestionTap: (val) {
                                      FocusScope.of(context).unfocus();
                                      getProductId();
                                    },
                                    itemHeight: 55,
                                    suggestions: myGetxController
                                        .quotationMainProductList
                                        .map((e) {
                                      String search =
                                          "${e['default_code']} -- ${e['name']}";
                                      return SearchFieldListItem(search);
                                    }).toList(),
                                    suggestionAction: SuggestionAction.next,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container()),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rent : ",
                        style: primaryStyle,
                      ),
                      Container(
                        width: getWidth(0.68, context),
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
                  SizedBox(
                    height: 15,
                  ),
                  remarkContainer(context, remarkController, 0.68, 0,
                      MainAxisAlignment.spaceBetween),
                  SizedBox(
                    height: 25,
                  ),
                  productSearchController.text.isNotEmpty
                      ? SizedBox(
                          width: double.infinity,
                          height: 43,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: primary2Color),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              checkWlanForGetProductData(true);
                            },
                            child: Text("ADD"),
                          ))
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    checkWifiForgetMainProductData(context);
    Future.delayed(
        Duration(seconds: 1),
        () => myGetxController.mainProductList.forEach((element) {
              myGetxController.quotationMainProductTypeList
                  .add(element['product_type']);
            }));
  }

  checkWlanForGetProductData(bool isAddProduct) async {
    String apiUrl = await getStringPreference('apiUrl');
    String accessToken = await getStringPreference('accessToken');
    try {
      if (apiUrl.toString().startsWith("192")) {
        showConnectivity().then((result) async {
          if (result == ConnectivityResult.wifi) {
            isAddProduct == false
                ? getProduct(apiUrl, accessToken)
                : addExtraProduct(apiUrl, accessToken);
          } else {
            dialog(context, "Connect to Showroom Network", Colors.red.shade300);
          }
        });
      } else {
        isAddProduct == false
            ? getProduct(apiUrl, accessToken)
            : addExtraProduct(apiUrl, accessToken);
      }
    } on SocketException catch (err) {
      dialog(context, "Connect to Showroom Network", Colors.red.shade300);
    }
  }

  Future<void> getProduct(String apiUrl, String accessToken) async {
    String domain = "[('product_type_code', '=', '$selectedValue')]";
    var params = {'filters': domain.toString()};
    Uri uri = Uri.parse("http://$apiUrl/api/product.product");
    final finalUri = uri.replace(queryParameters: params);
    final response =
        await http.get(finalUri, headers: {'Access-Token': accessToken});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['count'] != 0) {
        myGetxController.quotationMainProductList.addAll(data['results']);
      } else {}
    }
  }

  addExtraProduct(String apiUrl, String accessToken) async {
    String deliveryDate = DateFormat(passApiGlobalDateFormat).format(
        DateTime.parse(myGetxController.quotationOrder[0]['delivery_date']));
    String returnDate = DateFormat(passApiGlobalDateFormat).format(
        DateTime.parse(myGetxController.quotationOrder[0]['return_date']));
    int originalProductId = 0;
    int rentalId = myGetxController.quotationOrder[0]['id'];
    int? productId = await getProductId();
    if (originalProductSelectedValue != null) {
      myGetxController.quotationDetailOrderList.forEach((element) {
        if (originalProductSelectedValue ==
            element['product_id']['display_name']) {
          originalProductId = element['product_id']['id'];
        }
      });
    }
    print(deliveryDate);
    print(returnDate);
    var body = {
      'rental_id': rentalId,
      'product_type': selectedValue,
      'product_id': productId,
      'remarks': remarkController.text,
      'delivery_date': deliveryDate,
      'return_date': returnDate,
      'origin_product_id': originalProductId,
      'rent': rentController.text
    };
    final response =
        await http.post(Uri.parse("http://$apiUrl/api/extra.product"),
            headers: {
              'Access-Token': accessToken,
            },
            body: jsonEncode(body));
    print(response.body);
    if (response.statusCode == 200) {
      checkQuotationAndOrderDetailData(context, rentalId, false);
      Navigator.pop(context);
    } else {
      dialog(context, "Error In Adding Extra Product", Colors.red.shade300);
    }
  }

  int? getProductId() {
    int? id;
    String value =
        productSearchController.text.split('--').first.removeAllWhitespace;
    myGetxController.quotationMainProductList.forEach((element) {
      if (element['default_code'] == value) {
        id = element['id'];
        rentController.text = element['rent'].toString();
      }
    });
    return id;
  }
}
