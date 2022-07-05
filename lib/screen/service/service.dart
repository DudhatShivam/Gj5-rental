import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/service/service_detail.dart';
import 'package:http/http.dart' as http;

import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gj5_rental/screen/service/service_card.dart';

import '../../Utils/utils.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final GlobalKey<ExpansionTileCardState> findCard = new GlobalKey();
  MyGetxController myGetxController = Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (myGetxController.serviceList.isEmpty) {
      checkWlanForServiceScreenData(false);
    }
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        serviceScreenOffset = serviceScreenOffset + 10;
        checkWlanForServiceScreenData(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 10,
          ),
          ExpansionTileCard(
            trailing: FadeInRight(
              child: Icon(
                Icons.search,
                size: 30,
                color: Colors.teal,
              ),
            ),
            key: findCard,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: FadeInLeft(
                            child: Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Colors.teal,
                            ),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      FadeInLeft(
                        child: Text(
                          "Service",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 23,
                              color: Colors.teal),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                    onTap: () {
                      myGetxController.serviceList.clear();
                      checkWlanForServiceScreenData(false);
                    },
                    child: FadeInRight(
                        child:
                            Icon(Icons.refresh, size: 30, color: Colors.teal)))
              ],
            ),
            elevation: 0,
            shadowColor: Colors.white,
            initialElevation: 0,
            borderRadius: BorderRadius.circular(0),
            baseColor: Colors.transparent,
            expandedColor: Colors.transparent,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      "Find Service :",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.blueGrey),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child:
                        ElevatedButton(onPressed: () {}, child: Text("Search")),
                  ),
                ],
              )
            ],
          ),
          Expanded(
            child: Obx(() => myGetxController.serviceList.isNotEmpty
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: myGetxController.serviceList.length,
                    shrinkWrap: true,
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return ServiceCard(
                        list: myGetxController.serviceList,
                        index: index,
                        backGroundColor: Colors.white,
                        onTap: () => pushMethod(
                            context,
                            ServiceDetailScreen(
                              serviceLineId: myGetxController.serviceList[index]
                                  ['id'],
                            )),
                      );
                    },
                  )
                : Container(
                    child: Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.teal))),
                  )),
          )
        ],
      ),
    );
  }

  checkWlanForServiceScreenData(bool isSearchData) {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                isSearchData == true
                    ? getSearchDataOfServiceScreen(apiUrl, token)
                    : getDataOfServiceScreen(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            isSearchData == true
                ? getSearchDataOfServiceScreen(apiUrl, token)
                : getDataOfServiceScreen(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  getDataOfServiceScreen(apiUrl, token) async {
    String domain = "[('out_date','=',False)]";
    var params = {
      'filters': domain.toString(),
      'limit': '10',
      'offset': '$serviceScreenOffset',
      'order': 'id desc'
    };
    Uri uri = Uri.parse("http://$apiUrl/api/service.service");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri,
        headers: {'Access-Token': token, 'Connection': 'keep-alive'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['count'] != 0) {
        myGetxController.serviceList.addAll(data['results']);
      } else {
        if (serviceScreenOffset <= 0) {
          dialog(context, "No Data Found !", Colors.red.shade300);
        }
      }
    } else {
      dialog(context, "Something Went Wrong !", Colors.red.shade300);
    }
  }

  getSearchDataOfServiceScreen(apiUrl, token) {}
}
