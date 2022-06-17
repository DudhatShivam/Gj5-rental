import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../booking status/booking_status.dart';

class EditOrderLine extends StatefulWidget {
  const EditOrderLine(
      {Key? key,
      this.lineId,
      this.deliveryDate,
      this.returnDate,
      this.remark,
      this.wholeSubProductList,
      required this.productCode,
      required this.productName})
      : super(key: key);
  final int? lineId;
  final String? deliveryDate;
  final String? returnDate;
  final String? remark;
  final List<dynamic>? wholeSubProductList;
  final String productCode;
  final String productName;

  @override
  State<EditOrderLine> createState() => _EditOrderLineState();
}

class _EditOrderLineState extends State<EditOrderLine> {
  TextEditingController remarkController = TextEditingController();
  String returnDate = "";
  String deliveryDate = "";
  DateTime? returnNotFormatedDate;
  DateTime? deliveryNotFormatedDate;
  MyGetxController myGetxController = Get.put(MyGetxController());
  List wholesubProductList = [];
  List<List<dynamic>> subProductList = [];
  List<TextEditingController> productControllers = [];
  List<TextEditingController> remarkControllerList = [];
  List<bool> isShowRemark = [];
  bool isDataLoad = true;

  @override
  void initState() {
    super.initState();
    deliveryDate = widget.deliveryDate ?? "";
    returnDate = widget.returnDate ?? "";
    remarkController.text = widget.remark ?? "";
    wholesubProductList.addAll(widget.wholeSubProductList ?? []);
    checkWifiForupdateDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        reverse: true,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.translucent,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + 10,
              ),
              InkWell(
                onTap: () {
                  print(widget.wholeSubProductList?.length);
                },
                child: ScreenAppBar(
                  screenName: "Edit Order Line",
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Text(
                      "Code  : ",
                      style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    Text(
                      widget.productCode.toString(),
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name : ",
                      style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    Expanded(
                      child: Text(
                        widget.productName.toString(),
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
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
                              deliveryDate = "";
                              deliveryDate = DateFormat('dd-MM-yyyy')
                                  .format(deliveryNotFormatedDate!);
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
                          deliveryDate.toString(),
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
                              returnDate = "";
                              returnDate = DateFormat('dd-MM-yyyy')
                                  .format(returnNotFormatedDate!);
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
                          returnDate.toString(),
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
              remarkContainer(context, remarkController, 0.33, 0.02,
                  MainAxisAlignment.spaceBetween),
              SizedBox(
                height: 15,
              ),
              subProductList.length == wholesubProductList.length
                  ? ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: wholesubProductList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FittedBox(
                                      child: Container(
                                        width: getWidth(0.072, context),
                                        child: Text(
                                          wholesubProductList[index]
                                              ['product_type'],
                                          style: primaryStyle,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: getWidth(0.31, context),
                                      margin: EdgeInsets.only(left: 10),
                                      child: SearchField(
                                        controller: productControllers[index],
                                        suggestionsDecoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.teal.shade400),
                                        ),
                                        searchStyle: primaryStyle,
                                        searchInputDecoration: InputDecoration(
                                            suffixIcon:
                                                productControllers[index]
                                                        .text
                                                        .isNotEmpty
                                                    ? InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            productControllers[
                                                                    index]
                                                                .clear();
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
                                                color: Colors.grey.shade400),
                                            filled: true,
                                            fillColor:
                                                Colors.grey.withOpacity(0.1),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.teal),
                                            )),
                                        onSuggestionTap: (val) {
                                          FocusScope.of(context).unfocus();
                                        },
                                        itemHeight: 45,
                                        suggestions:
                                            subProductList[index].map((e) {
                                          if (e['name'] != null &&
                                              e['default_code'] != null) {
                                            String name = e['name'];
                                            String code = e['default_code'];
                                            String search = "$code - $name";
                                            return SearchFieldListItem(search);
                                          }
                                          return SearchFieldListItem("");
                                        }).toList(),
                                        suggestionAction: SuggestionAction.next,
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            isShowRemark[index] =
                                                !isShowRemark[index];
                                          });
                                        },
                                        child: isShowRemark[index] == false
                                            ? Icon(
                                                Icons.keyboard_arrow_down_sharp)
                                            : Icon(Icons.keyboard_arrow_up))
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
                                                remarkControllerList[index],
                                                0.31,
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
                  : CircularProgressIndicator(),
              subProductList.length == wholesubProductList.length
                  ? ElevatedButton(onPressed: () {}, child: Text("update"))
                  : Container(),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 10))
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> updateDetail(
  //   String value,
  //   String token,
  //   int? mainId,
  // ) async {
  //   String updatedRemark = remarkController.text;
  //   String formatDeliveryDate =
  //       DateFormat('MM/dd/yyyy').format(DateTime.parse(deliveryDate));
  //   String formatReturnDate =
  //       DateFormat('MM/dd/yyyy').format(DateTime.parse(returnDate));
  //   mainId = widget.lineId;
  //   var body = {
  //     // 'delivery_date': formatDeliveryDate,
  //     // 'return_date': formatReturnDate,
  //     'remarks': updatedRemark
  //   };
  //   final response = await http.put(
  //       Uri.parse("http://$value/api/rental.line/$mainId"),
  //       body: jsonEncode(body),
  //       headers: {'Access-Token': token, 'Content-Type': 'text/plain'});
  //   print(response.body);
  // }
  //
  void checkWifiForupdateDetail() {
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                getOrderLine();
                // updateDetail(value, token, widget.lineId);
              } else {
                dialog(context, "Connect to Showroom Network");
              }
            });
          } else {
            getOrderLine();
            // updateDetail(value, token, widget.lineId);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network");
      }
    });
  }

  getOrderLine() async {
    String apiUrl = await getStringPreference('apiUrl');
    String accessToken = await getStringPreference('accessToken');
    for (int i = 0; i <= wholesubProductList.length - 1; i++) {
      String product = wholesubProductList[i]['product_type'];
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
        print(e);
        subProductList.add([]);
      }
    }
  }
}
