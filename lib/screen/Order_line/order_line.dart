import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/constant/order_line_card.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:intl/intl.dart';

class OrderLineScreen extends StatefulWidget {
  const OrderLineScreen({Key? key}) : super(key: key);

  @override
  State<OrderLineScreen> createState() => _OrderLineScreenState();
}

class _OrderLineScreenState extends State<OrderLineScreen> {
  bool? isNoData;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  MyGetxController myGetxController = Get.find();
  List domainList = [];
  List<String> filterList = [
    'Today deliver',
    'Tomorrow deliver',
    '2 days After deliver',
    '3 days After deliver',
    '4 days After deliver',
    '5 days After deliver',
    'This Week deliver',
  ];

  @override
  void initState() {
    myGetxController.orderLineScreenProductList.clear();
    myGetxController.orderLineScreenList.clear();
    setDefaultDataInDomainList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: Drawer(
          child: Container(
            color: Colors.teal.shade100.withOpacity(0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).padding.top +
                      getHeight(0.15, context),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.teal.shade300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Apply Filters",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        onTap: (){
                          setDefaultDataInDomainList();
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          height: getHeight(0.04, context),
                          width: 120,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Clear Filters",
                            style: TextStyle(
                                color: Colors.grey.shade100.withOpacity(0.5),
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filterList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          domainList.clear();
                          if (index == 0) {
                            String deliveryDate =
                                DateFormat('MM/dd/yyyy').format(DateTime.now());
                            domainList.add(
                                "('delivery_date' , '=' , '$deliveryDate')");
                          } else if (index == 1) {
                            DateTime dateTime =
                                DateTime.now().add(Duration(days: 1));
                            String deliveryDate =
                                DateFormat('MM/dd/yyyy').format(dateTime);
                            domainList.add(
                                "('delivery_date' , '=' , '$deliveryDate')");
                          } else if (index == 2) {
                            DateTime dateTime =
                                DateTime.now().add(Duration(days: 2));
                            String deliveryDate =
                                DateFormat('MM/dd/yyyy').format(dateTime);
                            domainList.add(
                                "('delivery_date' , '=' , '$deliveryDate')");
                          } else if (index == 3) {
                            DateTime dateTime =
                                DateTime.now().add(Duration(days: 3));
                            String deliveryDate =
                                DateFormat('MM/dd/yyyy').format(dateTime);
                            domainList.add(
                                "('delivery_date' , '=' , '$deliveryDate')");
                          } else if (index == 4) {
                            DateTime dateTime =
                                DateTime.now().add(Duration(days: 4));
                            String deliveryDate =
                                DateFormat('MM/dd/yyyy').format(dateTime);
                            domainList.add(
                                "('delivery_date' , '=' , '$deliveryDate')");
                          } else if (index == 5) {
                            DateTime dateTime =
                                DateTime.now().add(Duration(days: 5));
                            String deliveryDate =
                                DateFormat('MM/dd/yyyy').format(dateTime);
                            domainList.add(
                                "('delivery_date' , '=' , '$deliveryDate')");
                          } else if (index == 6) {
                            DateTime now = DateTime.now();
                            int currentDay = now.weekday;
                            DateTime firstDayOfWeek =
                                now.subtract(Duration(days: currentDay - 1));
                            DateTime lastDayOfWeek = now.add(Duration(
                                days: DateTime.daysPerWeek - now.weekday));
                            String formattedFirstDayOfWeek =
                                DateFormat('MM/dd/yyyy').format(firstDayOfWeek);
                            String formattedLastDayOfWeek =
                                DateFormat('MM/dd/yyyy').format(lastDayOfWeek);
                            domainList.add(
                                "('delivery_date' , '>=' , '$formattedFirstDayOfWeek') , ('delivery_date' , '<=' , '$formattedLastDayOfWeek')");
                          }
                          cheCkWlanForOrderLineData();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Text(
                            filterList[index],
                            style: drawerTextStyle,
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        _key.currentState?.openDrawer();
                      },
                      child: FadeInLeft(
                        child: Icon(
                          Icons.menu,
                          size: 30,
                          color: Colors.teal,
                        ),
                      )),
                  SizedBox(
                    width: 30,
                  ),
                  FadeInLeft(
                    child: Text(
                      "Order Line",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 23,
                          color: Colors.teal),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() => myGetxController.orderLineScreenList.isNotEmpty
                  ? ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: myGetxController.orderLineScreenList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return OrderLineCard(
                          orderList: myGetxController.orderLineScreenList,
                          productList:
                              myGetxController.orderLineScreenProductList,
                          index: index,
                        );
                      })
                  : Container(
                      child: Center(
                          child: Text(
                        "No Order !",
                        style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
                      )),
                    )),
            ),
          ],
        ));
  }

  void cheCkWlanForOrderLineData() {
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                getDataForOrderLine(value, token);
              } else {
                dialog(context, "Connect to Showroom Network");
              }
            });
          } else {
            getDataForOrderLine(value, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network");
      }
    });
  }

  Future<void> getDataForOrderLine(apiUrl, token) async {
    _key.currentState?.closeDrawer();
    String data = domainList[0];
    String domain =
        "[('order_status' , 'not in' , ('draft','cancel','done')), ('state' , 'not in' , ('cancel','receive')), $data]";
    var params = {'filters': domain.toString()};
    Uri uri = Uri.parse("http://$apiUrl/api/rental.line");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri, headers: {
      'Access-Token': token,
      'Content-Type': 'application/http',
      'Connection': 'keep-alive'
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      myGetxController.orderLineScreenList.clear();
      myGetxController.orderLineScreenProductList.clear();
      if (data['count'] > 0) {
        myGetxController.orderLineScreenList.addAll(data['results']);
        addDataInProductList();
      }
    } else {
      dialog(context, "something went wrong");
    }
  }

  void addDataInProductList() {
    myGetxController.orderLineScreenList.forEach((element) {
      if (element['product_details_ids'] != []) {
        List<dynamic> data = element['product_details_ids'];
        data.forEach((value) {
          if (value['product_id']['default_code'] != null) {
            myGetxController.orderLineScreenProductList.add(value);
          }
        });
      }
    });
  }

  Future<void> setDefaultDataInDomainList() async {
    domainList.clear();
    DateTime dateTime = DateTime.now().subtract(Duration(days: 10));
    String deliveryDate = DateFormat('MM/dd/yyyy').format(dateTime);
    domainList.add("('delivery_date' , '>=' , '$deliveryDate')");
    cheCkWlanForOrderLineData();
  }
}
