import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:gj5_rental/constant/constant.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/booking%20status/book_order.dart';
import 'package:gj5_rental/screen/quatation/quatation.dart';
import 'package:http/http.dart' as http;

import 'package:gj5_rental/home/home.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

class BookingStatus extends StatefulWidget {
  const BookingStatus({Key? key}) : super(key: key);

  @override
  State<BookingStatus> createState() => _BookingStatusState();
}

class _BookingStatusState extends State<BookingStatus> {
  List displayGotProductListFromPreferences = [];
  List<dynamic> gotProductListFromPreferences = [];
  int? id;

  @override
  void initState() {
    super.initState();
    getStringPreference('ProductList').then((value) {
      Map<String, dynamic> data = jsonDecode(value);
      gotProductListFromPreferences = data['results'];
    });
  }

  List<dynamic> responseOfApi = [];
  TextEditingController productSearchController = TextEditingController();
  MyGetxController myGetxController = Get.put(MyGetxController());
  bool isDisplayResponseApiList = false;
  String returnDate = "";
  String deliveryDate = "";
  DateTime? returnNotFormatedDate;
  DateTime? deliveryNotFormatedDate;
  double? productRent=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F5F9),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 10,
          ),
          ScreenAppBar(screenName: "Booking Status"),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: SearchField(
                    controller: productSearchController,
                    maxSuggestionsInViewPort: 8,
                    suggestionsDecoration: BoxDecoration(
                      border: Border.all(color: Colors.teal.shade400),
                    ),
                    searchStyle: primaryStyle,
                    searchInputDecoration: InputDecoration(
                        suffixIcon: productSearchController.text.isNotEmpty
                            ? InkWell(
                                onTap: () {
                                  myGetxController.isSetTextFieldData.value =
                                      false;
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
                          borderSide: BorderSide(color: Colors.teal),
                        )),
                    onSuggestionTap: (val) {
                      getResponseProductApiList();
                    },
                    itemHeight: 55,
                    suggestions: gotProductListFromPreferences.map((e) {
                      String search = e['default_code'] + " - " + e['name'];
                      return SearchFieldListItem(search);
                    }).toList(),
                    suggestionAction: SuggestionAction.next,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          isDisplayResponseApiList == true
              ? Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "D Date",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                            Text(
                              "R Date",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
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
                                        deliveryDate = DateFormat('dd/MM/yyyy')
                                            .format(value);
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
                                        returnDate = DateFormat('dd/MM/yyyy')
                                            .format(value!);
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
                          height: 5,
                        ),
                        Flexible(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.zero,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: responseOfApi.length,
                              itemBuilder: (context, index) {
                                return bookingStatusResponseCard(
                                    responseOfApi, index);
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () {
                                  checkWlanForCheckStatus();
                                },
                                child: Text("CHECK STATUS"),
                              )),
                        ),
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  getResponseProductApiList() {
    int? id;
    String value = productSearchController.text.split(' ').first;
    gotProductListFromPreferences.forEach((element) {
      if (element['default_code'] == value) {
        id = element['id'];
        productRent=element['rent'];
      }
    });
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                getData(value, id ?? 0, token);
              } else {
                responseOfApi.clear();
                dialog(context, "Connect to Showroom Network");
              }
            });
          } else {
            getData(value, id ?? 0, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network");
      }
    });
  }

  checkWlanForCheckStatus() async {
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                checkingStatus(value, token);
                // updateDetail(value, token, widget.lineId);
              } else {
                dialog(context, "Connect to Showroom Network");
              }
            });
          } else {
            checkingStatus(value, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network");
      }
    });
  }

  int? getIdFromTextFieldData() {
    int? id;
    String value = productSearchController.text.split(' ').first;
    gotProductListFromPreferences.forEach((element) {
      if (element['default_code'] == value) {
        id = element['id'];
      }
    });
    return id;
  }

  getData(String apiUrl, int id, String token) async {
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

  Future<void> checkingStatus(apiUrl, token) async {

    int? id = getIdFromTextFieldData();
    if (deliveryNotFormatedDate != null && returnNotFormatedDate != null) {
      String dDate = DateFormat('MM/dd/yyyy').format(deliveryNotFormatedDate!);
      String rDate = DateFormat('MM/dd/yyyy').format(returnNotFormatedDate!);

      final response = await http.put(
          Uri.parse(
              "http://$apiUrl/api/product.product/$id/checking_product_api?product_id=$id&delivery_date=$dDate&return_date=$rDate"),
          headers: {
            'Access-Token': token,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 1) {
          pushMethod(
              context,
              BookOrder(
                productName: productSearchController.text,
                deliveryDate: deliveryDate,
                returnDate: returnDate,
                productId: id,
                rent: productRent,
              ));
        } else {
          dialog(context, data['msg']);
        }
      }
    } else {
      dialog(context, "Please Select Delivery Date and Return Date!");
    }
  }
}

class ScreenAppBar extends StatelessWidget {
  const ScreenAppBar({
    Key? key,
    this.screenName,
  }) : super(key: key);

  final String? screenName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: FadeInLeft(
                child: Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.teal,
                ),
              )),
          SizedBox(
            width: 10,
          ),
          FadeInLeft(
            child: Text(
              screenName.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 23,
                  color: Colors.teal),
            ),
          ),
        ],
      ),
    );
  }
}
