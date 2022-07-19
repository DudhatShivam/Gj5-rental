import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/screen/service/servicecontroller.dart';
import 'package:searchfield/searchfield.dart';

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../booking status/booking_status.dart';
import '../service/service_card.dart';
import '../service/service_status_card.dart';

class ServiceStatusScreen extends StatefulWidget {
  const ServiceStatusScreen({Key? key}) : super(key: key);

  @override
  State<ServiceStatusScreen> createState() => _ServiceStatusScreenState();
}

class _ServiceStatusScreenState extends State<ServiceStatusScreen> {
  ServiceController serviceController = Get.put(ServiceController());
  TextEditingController productSearchController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
          body: Column(
        children: [
          allScreenInitialSizedBox(context),
          ScreenAppBar(screenName: "Service Status"),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Obx(() => SearchField(
                  controller: productSearchController,
                  maxSuggestionsInViewPort: 8,
                  suggestionsDecoration: BoxDecoration(
                    border: Border.all(color: primary2Color),
                  ),
                  searchStyle: primaryStyle,
                  searchInputDecoration: InputDecoration(
                      suffixIcon: productSearchController.text.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                serviceController.serviceStatusList.clear();
                                productSearchController.clear();
                                FocusScope.of(context).unfocus();
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
                    checkWlanForServiceStatus();
                  },
                  itemHeight: 55,
                  suggestions:
                      serviceController.serviceIsMainProductTrueList.map((e) {
                    String search = "${e['default_code']} - ${e['name']}";
                    return SearchFieldListItem(search);
                  }).toList(),
                  suggestionAction: SuggestionAction.next,
                )),
          ),
          SizedBox(
            height: 10,
          ),
          loading == false
              ? Obx(() => serviceController.serviceStatusList.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        itemCount: serviceController.serviceStatusList.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return ServiceStatusCard(
                            list: serviceController.serviceStatusList,
                            index: index,
                          );
                        },
                      ),
                    )
                  : Container())
              : Expanded(child: CenterCircularProgressIndicator())
        ],
      )),
    );
  }

  void checkWlanForServiceStatus() {
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                checkingServiceStatus(value, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            checkingServiceStatus(value, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  void getProductList() {
    getStringPreference('ProductList').then((value) async {
      Map<String, dynamic> data = await jsonDecode(value);
      List<dynamic> lst = await data['results'];
      lst.forEach((element) {
        if (element['is_main_product'] == true) {
          serviceController.serviceIsMainProductTrueList.add(element);
        }
      });
    });
  }

  int? getIdFromTextFieldData() {
    int? id;
    String value = productSearchController.text.split(' ').first;
    serviceController.serviceIsMainProductTrueList.forEach((element) {
      if (element['default_code'] == value) {
        id = element['id'];
      }
    });
    return id;
  }

  Future<void> checkingServiceStatus(apiUrl, token) async {
    setState(() {
      loading = true;
    });
    int? id = getIdFromTextFieldData();
    final response = await http.put(
        Uri.parse("http://$apiUrl/api/product.product/$id/get_service_status"),
        headers: {
          'Access-Token': token,
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        setState(() {
          loading = false;
        });
        dialog(context, "No Service Found", Colors.red.shade300);
      } else if (data['status'] == 1) {
        setState(() {
          loading = false;
        });
        serviceController.serviceStatusList.addAll(data['results']);
      } else {
        setState(() {
          loading = false;
        });
        dialog(context, "Something Went Wrong !", Colors.red.shade300);
      }
    } else {
      setState(() {
        loading = false;
      });
      dialog(context, "Something Went Wrong !", Colors.red.shade300);
    }
  }
}
