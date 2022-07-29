import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/booking%20status/booking_status.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../Utils/utils.dart';
import '../../constant/constant.dart';

class EditOrder extends StatefulWidget {
  const EditOrder(
      {Key? key,
      this.name,
      this.number,
      this.deliveryDate,
      this.returnDate,
      this.id,
      this.remarks,
      this.index})
      : super(key: key);
  final String? name;
  final String? number;
  final String? deliveryDate;
  final String? returnDate;
  final String? remarks;
  final String? id;
  final int? index;

  @override
  State<EditOrder> createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  String deliveryDate = "";
  String returnDate = "";
  DateTime notFormatedDDate = DateTime.now();
  DateTime? notFormatedRDate = DateTime.now();
  MyGetxController myGetxController = Get.find();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name ?? "";
    numberController.text = widget.number ?? "";
    remarkController.text = widget.remarks ?? "";
    deliveryDate = widget.deliveryDate ?? "";
    returnDate = widget.returnDate ?? "";
    notFormatedDDate = DateFormat("dd/MM/yyyy").parse(deliveryDate);
    notFormatedRDate = DateFormat("dd/MM/yyyy").parse(returnDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          allScreenInitialSizedBox(context),
          ScreenAppBar(
            screenName: "Edit Order",
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: getWidth(0.04, context), vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Name : ",
                  style: primaryStyle,
                ),
                Container(
                  width: getWidth(0.65, context),
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
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: getWidth(0.04, context),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mobile : ",
                  style: primaryStyle,
                ),
                Container(
                  width: getWidth(0.65, context),
                  child: textFieldWidget(
                      "Mobile Number",
                      numberController,
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
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: getWidth(0.04, context), vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Remark :",
                  style: primaryStyle,
                ),
                Container(
                  width: getWidth(0.65, context),
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
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: getWidth(0.04, context)),
            child: Row(
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
                        notFormatedDDate = value;
                        setState(() {
                          deliveryDate = DateFormat('dd/MM/yyyy').format(value);
                        });
                      }
                    });
                  },
                  child: Container(
                    width: getWidth(0.65, context),
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
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: getWidth(0.04, context)),
            child: Row(
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
                      notFormatedRDate = value;
                      if (value != null) {
                        setState(() {
                          returnDate = DateFormat('dd/MM/yyyy').format(value);
                        });
                      }
                    });
                  },
                  child: Container(
                    width: getWidth(0.65, context),
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
          ),
          Obx(() => myGetxController.isUpdateData.value == false
              ? Padding(
                  padding: const EdgeInsets.all(15),
                  child: SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primary2Color),
                        onPressed: () {
                          myGetxController.isUpdateData.value = true;
                          FocusScope.of(context).unfocus();
                          checkWifiForupdateOrder();
                        },
                        child: Text("UPDATE"),
                      )),
                )
              : Padding(
                  padding: const EdgeInsets.all(15),
                  child: CenterCircularProgressIndicator(),
                ))
        ],
      ),
    );
  }

  Future<void> checkWifiForupdateOrder() async {
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                updateData(value, token, widget.id ?? "");
                // updateDetail(value, token, widget.lineId);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            updateData(value, token, widget.id ?? "");
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  Future<void> updateData(String apiUrl, String token, String orderId) async {
    String name = nameController.text;
    String number = numberController.text;
    String remark = remarkController.text;
    String dDate = DateFormat('MM/dd/yyyy').format(notFormatedDDate);
    String rDate =
        DateFormat('MM/dd/yyyy').format(notFormatedRDate ?? DateTime.now());
    var body = {
      'customer_name': name,
      'mobile1': number,
      'remarks': remark,
      'delivery_date': dDate,
      'return_date': rDate
    };
    final response = await http.put(
        Uri.parse("http://$apiUrl/api/rental.rental/$orderId"),
        body: jsonEncode(body),
        headers: {'Access-Token': token, 'Content-Type': 'text/plain'});
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      updateQuotationData(apiUrl, token, orderId);
      myGetxController.isUpdateData.value = false;
    } else {
      dialog(context, data['error_descrip'], Colors.red.shade300);
      myGetxController.isUpdateData.value = false;
    }
  }

  Future<void> updateQuotationData(
      String apiUrl, String token, String orderId) async {
    final response = await http.get(
        Uri.parse("http://$apiUrl/api/rental.rental/$orderId"),
        headers: {'Access-Token': token, 'Content-Type': 'application/http'});
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      myGetxController.quotationData.removeAt(widget.index ?? 0);
      myGetxController.quotationData.insert(widget.index ?? 0, data);
      Navigator.pop(context);
    } else {
      dialog(context, "Error In Getting Data", Colors.red.shade300);
    }
  }
}
