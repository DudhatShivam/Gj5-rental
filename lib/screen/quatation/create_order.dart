import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/booking%20status/booking_status.dart';
import 'package:gj5_rental/screen/quatation/quotation_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import 'package:intl/intl.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({Key? key}) : super(key: key);

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  MyGetxController myGetxController = Get.find();
  final _formKey = GlobalKey<FormState>();
  String returnDate = "";
  String deliveryDate = "";
  String DformatedDate="";
  String RformatedDate="";
  DateTime? returnNotFormatedDate;
  DateTime deliveryNotFormatedDate = DateTime.now();
  bool initialValidDDate = true;
  bool initialValidRDate = true;
  bool isValidDDate = true;
  bool isValidRDate = true;

  @override
  void initState() {
    super.initState();
    nameController.text="jenil";
    numberController.text="9925283071";
    addressController.text="varachha";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 10,
            ),
            ScreenAppBar(screenName: "Create Order"),
            SizedBox(
              height: 25,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: getWidth(0.02, context)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Name : ",
                          style: primaryStyle,
                        ),
                        Container(
                          width: getWidth(0.33, context),
                          child: textFieldWidget(
                              "Name",
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
                    ),
                  ), //name
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: getWidth(0.02, context)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Number : ",
                          style: primaryStyle,
                        ),
                        Container(
                          width: getWidth(0.33, context),
                          child: numberValidatorTextfield(numberController, "Mobile number"),
                        )
                      ],
                    ),
                  ), //number
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: getWidth(0.02, context)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Address : ",
                          style: primaryStyle,
                        ),
                        Container(
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
                        )
                      ],
                    ),
                  ), //address
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            remarkContainer(context, remarkController, 0.33, 0.02,
                MainAxisAlignment.spaceBetween),
            SizedBox(
              height: 25,
            ),
            Container(
              margin:
                  EdgeInsets.symmetric(horizontal: getWidth(0.02, context)),
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
                            isValidDDate = true;
                            initialValidDDate = true;
                            deliveryDate = DateFormat('MM/dd/yyyy')
                                .format(deliveryNotFormatedDate);
                            DformatedDate = DateFormat('dd/MM/yyyy')
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
                        border:
                            isValidDDate == true && initialValidDDate == true
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
                            DformatedDate,
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
              height: 25,
            ),
            Container(
              margin:
                  EdgeInsets.symmetric(horizontal: getWidth(0.02, context)),
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
                            initialValidRDate = true;
                            returnDate = DateFormat('MM/dd/yyyy')
                                .format(returnNotFormatedDate!);
                            RformatedDate = DateFormat('dd/MM/yyyy')
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
                        border:
                            isValidRDate == true && initialValidRDate == true
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
                            RformatedDate,
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
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() == true &&
                        nameController.text.isNotEmpty &&
                        numberController.text.isNotEmpty &&
                        addressController.text.isNotEmpty) {
                      checkValidation();
                    }
                  },
                  child: Text("Create Order")),
            ),
            Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 10))
          ],
        ),
      ),
    );
  }

  checkValidation() {
    if (returnDate == "" || deliveryDate == "") {
      setState(() {
        isValidDDate = false;
        isValidRDate = false;
        initialValidDDate = false;
        initialValidRDate = false;
      });
    } else {
      if (deliveryNotFormatedDate
              .isBefore(returnNotFormatedDate ?? DateTime.now()) ==
          true) {
        print("all set");
        checkWifiForCreateOrder();
        // saveInCart();
        // myGetxController.badgeText.value++;
      } else {
        setState(() {
          isValidRDate = false;
        });
        showInSnackBar(
            "You can not select Delivery date bigger than Return Date!",
            context);
      }
    }
  }

  // Future<void> saveInCart() async {
  //   Map data = {
  //     'name': nameController.text,
  //     'number': numberController.text,
  //     'address': addressController.text,
  //     'remark': remarkController.text,
  //     'ddate': deliveryDate,
  //     'rdate': returnDate
  //   };
  //   myGetxController.quotationCartList.add(data);
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences
  //       .setString("cartList", jsonEncode(myGetxController.quotationCartList))
  //       .whenComplete(() => Navigator.pop(context));
  // }

  checkWifiForCreateOrder() {
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                createOrder(value, token.toString());
              } else {
                dialog(context, "Connect to Showroom Network");
              }
            });
          } else {
            createOrder(value, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network");
      }
    });
  }

  Future<void> createOrder(String apiUrl, String token) async {
    print(deliveryDate);
    print(returnDate);
    final partnerIdResponse =
        await http.post(Uri.parse("http://$apiUrl/api/res.customer"),
            headers: {'Access-Token': token},
            body: jsonEncode({
              'name': nameController.text,
              'mobile1': numberController.text,
              'address': addressController.text
            }));
    Map data = jsonDecode(partnerIdResponse.body);
    var body = {
      'partner_id': data['id'],
      'mobile1': numberController.text,
      'delivery_address': addressController.text,
      'delivery_date': deliveryDate,
      'return_date': returnDate,
      'remarks': remarkController.text
    };
    final response =
        await http.post(Uri.parse("http://$apiUrl/api/rental.rental"),
            headers: {
              'Access-Token': token,
            },
            body: jsonEncode(body));
    print(response.body);

    Map datas = jsonDecode(response.body);
    getDraftOrderData(context, apiUrl, token, datas['id']);
  }
}
