import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:gj5_rental/constant/constant.dart';
import 'package:searchfield/searchfield.dart';

import '../../booking status/booking_status.dart';
import '../order_detail.dart';

class ConfirmOrderAddSubProduct extends StatefulWidget {
  final int orderId;
  final int orderLineId;
  final String deliveryDate;
  final String returnDate;
  final String remark;
  final String rent;
  final String productName;
  final List<dynamic> subProductList;

  const ConfirmOrderAddSubProduct(
      {Key? key,
      required this.productName,
      required this.subProductList,
      required this.orderLineId,
      required this.orderId,
      required this.deliveryDate,
      required this.returnDate,
      required this.remark,
      required this.rent})
      : super(key: key);

  @override
  State<ConfirmOrderAddSubProduct> createState() =>
      _ConfirmOrderAddProductState();
}

class _ConfirmOrderAddProductState extends State<ConfirmOrderAddSubProduct> {
  List wholeSubProductList = [];
  List<List<dynamic>> subProductList = [];
  List<TextEditingController> productControllers = [];
  List<TextEditingController> remarkControllerList = [];
  List<bool> isShowRemark = [];
  bool isDataLoad = true;
  List<Map<String, dynamic>> updatedDictionary = [];

  @override
  void initState() {
    super.initState();
    wholeSubProductList.addAll(widget.subProductList);
    checkWlanForGettingData(false);
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
              screenName: "Add Sub Product In Order",
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          widget.productName,
                          style: allCardSubText,
                          textAlign: TextAlign.center,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primary2Color.withOpacity(0.1),
                            border: Border.all(
                                color: primary2Color.withOpacity(0.5),
                                width: 0.3)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      subProductList.length == wholeSubProductList.length
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: wholeSubProductList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            FittedBox(
                                              child: Container(
                                                width: getWidth(0.15, context),
                                                child: Text(
                                                  wholeSubProductList[index]
                                                      ['product_type'],
                                                  style: primaryStyle,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: getWidth(0.65, context),
                                              margin: EdgeInsets.only(left: 5),
                                              child: SearchField(
                                                controller:
                                                    productControllers[index],
                                                suggestionsDecoration:
                                                    BoxDecoration(
                                                  border: Border.all(
                                                      color: primary2Color),
                                                ),
                                                searchStyle: primaryStyle,
                                                searchInputDecoration:
                                                    InputDecoration(
                                                        suffixIcon:
                                                            productControllers[index]
                                                                    .text
                                                                    .isNotEmpty
                                                                ? InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        productControllers[index]
                                                                            .clear();
                                                                      });
                                                                      FocusScope.of(
                                                                              context)
                                                                          .unfocus();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          cancelIcon,
                                                                    ),
                                                                  )
                                                                : null,
                                                        hintText:
                                                            "Search Product",
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey.shade400),
                                                        filled: true,
                                                        fillColor: Colors.grey
                                                            .withOpacity(0.1),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                                  primary2Color),
                                                        )),
                                                onSuggestionTap: (val) {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                },
                                                itemHeight: 45,
                                                suggestions:
                                                    subProductList[index]
                                                        .map((e) {
                                                  if (e['name'] != null &&
                                                      e['default_code'] !=
                                                          null) {
                                                    String name = e['name'];
                                                    String code =
                                                        e['default_code'];
                                                    String search =
                                                        "$code -- $name";
                                                    return SearchFieldListItem(
                                                        search);
                                                  }
                                                  return SearchFieldListItem(
                                                      "");
                                                }).toList(),
                                                suggestionAction:
                                                    SuggestionAction.next,
                                              ),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isShowRemark[index] =
                                                        !isShowRemark[index];
                                                  });
                                                },
                                                child: isShowRemark[index] ==
                                                        false
                                                    ? Icon(Icons
                                                        .keyboard_arrow_down_sharp)
                                                    : Icon(Icons
                                                        .keyboard_arrow_up))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        isShowRemark[index] == true
                                            ? Container(
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    remarkContainer(
                                                        context,
                                                        remarkControllerList[
                                                            index],
                                                        0.65,
                                                        0,
                                                        MainAxisAlignment.start)
                                                  ],
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                );
                              })
                          : CenterCircularProgressIndicator(),
                      subProductList.length == wholeSubProductList.length
                          ? Container(
                              width: double.infinity,
                              height: 45,
                              margin: const EdgeInsets.symmetric(vertical: 25),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: primary2Color),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    updatedDictionary.clear();
                                    checkWlanForGettingData(true);
                                  },
                                  child: Text("UPDATE")),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkWlanForGettingData(bool updateData) {
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                updateData == false
                    ? getOrderLine(value, token).whenComplete(() {
                        setPreFillDataInTextField();
                      })
                    : getTextFieldData().whenComplete(() {
                        editOrderLine(value, token, widget.orderLineId);
                      });
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            updateData == false
                ? getOrderLine(value, token).whenComplete(() {
                    setPreFillDataInTextField();
                  })
                : getTextFieldData().whenComplete(() {
                    editOrderLine(value, token, widget.orderLineId);
                  });
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  Future<void> getTextFieldData() async {
    for (int i = 0; i <= wholeSubProductList.length - 1; i++) {
      if (productControllers[i].text.isNotEmpty) {
        String text = productControllers[i].text.split('--').first.trimRight();
        List productList = subProductList[i];
        productList.forEach((e) {
          if (e['default_code'] == text) {
            updatedDictionary.add({
              'id': wholeSubProductList[i]['id'],
              'product_id': e['id'],
              'remarks': remarkControllerList[i].text.toString()
            });
          }
        });
      } else {
        updatedDictionary.add({
          'id': wholeSubProductList[i]['id'],
          'product_id': 0,
          'remarks': remarkControllerList[i].text.toString()
        });
      }
    }
  }

  setPreFillDataInTextField() {
    for (int i = 0; i <= wholeSubProductList.length - 1; i++) {
      if (wholeSubProductList[i]['product_id']['default_code'] != null) {
        String name = wholeSubProductList[i]['product_id']['name'] ?? "";
        String code =
            wholeSubProductList[i]['product_id']['default_code'] ?? "";
        String search = "$code -- $name";
        productControllers[i].text = search;
      }
    }
    setState(() {});
  }

  getOrderLine(String apiUrl, String accessToken) async {
    for (int i = 0; i <= wholeSubProductList.length - 1; i++) {
      String product = wholeSubProductList[i]['product_type'];
      String domain =
          "[('product_type_code', '=', '$product'), ('is_main_product', '=',  False)]";
      var params = {'filters': domain.toString()};
      Uri uri = Uri.parse("http://$apiUrl/api/product.product");
      final finalUri = uri.replace(queryParameters: params);
      final response = await http.get(finalUri,
          headers: {'Access-Token': accessToken, 'Connection': 'keep-alive'});
      try {
        if (response.statusCode == 200) {
          productControllers.add(TextEditingController());
          remarkControllerList.add(TextEditingController());
          isShowRemark.add(false);
          var data = jsonDecode(response.body);
          List<dynamic> lst = [];
          if (data['results'] == {}) {
            subProductList.add(lst);
          } else {
            subProductList.add(data['results']);
          }
          setState(() {});
        } else {
          setState(() {
            isDataLoad = false;
          });
        }
      } catch (e) {
        subProductList.add([]);
      }
    }
  }

  Future<void> editOrderLine(value, token, int orderLineId) async {
    var body = {
      'rent': '${widget.rent}',
      'remarks': '${widget.remark}',
      'delivery_date': '${widget.deliveryDate}',
      'return_date': '${widget.returnDate}',
      'product_details_ids': updatedDictionary
    };
    final response = await http.put(
        Uri.parse("http://$value/api/rental.line/${widget.orderLineId}"),
        body: jsonEncode(body),
        headers: {
          'Access-Token': token,
        });
    if (response.statusCode == 200) {
      checkWlanForOrderDetailScreen(context, widget.orderId).whenComplete(() {
        Navigator.of(context).popUntil(ModalRoute.withName("/OrderScreen"));
      });
    } else if (response.statusCode == 409) {
      final data = jsonDecode(response.body);
      dialog(context, data['error_descrip'], Colors.red.shade300);
    } else {
      dialog(context, "Something Went Wrong !", Colors.red.shade300);
    }
  }
}
