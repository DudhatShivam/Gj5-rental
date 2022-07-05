import 'dart:convert';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:gj5_rental/screen/service/service_card.dart';
import 'package:gj5_rental/screen/service/service_detail_card.dart';
import 'package:http/http.dart' as http;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/booking%20status/booking_status.dart';

import '../../Utils/utils.dart';

class ServiceDetailScreen extends StatefulWidget {
  final int serviceLineId;

  const ServiceDetailScreen({Key? key, required this.serviceLineId})
      : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  MyGetxController myGetxController = Get.find();

  @override
  void initState() {
    myGetxController.particularServiceList.clear();
    myGetxController.serviceLineList.clear();
    checkWlanForGetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 10,
          ),
          ScreenAppBar(screenName: "Service"),
          Obx(() => myGetxController.particularServiceList.isNotEmpty
              ? ServiceCard(
                  list: myGetxController.particularServiceList,
                  index: 0,
                  backGroundColor: Colors.grey.withOpacity(0.1),
                )
              : Container()),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: FadeInLeft(
              child: Text(
                "Service Detail :",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 23,
                    color: Colors.teal),
              ),
            ),
          ),
          Expanded(
              child: Obx(() => myGetxController.serviceLineList.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: myGetxController.serviceLineList.length,
                      itemBuilder: (context, index) {
                        return ServiceDetailCard(
                          list: myGetxController.serviceLineList,
                          index: index,
                        );
                      },
                    )
                  : Container()))
        ],
      ),
    );
  }

  void checkWlanForGetData() {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                getDataOfServiceDetail(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            getDataOfServiceDetail(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  getDataOfServiceDetail(String apiUrl, String token) async {
    final response = await http.get(
        Uri.parse("http://$apiUrl/api/service.service/${widget.serviceLineId}"),
        headers: {'Access-Token': token, 'Connection': 'keep-alive'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      myGetxController.particularServiceList.add(data);
      myGetxController.serviceLineList.addAll(data['service_line_ids']);
    } else {
      dialog(context, "Something Went Wrong !", Colors.red.shade300);
    }
  }
}
