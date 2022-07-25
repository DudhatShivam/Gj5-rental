import 'dart:convert';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/screen/service/servicecontroller.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gj5_rental/screen/booking%20status/booking_status.dart';

import '../../../Utils/utils.dart';
import '../../../constant/constant.dart';
import '../service.dart';
import '../service_detail.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({Key? key}) : super(key: key);

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  String? serviceSelection;
  String? selectedValue;
  List partnerList = [];
  List<String> serviceOrderLineDropDownList = [];
  TextEditingController remarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          allScreenInitialSizedBox(context),
          ScreenAppBar(
            screenName: "Create Service",
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getWidth(0.02, context), vertical: 10),
            child: Row(
              children: [
                Text(
                  "Service Type :",
                  style: primaryStyle,
                ),
                Row(
                  children: [
                    Radio(
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => primary2Color),
                        value: "washing",
                        groupValue: serviceSelection,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = null;
                            serviceOrderLineDropDownList.clear();
                            serviceSelection = value.toString();
                            checkWlanForServiceCreation(true, value.toString());
                          });
                        }),
                    Text(
                      "Washing",
                      style: primaryStyle,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => primary2Color),
                        value: "stitching",
                        groupValue: serviceSelection,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = null;
                            serviceOrderLineDropDownList.clear();
                            serviceSelection = value.toString();
                            checkWlanForServiceCreation(true, value.toString());
                          });
                        }),
                    Text(
                      "Stitching",
                      style: primaryStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 10, horizontal: getWidth(0.02, context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Partner :",
                  style: primaryStyle,
                ),
                InkWell(
                  onTap: () {
                    if (selectedValue == null) {
                      showToast("Select Service Type");
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10)),
                    height: 48,
                    width: getWidth(0.31, context),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        buttonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        hint: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Select Partner',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        items: serviceOrderLineDropDownList
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      item,
                                      style: primaryStyle,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as String;
                          });
                        },
                        buttonHeight: 40,
                        buttonWidth: getWidth(0.25, context),
                        itemHeight: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          remarkContainer(context, remarkController, 0.31, 0.02,
              MainAxisAlignment.spaceBetween),
          SizedBox(
            height: 10,
          ),
          selectedValue != null
              ? Container(
                  width: double.infinity,
                  height: 45,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primary2Color),
                      onPressed: () {
                        checkWlanForServiceCreation(false, "");
                      },
                      child: Text("CREATE SERVICE")),
                )
              : Container(
                  width: double.infinity,
                  height: 45,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade100),
                      onPressed: () {
                        showToast("Select Partner");
                      },
                      child: Text("CREATE SERVICE")),
                )
        ],
      ),
    );
  }

  checkWlanForServiceCreation(bool isPartnerData, String value) {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                isPartnerData == true
                    ? getResPartner(apiUrl, token, value)
                    : createService(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            isPartnerData == true
                ? getResPartner(apiUrl, token, value)
                : createService(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  getResPartner(apiUrl, token, String value) async {
    String domain =
        "[('vendor_type'  , '='  , 'service'),('service_type'  , '='  , '$value')]";
    var params = {'filters': domain.toString()};
    Uri uri = Uri.parse("http://$apiUrl/api/res.partner");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri, headers: {
      'Access-Token': token,
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['count'] != 0) {
        partnerList = data['results'];
        partnerList.forEach((element) {
          serviceOrderLineDropDownList.add(element['name']);
        });
        setState(() {});
      }
    } else {
      dialog(context, "Something Went Wrong !", Colors.red.shade300);
    }
  }

  createService(apiUrl, token) async {
    ServiceController serviceController = Get.find();
    int? partnerId;
    partnerList.forEach((element) {
      if (element['name'] == selectedValue) {
        partnerId = element['id'];
      }
    });
    var body = {
      'service_partner_id': partnerId,
      'service_type': serviceSelection,
      'remarks': remarkController.text
    };
    final response =
        await http.post(Uri.parse("http://$apiUrl/api/service.service"),
            headers: {
              'Access-Token': token,
            },
            body: jsonEncode(body));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      serviceScreenOffset = 0;
      serviceController.serviceList.clear();
      getDataOfServiceScreen(context, apiUrl, token).whenComplete(() {
        pushMethod(
            context,
            ServiceDetailScreen(
              serviceLineId: data['id'],
              isFromAnotherScreen: true,
            ));
      });
    } else {
      dialog(context, "Something Went Wrong !", Colors.red.shade300);
    }
  }
}
