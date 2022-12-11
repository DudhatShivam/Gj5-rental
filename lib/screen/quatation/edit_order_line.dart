import 'dart:convert';
import 'dart:io';
import '../../Utils/textfield_utils.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:gj5_rental/screen/quatation/quotation_detail.dart';
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
      required this.productName,
      this.orderId,
      this.rent,
      required this.isFromBookingOrderScreen})
      : super(key: key);
  final int? orderId;
  final int? lineId;
  final String? deliveryDate;
  final String? returnDate;
  final String? remark;
  final double? rent;
  final List<dynamic>? wholeSubProductList;
  final String productCode;
  final String productName;
  final bool isFromBookingOrderScreen;

  @override
  State<EditOrderLine> createState() => _EditOrderLineState();
}

class _EditOrderLineState extends State<EditOrderLine> {
  TextEditingController remarkController = TextEditingController();
  TextEditingController rentController = TextEditingController();
  String returnDate = "";
  String deliveryDate = "";
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
    deliveryDate = changeDateFormat(widget.deliveryDate ?? "");
    returnDate = changeDateFormat(widget.returnDate ?? "");
    remarkController.text = widget.remark ?? "";
    rentController.text = widget.rent.toString();
    wholeSubProductList.addAll(widget.wholeSubProductList ?? []);
    checkWifiForupdateDetail(false);
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
              allScreenInitialSizedBox(context),
              ScreenAppBar(screenName: "Edit Order Line"),
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
                          color: primary2Color,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    Text(
                      widget.productCode.toString(),
                      style: allCardMainText,
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
                          color: primary2Color,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    Expanded(
                      child: Text(
                        widget.productName.toString(),
                        style: allCardMainText,
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
                            setState(() {
                              deliveryDate = DateFormat(showGlobalDateFormat)
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
                            setState(() {
                              returnDate = DateFormat(showGlobalDateFormat)
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
              remarkContainer(context, remarkController, 0.65, 0.04,
                  MainAxisAlignment.spaceBetween),
              SizedBox(
                height: 15,
              ),
              Container(
                margin:
                    EdgeInsets.symmetric(horizontal: getWidth(0.04, context)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rent : ",
                      style: primaryStyle,
                    ),
                    Container(
                      width: getWidth(0.65, context),
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
              subProductList.length == wholeSubProductList.length
                  ? ListView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: getWidth(0.04, context)),
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
                                    Container(
                                      width: getWidth(0.15, context),
                                      child: AutoSizeText(
                                        wholeSubProductList[index]
                                            ['product_type'],
                                        style: primaryStyle,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Container(
                                      width: getWidth(0.65, context),
                                      margin: EdgeInsets.only(left: 5),
                                      child: SearchField(
                                        controller: productControllers[index],
                                        suggestionsDecoration: BoxDecoration(
                                          border:
                                              Border.all(color: primary2Color),
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
                                                          child: cancelIcon,
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
                                                  color: primary2Color),
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
                                            String search = "$code -- $name";
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
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 25),
                      child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: primary2Color),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            updatedDictionary.clear();
                            checkWifiForupdateDetail(true);
                          },
                          child: Text("UPDATE")),
                    )
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

  Future<void> updateDetail(
    String value,
    String token,
    int? mainId,
  ) async {
    String remark = remarkController.text;
    String rent = rentController.text;
    String dDate = changeDateFormatTopPassApiDate(deliveryDate);
    String rDate = changeDateFormatTopPassApiDate(returnDate);
    var body = {
      'rent': '$rent',
      'remarks': '$remark',
      'delivery_date': '$dDate',
      'return_date': '$rDate',
      'product_details_ids': updatedDictionary
    };
    final response = await http.put(
        Uri.parse("http://$value/api/rental.line/$mainId"),
        body: jsonEncode(body),
        headers: {
          'Access-Token': token,
        });
    if (response.statusCode == 200) {
      pushMethod(
          context,
          QuatationDetailScreen(
            id: widget.orderId,
            isFromAnotherScreen: widget.isFromBookingOrderScreen,
          ));
    } else if (response.statusCode == 409) {
      final data = jsonDecode(response.body);
      dialog(context, data['error_descrip'], Colors.red.shade300);
    } else {
      dialog(context, "Something Went Wrong !", Colors.red.shade300);
    }
  }

  void checkWifiForupdateDetail(bool isUpdateData) {
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                isUpdateData == false
                    ? getOrderLine(value, token).whenComplete(() {
                        setPreFillDataInTextField();
                      })
                    : getTextFieldData().whenComplete(() {
                        confirmationDialogForEditOrderLine(
                            value, token, widget.lineId);
                      });
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            isUpdateData == false
                ? getOrderLine(value, token).whenComplete(() {
                    setPreFillDataInTextField();
                  })
                : getTextFieldData().whenComplete(() {
                    confirmationDialogForEditOrderLine(
                        value, token, widget.lineId);
                  });
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  Future<void> getOrderLine(String apiUrl, String accessToken) async {
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
        if (wholeSubProductList[i]['remarks'] != null) {
          remarkControllerList[i].text = wholeSubProductList[i]['remarks'];
        }
        String name = wholeSubProductList[i]['product_id']['name'] ?? "";
        String code =
            wholeSubProductList[i]['product_id']['default_code'] ?? "";
        String search = "$code -- $name";
        productControllers[i].text = search;
      }
    }
    setState(() {});
  }

  confirmationDialogForEditOrderLine(
    String value,
    String token,
    int? mainId,
  ) {
    return showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sure , Are you want to update ?",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 19,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green.shade300),
                          onPressed: () {
                            Navigator.pop(context);
                            updateDetail(value, token, mainId);
                          },
                          child: Text("Ok")),
                      SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red.shade300),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel")),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
