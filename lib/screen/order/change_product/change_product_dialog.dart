import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/booking%20status/booking_status.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

import '../../../Utils/utils.dart';
import '../../../constant/constant.dart';

class ChangeProductDialog extends StatefulWidget {
  final List orderDetailList;
  final int index;
  final int productId;

  const ChangeProductDialog(
      {Key? key,
      required this.orderDetailList,
      required this.index,
      required this.productId})
      : super(key: key);

  @override
  State<ChangeProductDialog> createState() => _ChangeProductDialogState();
}

class _ChangeProductDialogState extends State<ChangeProductDialog> {
  List orderList = [];
  int index = 0;
  MyGetxController myGetxController = Get.put(MyGetxController());
  TextEditingController productSearchController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  String deliveryDate = "";
  String returnDate = "";

  @override
  void initState() {
    orderList = widget.orderDetailList;
    index = widget.index;
    getProductList();
    deliveryDate = DateFormat("dd/MM/yyyy")
        .format(DateTime.parse(orderList[index]['delivery_date']));
    returnDate = DateFormat("dd/MM/yyyy")
        .format(DateTime.parse(orderList[index]['return_date']));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              orderList[index]['product_id']['default_code'],
              style: dialogTitleStyle,
            ),
            SizedBox(
              height: 10,
            ),
            Obx(() => SearchField(
                  controller: productSearchController,
                  maxSuggestionsInViewPort: 5,
                  suggestionsDecoration: BoxDecoration(
                    border: Border.all(color: primary2Color),
                  ),
                  searchStyle: primaryStyle,
                  searchInputDecoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: () {
                          productSearchController.clear();
                          FocusScope.of(context).unfocus();
                        },
                        child: Container(
                          child: Icon(
                            Icons.cancel,
                            color: Colors.grey.shade500,
                            size: 25,
                          ),
                        ),
                      ),
                      hintText: "Select Product",
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
                  itemHeight: 55,
                  suggestions:
                      myGetxController.isMainProductTrueProductList.map((e) {
                    String search = "${e['default_code']} -- ${e['name']}";
                    return SearchFieldListItem(search);
                  }).toList(),
                  suggestionAction: SuggestionAction.next,
                )),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "D Date",
                  style: primaryStyle,
                ),
                InkWell(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    pickedDate(context).then((value) {
                      if (value != null) {
                        setState(() {
                          deliveryDate = DateFormat('dd/MM/yyyy').format(value);
                        });
                      }
                    });
                  },
                  child: Container(
                    width: getWidth(0.5, context),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: Row(
                      children: [
                        calenderIcon,
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          deliveryDate,
                          style: primaryStyle,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "R Date",
                  style: primaryStyle,
                ),
                InkWell(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    pickedDate(context).then((value) {
                      if (value != null) {
                        setState(() {
                          returnDate = DateFormat('dd/MM/yyyy').format(value);
                        });
                      }
                    });
                  },
                  child: Container(
                    width: getWidth(0.5, context),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: Row(
                      children: [
                        calenderIcon,
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          returnDate,
                          style: primaryStyle,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Remark ",
                  style: primaryStyle,
                ),
                Container(
                  width: getWidth(0.5, context),
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
            productSearchController.text.isNotEmpty
                ? Container(
                    width: double.infinity,
                    height: 45,
                    margin: const EdgeInsets.all(15),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primary2Color),
                        onPressed: () {
                          checkWlanForChangeProduct();
                        },
                        child: Text("CHANGE PRODUCT")),
                  )
                : Container(
                    width: double.infinity,
                    height: 45,
                    margin: const EdgeInsets.all(15),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primary2Color.withOpacity(0.3)),
                        onPressed: () {
                          showToast("Select Product");
                        },
                        child: Text(
                          "CHANGE PRODUCT",
                          style: TextStyle(color: Colors.white60),
                        )),
                  )
          ],
        ),
      ),
    );
  }

  void checkWlanForChangeProduct() {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                changeProduct(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            changeProduct(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  Future<void> changeProduct(apiUrl, token) async {
    int? newProductId;
    double? rent;
    String value =
        productSearchController.text.split('--').first.removeAllWhitespace;
    int orderId = orderList[index]['rental_id'];
    myGetxController.isMainProductTrueProductList.forEach((element) {
      if (element['default_code'] == value) {
        newProductId = element['id'];
        rent = element['rent'];
      }
    });
    String remark = remarkController.text;

    final response = await http.put(
        Uri.parse(
            "http://$apiUrl/api/rental.rental/$orderId/change_product_from_api?selected_product_id=${widget.productId}&product_id=$newProductId&delivery_date=$deliveryDate&return_date=$returnDate&rent=$rent&remarks=$remark"),
        headers: {
          'Access-Token': token,
        });
    if (response.statusCode == 200) {
      checkWlanForOrderDetailScreen(context, orderId).whenComplete(() {
        Navigator.pop(context);
      });
    } else {
      dialog(context, "Error in Changing Product", Colors.red.shade300);
      Navigator.pop(context);
    }
  }
}
