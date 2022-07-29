import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/screen/service/service_card.dart';
import 'package:gj5_rental/screen/service/service_detail_card.dart';
import 'package:gj5_rental/screen/service/servicecontroller.dart';
import 'package:http/http.dart' as http;

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../quatation/quotation_detail.dart';

class ServiceDetailScreen extends StatefulWidget {
  final int serviceLineId;
  final bool? isFromAnotherScreen;

  const ServiceDetailScreen(
      {Key? key, required this.serviceLineId, this.isFromAnotherScreen})
      : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  ServiceController serviceController = Get.put(ServiceController());

  @override
  void initState() {
    checkWlanForGetData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => pushFunction(),
      child: Scaffold(
        floatingActionButton: CustomFABWidget(
          transitionType: ContainerTransitionType.fade,
          isAddProductInService: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            allScreenInitialSizedBox(context),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        pushFunction();
                      },
                      child: FadeInLeft(
                        child: backArrowIcon,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  FadeInLeft(
                    child: Text(
                      "Service",
                      style: pageTitleTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            Obx(() => serviceController.particularServiceList.isNotEmpty
                ? ServiceCard(
                    list: serviceController.particularServiceList,
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
                      color: primary2Color),
                ),
              ),
            ),
            Expanded(
                child: Obx(() => serviceController.serviceLineList.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: serviceController.serviceLineList.length,
                        itemBuilder: (context, index) {
                          return ServiceDetailCard(
                            list: serviceController.serviceLineList,
                            index: index,
                            isServiceLineSceen: false,
                            isFromNotificationScreen: false,
                          );
                        },
                      )
                    : Container()))
          ],
        ),
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
                getDataOfServiceDetail(
                    context, apiUrl, token, widget.serviceLineId);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            getDataOfServiceDetail(
                context, apiUrl, token, widget.serviceLineId);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  pushFunction() {
    Navigator.of(context).popUntil(ModalRoute.withName("/ServiceHome"));
  }
}

Future<void> getDataOfServiceDetail(BuildContext context, String apiUrl,
    String token, int serviceLineId) async {
  ServiceController serviceController = Get.find();
  serviceController.particularServiceList.clear();
  serviceController.serviceLineList.clear();
  final response = await http.get(
      Uri.parse("http://$apiUrl/api/service.service/$serviceLineId"),
      headers: {'Access-Token': token, 'Connection': 'keep-alive'});
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    serviceController.particularServiceList.add(data);
    serviceController.serviceLineList.addAll(data['service_line_ids']);
  } else {
    dialog(context, "Something Went Wrong !", Colors.red.shade300);
  }
}
