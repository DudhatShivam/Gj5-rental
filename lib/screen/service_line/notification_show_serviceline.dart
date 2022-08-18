import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:gj5_rental/screen/order/order_detail.dart';
import 'package:http/http.dart' as http;

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../service/service_detail_card.dart';

class NotificationServiceLine extends StatefulWidget {
  final int id;

  const NotificationServiceLine({Key? key, required this.id}) : super(key: key);

  @override
  State<NotificationServiceLine> createState() =>
      _NotificationServiceLineState();
}

class _NotificationServiceLineState extends State<NotificationServiceLine> {
  List<dynamic> serviceLineList = [];

  @override
  void initState() {
    super.initState();
    checkWlanForNotificationService();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => popFunction(context, true),
      child: Scaffold(
        body: Column(
          children: [
            allScreenInitialSizedBox(context),
            CommonPushMethodAppBar(
                title: "Service Line", isFormAnotherScreen: true),
            ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 15),
                physics: NeverScrollableScrollPhysics(),
                itemCount: serviceLineList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ServiceDetailCard(
                    list: serviceLineList,
                    index: index,
                    isServiceLineSceen: true,
                    isFromNotificationScreen: true,
                    isFromServiceScreen: false,
                  );
                })
          ],
        ),
      ),
    );
  }

  void checkWlanForNotificationService() {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                getDataOfServiceLine(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            getDataOfServiceLine(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  getDataOfServiceLine(String apiUrl, String token) async {
    final response = await http.get(
        Uri.parse("http://$apiUrl/api/product.service.line/${widget.id}"),
        headers: {'Access-Token': token, 'Connection': 'keep-alive'});
    if (response.statusCode == 200) {
      setState(() {
        serviceLineList.add(jsonDecode(response.body));
      });
    } else {
      dialog(context, "Something Went Wrong", Colors.red.shade300);
    }
  }
}
