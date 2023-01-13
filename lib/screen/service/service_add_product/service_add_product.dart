import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/screen/booking%20status/booking_status.dart';
import 'package:gj5_rental/screen/service/service_detail.dart';
import 'package:gj5_rental/screen/service/servicecontroller.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

import '../../../Utils/textfield_utils.dart';
import '../../../Utils/utils.dart';
import '../../../constant/constant.dart';

class ServiceAddProduct extends StatefulWidget {
  final int serviceId;
  final String? serviceType;

  const ServiceAddProduct({Key? key, required this.serviceId, this.serviceType})
      : super(key: key);

  @override
  State<ServiceAddProduct> createState() => _ServiceAddProductState();
}

class _ServiceAddProductState extends State<ServiceAddProduct> {
  ServiceController serviceController = Get.find();
  TextEditingController productSearchController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController chargeController = TextEditingController();
  int? productId;
  double? washingCharge;
  double? stitchingCharge;
  String deliveryDate = DateFormat(passApiGlobalDateFormat).format(DateTime.now());

  @override
  void initState() {
    getPreferenceProductList();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            allScreenInitialSizedBox(context),
            ScreenAppBar(
              screenName: "Add Product In Service",
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Obx(() => SearchField(
                        controller: productSearchController,
                        suggestionsDecoration: BoxDecoration(
                          border: Border.all(color: primary2Color),
                        ),
                        searchStyle: primaryStyle,
                        hasOverlay: false,
                        searchInputDecoration: InputDecoration(
                            suffixIcon: productSearchController.text.isNotEmpty
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        productSearchController.clear();
                                        FocusScope.of(context).unfocus();
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
                        itemHeight: 45,
                        onSuggestionTap: (val) {
                          FocusScope.of(context).unfocus();
                          setCharge();
                        },
                        suggestions: serviceController.serviceLineAddProductList
                            .map((e) {
                          String search =
                              "${e['default_code']} -- ${e['name']}";
                          return SearchFieldListItem(search);
                        }).toList(),
                        suggestionAction: SuggestionAction.next,
                      )),
                  productSearchController.text.isNotEmpty
                      ? Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            remarkContainer(context, remarkController, 0.65, 0,
                                MainAxisAlignment.spaceBetween),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Charge : ",
                                  style: primaryStyle,
                                ),
                                Container(
                                  width: getWidth(0.65, context),
                                  child: textFieldWidget(
                                      "Charge (${widget.serviceType})",
                                      chargeController,
                                      false,
                                      false,
                                      Colors.grey.withOpacity(0.1),
                                      TextInputType.number,
                                      0,
                                      Colors.greenAccent,
                                      1,""),
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
                                  "Send : ",
                                  style: primaryStyle,
                                ),
                                InkWell(
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    picked7DateAbove(context).then((value) {
                                      if (value != null) {
                                        setState(() {
                                          deliveryDate =
                                              DateFormat(passApiGlobalDateFormat)
                                                  .format(value);
                                        });
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: getWidth(0.65, context),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 52,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.withOpacity(0.1),
                                    ),
                                    child: Row(
                                      children: [
                                        calenderIcon,
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          deliveryDate.toString(),
                                          style: primaryStyle,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: primary2Color),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    checkWlanForAddProduct();
                                  },
                                  child: Text("ADD")),
                            )
                          ],
                        )
                      : Container()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void getPreferenceProductList() {
    if (serviceController.serviceLineAddProductList.isEmpty == true) {
      getStringPreference('ProductList').then((value) async {
        Map<String, dynamic> data = await jsonDecode(value);
        List<dynamic> lst = await data['results'];
        lst.forEach((element) {
          if (element['is_main_product'] == true) {
            serviceController.serviceLineAddProductList.add(element);
          }
        });
      });
    }
  }

  void checkWlanForAddProduct() {
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                addProduct(value, token);
              } else {
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

  Future<void> addProduct(String apiUrl, String token) async {
    final response = await http.post(
        Uri.parse(
            "http://$apiUrl/api/product.service.line?product_id=$productId&charge=${chargeController.text}&service_id=${widget.serviceId}&remark=${remarkController.text}&in_date=$deliveryDate"),
        headers: {
          'Access-Token': token,
        });
    print(response.body);
    if (response.statusCode == 200) {
      getDataOfServiceDetail(context, apiUrl, token, widget.serviceId)
          .whenComplete(() {
        Navigator.pop(context);
      });
    } else {
      dialog(context, "Something Went Wrong", Colors.red.shade300);
    }
  }

  void setCharge() {
    String value =
        productSearchController.text.split('--').first.removeAllWhitespace;
    serviceController.serviceLineAddProductList.forEach((element) {
      if (element['default_code'] == value) {
        productId = element['id'];
        washingCharge = element['charge'];
        stitchingCharge = element['stitch_charge'];
        if (widget.serviceType == "washing") {
          chargeController.text = washingCharge.toString();
        } else {
          chargeController.text = stitchingCharge.toString();
        }
        setState(() {});
      }
    });
  }
}
