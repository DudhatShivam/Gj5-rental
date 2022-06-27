import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import 'booking_status.dart';

class BookOrder extends StatefulWidget {
  const BookOrder(
      {Key? key,
      this.deliveryDate,
      this.returnDate,
      this.productName,
      this.productId,
      this.rent})
      : super(key: key);
  final String? deliveryDate;
  final String? returnDate;
  final String? productName;
  final int? productId;
  final double? rent;

  @override
  State<BookOrder> createState() => _BookOrderState();
}

class _BookOrderState extends State<BookOrder> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController number2Controller = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController rentController = TextEditingController();
  String returnDate = "";
  String deliveryDate = "";
  DateTime returnNotFormatedDate = DateTime.now();
  DateTime deliveryNotFormatedDate = DateTime.now();
  bool isValidRDate = true;
  bool isBtnLoading = false;

  @override
  void initState() {
    super.initState();
    print(widget.productName);
    deliveryDate = widget.deliveryDate ?? "";
    returnDate = widget.returnDate ?? "";
    deliveryNotFormatedDate = new DateFormat("dd/MM/yyyy").parse(deliveryDate);
    returnNotFormatedDate = DateFormat("dd/MM/yyyy").parse(returnDate);
    rentController.text = widget.rent.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          reverse: true,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              ScreenAppBar(screenName: "Booking Order"),
              SizedBox(
                height: 10,
              ),
              Container(
                margin:
                    EdgeInsets.symmetric(horizontal: getWidth(0.02, context)),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 45,
                      width: double.infinity,
                      color: Colors.grey.withOpacity(0.1),
                      child: Text(
                        widget.productName.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: primaryColor),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name : ",
                                style: primaryStyle,
                              ),
                              Container(
                                width: getWidth(0.33, context),
                                child: textFieldWidget(
                                    "Customer Name",
                                    nameController,
                                    false,
                                    false,
                                    Colors.grey.withOpacity(0.1),
                                    TextInputType.text,
                                    0,
                                    Colors.greenAccent,
                                    1),
                              )
                            ],
                          ), //name
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Address : ",
                                style: primaryStyle,
                              ),
                              FittedBox(
                                child: Container(
                                  width: getWidth(0.33, context),
                                  child: textFieldWidget(
                                      "Address",
                                      addressController,
                                      false,
                                      false,
                                      Colors.grey.withOpacity(0.1),
                                      TextInputType.text,
                                      0,
                                      Colors.greenAccent,
                                      3),
                                ),
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
                                "Mobile : ",
                                style: primaryStyle,
                              ),
                              FittedBox(
                                child: Container(
                                  width: getWidth(0.33, context),
                                  child: numberValidatorTextfield(
                                      numberController, "Mobile number"),
                                ),
                              )
                            ],
                          ),

                          //number
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Mobile2 : ",
                          style: primaryStyle,
                        ),
                        Container(
                          width: getWidth(0.33, context),
                          child: numberValidatorTextfield(
                              number2Controller, "Mobile number2"),
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
                              TextInputType.text,
                              0,
                              Colors.greenAccent,
                              1),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "D Date : ",
                            style: primaryStyle,
                          ),
                          InkWell(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              pickedDate(context).then((value) {
                                if (value != null) {
                                  deliveryNotFormatedDate = value;
                                  setState(() {
                                    deliveryDate = DateFormat('dd/MM/yyyy')
                                        .format(deliveryNotFormatedDate);
                                  });
                                }
                              });
                            },
                            child: Container(
                              width: getWidth(0.33, context),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey.shade400,
                                    size: 22,
                                  ),
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
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "R Date : ",
                            style: primaryStyle,
                          ),
                          InkWell(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              pickedDate(context).then((value) {
                                if (value != null) {
                                  returnNotFormatedDate = value;
                                  setState(() {
                                    isValidRDate = true;
                                    returnDate = DateFormat('dd/MM/yyyy')
                                        .format(returnNotFormatedDate!);
                                  });
                                }
                              });
                            },
                            child: Container(
                              width: getWidth(0.33, context),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: 48,
                              decoration: BoxDecoration(
                                border: isValidRDate == true
                                    ? null
                                    : Border.all(color: Colors.red),
                                color: Colors.grey.withOpacity(0.1),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey.shade400,
                                    size: 22,
                                  ),
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
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    isBtnLoading == false
                        ? Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ==
                                          true &&
                                      nameController.text.isNotEmpty &&
                                      numberController.text.isNotEmpty &&
                                      addressController.text.isNotEmpty) {
                                    checkValidation();
                                  }
                                },
                                child: Text("BOOK NOW")),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: CircularProgressIndicator(),
                          ),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  checkValidation() {
    if (deliveryNotFormatedDate.isBefore(returnNotFormatedDate) == true) {
      checkWlanForBookOrder();
    } else {
      setState(() {
        isValidRDate = false;
      });
      dialog(
          context, "You can not select Delivery date bigger than Return Date!");
    }
  }

  checkWlanForBookOrder() {
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                bookOrder(value, token);
              } else {
                dialog(context, "Connect to Showroom Network");
              }
            });
          } else {
            bookOrder(value, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network");
      }
    });
  }

  Future<void> bookOrder(apiUrl, token) async {
    setState(() {
      isBtnLoading = true;
    });
    String url = "";
    int productId = widget.productId ?? 0;
    String name = nameController.text;
    String number = numberController.text;
    String number2 = number2Controller.text;
    String address = addressController.text;
    String rent = rentController.text;
    String dDate = DateFormat('MM/dd/yyyy').format(deliveryNotFormatedDate);
    String rDate = DateFormat('MM/dd/yyyy').format(returnNotFormatedDate);

    url =
        "http://$apiUrl/api/product.product/$productId/booked_order_api?product_id=$productId&delivery_date=$dDate&return_date=$rDate&customer_name=$name&mobile1=$number&mobile2=$number2&delivery_address=$address&rent=$rent";

    final response = await http.put(Uri.parse(url), headers: {
      'Access-Token': token,
    });
    var data = jsonDecode(response.body);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 1) {
        setState(() {
          isBtnLoading = false;
        });
        getDraftOrderData(context, apiUrl, token, data['rental_id']);
      } else {
        setState(() {
          isBtnLoading = false;
        });
        dialog(context, data['msg']);
      }
    } else {
      setState(() {
        isBtnLoading = false;
      });
      dialog(context, "Something Went Wrong !");
    }
  }
}
