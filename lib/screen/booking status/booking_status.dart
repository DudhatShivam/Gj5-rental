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
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

class BookingStatus extends StatefulWidget {
  const BookingStatus({Key? key}) : super(key: key);

  @override
  State<BookingStatus> createState() => _BookingStatusState();
}

class _BookingStatusState extends State<BookingStatus> {
  MyGetxController myGetxController = Get.find();
  List displayGotProductListFromPreferences = [];
  List<dynamic> isMainProductTrueList = [];
  int? id;

  @override
  void initState() {
    super.initState();
    getProductList();
  }

  List<dynamic> responseOfApi = [];
  TextEditingController productSearchController = TextEditingController();
  bool isDisplayResponseApiList = false;
  bool? noData;
  bool? loading;
  bool isBtnLoading = false;
  String? returnDate;
  String? deliveryDate;
  double? productRent = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F5F9),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            allScreenInitialSizedBox(context),
            ScreenAppBar(screenName: "Booking Status"),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Obx(() => SearchField(
                          controller: productSearchController,
                          maxSuggestionsInViewPort: 8,
                          suggestionsDecoration: BoxDecoration(
                            border: Border.all(color: primary2Color),
                          ),
                          searchStyle: primaryStyle,
                          searchInputDecoration: InputDecoration(
                              suffixIcon:
                                  productSearchController.text.isNotEmpty
                                      ? InkWell(
                                          onTap: () {
                                            myGetxController.isSetTextFieldData
                                                .value = false;
                                            responseOfApi.clear();
                                            productSearchController.clear();
                                            FocusScope.of(context).unfocus();
                                            setState(() {
                                              isDisplayResponseApiList = false;
                                              noData = false;
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
                          itemHeight: 55,
                          suggestions: myGetxController
                              .isMainProductTrueProductList
                              .map((e) {
                            String search =
                                "${e['default_code']} -- ${e['name']}";
                            return SearchFieldListItem(search);
                          }).toList(),
                          suggestionAction: SuggestionAction.next,
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            responseOfApi.isNotEmpty || noData == true
                ? Column(
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
                                  deliveryDate ?? "",
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
                                    setState(() {
                                      returnDate = DateFormat('dd/MM/yyyy')
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
                                  returnDate ?? "",
                                  style: primaryStyle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container(),
            isDisplayResponseApiList == true && responseOfApi.isNotEmpty
                ? Flexible(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.only(top: 15),
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: responseOfApi.length,
                        itemBuilder: (context, index) {
                          return bookingStatusResponseCard(
                              responseOfApi, index);
                        }),
                  )
                : loading == true
                    ? Expanded(
                        child: Center(child: CircularProgressIndicator()))
                    : noData == true
                        ? Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              "No Booking",
                              style: TextStyle(
                                  color: Colors.grey.shade300,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        : Container(),
            responseOfApi.isNotEmpty || noData == true
                ? isBtnLoading == false
                    ? Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primary2Color),
                          onPressed: () {
                            setState(() {
                              isBtnLoading = true;
                            });
                            checkWlanForCheckStatus();
                          },
                          child: Text("CHECK STATUS / BOOK ORDER"),
                        ))
                    : Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: CenterCircularProgressIndicator(),
                      )
                : Container()
          ],
        ),
      ),
    );
  }

  getResponseProductApiList() {
    int? id;
    String value =
        productSearchController.text.split('--').first.removeAllWhitespace;
    myGetxController.isMainProductTrueProductList.forEach((element) {
      if (element['default_code'] == value.trim()) {
        id = element['id'];
        productRent = element['rent'];
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
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            getData(value, id ?? 0, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
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
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            checkingStatus(value, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  getData(String apiUrl, int id, String token) async {
    setState(() {
      loading = true;
    });
    final response = await http.put(
        Uri.parse("http://$apiUrl/api/product.product/$id/get_booking_status"),
        headers: {
          'Access-Token': token,
        });
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['status'] == 1) {
      setState(() {
        isDisplayResponseApiList = true;
        loading = false;
      });
      responseOfApi = data['results'];
    } else {
      setState(() {
        noData = true;
        loading = false;
      });
    }
  }

  Future<void> checkingStatus(apiUrl, token) async {
    int? id = getIdFromTextFieldData(productSearchController.text);
    if (deliveryDate != null && returnDate != null) {
      final response = await http.put(
          Uri.parse(
              "http://$apiUrl/api/product.product/$id/checking_product_api?product_id=$id&delivery_date=$deliveryDate&return_date=$returnDate"),
          headers: {
            'Access-Token': token,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 1) {
          setState(() {
            isBtnLoading = false;
          });
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
          setState(() {
            isBtnLoading = false;
          });
          dialog(context, data['msg'], Colors.red.shade300);
        }
      }
    } else {
      setState(() {
        isBtnLoading = false;
      });
      dialog(context, "Please Select Delivery Date and Return Date!",
          Colors.red.shade300);
    }
  }
}

void getProductList() {
  MyGetxController myGetxController = Get.find();
  if (myGetxController.isMainProductTrueProductList.isEmpty == true) {
    getStringPreference('ProductList').then((value) async {
      Map<String, dynamic> data = await jsonDecode(value);
      List<dynamic> lst = await data['results'];
      lst.forEach((element) {
        if (element['is_main_product'] == true) {
          myGetxController.isMainProductTrueProductList.add(element);
        }
      });
    });
  }
}

int? getIdFromTextFieldData(String productSearchControllerText) {
  MyGetxController myGetxController = Get.find();
  int? id;
  String value = productSearchControllerText.split(' ').first;
  myGetxController.isMainProductTrueProductList.forEach((element) {
    if (element['default_code'] == value) {
      id = element['id'];
    }
  });
  return id;
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
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
              child: FadeInLeft(
                child: backArrowIcon,
              )),
          SizedBox(
            width: 10,
          ),
          FadeInLeft(
            child: Text(
              screenName.toString(),
              style: pageTitleTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
