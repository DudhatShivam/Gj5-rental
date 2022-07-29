import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/constant/constant.dart';
import 'package:gj5_rental/constant/order_quotation_comman_card.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/order/order_detail.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../Utils/utils.dart';
import '../../home/home.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderState();
}

class _OrderState extends State<OrderScreen> with TickerProviderStateMixin {
  List status = [
    'New',
    'Confirmed',
    'Waiting',
    'Ready to Delivery',
    'Partially Deliver',
    'Delivered',
    'Partially Received',
    'Done',
    'Cancelled'
  ];

  List<dynamic> orderData = [];
  MyGetxController myGetxController = Get.put(MyGetxController());
  TextEditingController nameController = TextEditingController();
  TextEditingController orderNumberController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  bool isSearchLoadData = false;
  ScrollController scrollController = ScrollController();
  bool isExpandSearch = false;

  @override
  void initState() {
    super.initState();
    myGetxController.filteredOrderList.clear();
    if (myGetxController.orderData.isEmpty) {
      getData(false);
    }
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        orderScreenOffset = orderScreenOffset + 5;
        getData(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        allScreenInitialSizedBox(context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        pushRemoveUntilMethod(context, HomeScreen(userId: 0,));
                      },
                      child: FadeInLeft(child: backArrowIcon)),
                  SizedBox(
                    width: 10,
                  ),
                  FadeInLeft(
                    child: Text(
                      "Confirm Order",
                      style: pageTitleTextStyle,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        orderScreenOffset = 0;
                        myGetxController.orderData.clear();
                        myGetxController.filteredOrderList.clear();
                        getData(false);
                      },
                      child: FadeInRight(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: refreshIcon,
                      ))),
                  InkWell(
                      onTap: () {
                        setState(() {
                          isExpandSearch = !isExpandSearch;
                        });
                      },
                      child: isExpandSearch == false
                          ? FadeInRight(child: searchIcon)
                          : cancelIcon)
                ],
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: Duration(milliseconds: 500),
          child: Container(
            height: isExpandSearch ? null : 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    "Find Order :",
                    style: drawerTextStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order No. :",
                        style: primaryStyle,
                      ),
                      Container(
                        width: getWidth(0.6, context),
                        child: textFieldWidget(
                            "Order Number",
                            orderNumberController,
                            false,
                            false,
                            Colors.greenAccent.withOpacity(0.3),
                            TextInputType.number,
                            0,
                            Colors.greenAccent,
                            1),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mobile :",
                        style: primaryStyle,
                      ),
                      Container(
                        width: getWidth(0.6, context),
                        child: textFieldWidget(
                            "Mobile Number",
                            numberController,
                            false,
                            false,
                            Colors.greenAccent.withOpacity(0.3),
                            TextInputType.number,
                            0,
                            Colors.greenAccent,
                            1),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Customer : ",
                        style: primaryStyle,
                      ),
                      Container(
                        width: getWidth(0.6, context),
                        child: textFieldWidget(
                            "Customer Name",
                            nameController,
                            false,
                            false,
                            Colors.greenAccent.withOpacity(0.3),
                            TextInputType.text,
                            0,
                            Colors.greenAccent,
                            1),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primary2Color),
                        onPressed: () {
                          setState(() {
                            isSearchLoadData = true;
                            isExpandSearch = false;
                          });
                          getData(true);
                        },
                        child: Text("Search")),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Obx(() => myGetxController.orderData.isNotEmpty &&
                  isSearchLoadData == false
              ? myGetxController.filteredOrderList.isEmpty
                  ? ListView.builder(
                      controller: scrollController,
                      padding: isExpandSearch == false
                          ? EdgeInsets.symmetric(vertical: 15)
                          : EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: myGetxController.orderData.length,
                      itemBuilder: (context, index) {
                        return OrderQuatationCommanCard(
                          list: myGetxController.orderData,
                          backGroundColor: Colors.white,
                          index: index,
                          isDeliveryScreen: false,
                          isOrderScreen: true,
                          onTap: () => pushMethod(
                              context,
                              OrderDetail(
                                  idFromAnotherScreen: false,
                                  id: myGetxController.orderData[index]['id'])),
                        );
                      })
                  : ListView.builder(
                      padding: isExpandSearch == false
                          ? EdgeInsets.symmetric(vertical: 15)
                          : EdgeInsets.zero,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: myGetxController.filteredOrderList.length,
                      itemBuilder: (context, index) {
                        return OrderQuatationCommanCard(
                          list: myGetxController.filteredOrderList,
                          backGroundColor: Colors.white,
                          index: index,
                          isDeliveryScreen: false,
                          isOrderScreen: true,
                          onTap: () => pushMethod(
                              context,
                              OrderDetail(
                                  idFromAnotherScreen: false,
                                  id: myGetxController.filteredOrderList[index]
                                      ['id'])),
                        );
                      })
              : CenterCircularProgressIndicator()),
        )
      ],
    ));
  }

  getData(bool isSearchData) async {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                isSearchData == true
                    ? getSearchData(apiUrl, token)
                    : getOrderData(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            isSearchData == true
                ? getSearchData(apiUrl, token)
                : getOrderData(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  getOrderData(String apiUrl, String accessToken) {
    getStringPreference('pastDayOrder').then((past) {
      getStringPreference('nextDayOder').then((next) async {
        DateTime dateTime1 =
            DateTime.now().subtract(Duration(days: int.parse(past)));
        DateTime dateTime2 =
            DateTime.now().add(Duration(days: int.parse(next)));
        String bookingDate = DateFormat('MM/dd/yyyy').format(dateTime1);
        String deliveryDate = DateFormat('MM/dd/yyyy').format(dateTime2);
        String domain =
            "[('state' , 'not in' , ('draft','cancel','done')), ('date' , '>=' , '$bookingDate'), ('delivery_date' , '<=' , '$deliveryDate')]";
        var params = {
          'filters': domain.toString(),
          'limit': '5',
          'offset': '$orderScreenOffset',
          'order': 'id desc'
        };
        Uri uri = Uri.parse("http://$apiUrl/api/rental.rental");
        final finalUri = uri.replace(queryParameters: params);
        final response = await http.get(finalUri, headers: {
          'Access-Token': accessToken,
          'Content-Type': 'application/http',
          'Connection': 'keep-alive'
        });
        Map<String, dynamic> data = await jsonDecode(response.body);
        if (data['count'] != 0) {
          myGetxController.orderData.addAll(data['results']);
        } else {
          if (orderScreenOffset <= 0) {
            dialog(context, "No Data Found !", Colors.red.shade300);
          }
        }
      });
    });
  }

  getSearchData(String apiUrl, String token) async {
    String? domain;
    List datas = [];

    if (nameController.text != "") {
      datas.add(
          "('customer_name', 'ilike', '${nameController.text}'),('state' , 'not in' , ('cancel','done'))");
    }
    if (numberController.text != "") {
      datas.add(
          "('mobile1', 'ilike', '${numberController.text}'),('state' , 'not in' , ('cancel','done'))");
    }
    if (orderNumberController.text != "") {
      datas.add(
          "('name', 'ilike', '${orderNumberController.text}'),('state' , 'not in' , ('cancel','done'))");
    }
    if (datas.length == 1) {
      domain = "[${datas[0]}]";
    } else if (datas.length == 2) {
      domain = "['|' , ${datas[0]} , ${datas[1]}]";
    } else if (datas.length == 3) {
      domain = "['|' , '|', ${datas[0]} , ${datas[1]} , ${datas[2]}]";
    } else {
      myGetxController.filteredOrderList.value = [];
    }
    var params = {'filters': domain.toString()};
    Uri uri = Uri.parse("http://$apiUrl/api/rental.rental");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri,
        headers: {'Access-Token': token, 'Content-Type': 'application/http'});
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['count'] != 0) {
        myGetxController.filteredOrderList.clear();
        setState(() {
          isSearchLoadData = false;
        });
        myGetxController.filteredOrderList.addAll(data['results']);
      } else {
        setState(() {
          isSearchLoadData = false;
        });
        dialog(context, "No Order Found", Colors.red.shade300);
      }
    } else {
      setState(() {
        isSearchLoadData = false;
      });
      dialog(context, "Something Went Wrong !", Colors.red.shade300);
    }
  }
}
