import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/cancel_order/cancel_order.dart';
import 'package:gj5_rental/screen/receive/receive_detail.dart';
import 'package:http/http.dart' as http;
import '../../Utils/textfield_utils.dart';

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../../constant/order_quotation_comman_card.dart';

class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({Key? key}) : super(key: key);

  @override
  State<ReceiveScreen> createState() => _RceiveScreenState();
}

class _RceiveScreenState extends State<ReceiveScreen> {
  MyGetxController myGetxController = Get.find();
  TextEditingController nameController = TextEditingController();
  TextEditingController orderNumberController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  bool isSearchLoadData = false;
  bool isExpandSearch = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    myGetxController.receiveFilteredOrderList.clear();
    myGetxController.noDataInReceiveScreen.value = false;

    if (myGetxController.receiveOrderList.isEmpty) {
      checkWlanForReceiveScreenData(false);
    }
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        receiveScreenOffset = receiveScreenOffset + 5;
        checkWlanForReceiveScreenData(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        allScreenInitialSizedBox(context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: FadeInLeft(
                          child: backArrowIcon,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    FadeInLeft(
                      child: Text(
                        "Receive Order Status",
                        style: pageTitleTextStyle,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          myGetxController.receiveFilteredOrderList.clear();
                          myGetxController.receiveOrderList.clear();
                          myGetxController.noDataInReceiveScreen.value = false;
                          checkWlanForReceiveScreenData(false);
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
                )
              ],
            ),
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
                  child: Text("Find Order :", style: drawerTextStyle),
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
                            1,""),
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
                            1,""),
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
                            "Customer name",
                            nameController,
                            false,
                            false,
                            Colors.greenAccent.withOpacity(0.3),
                            TextInputType.text,
                            0,
                            Colors.greenAccent,
                            1,""),
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
                          myGetxController.noDataInReceiveScreen.value = false;
                          myGetxController.receiveFilteredOrderList.clear();
                          setState(() {
                            isSearchLoadData = true;
                            isExpandSearch = false;
                          });
                          checkWlanForReceiveScreenData(true);
                        },
                        child: Text("Search")),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Obx(() => myGetxController.receiveOrderList.isNotEmpty &&
                  isSearchLoadData == false
              ? myGetxController.receiveFilteredOrderList.isEmpty
                  ? ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: myGetxController.receiveOrderList.length,
                      padding: isExpandSearch == false
                          ? EdgeInsets.symmetric(vertical: 15)
                          : EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return OrderQuatationCommanCard(
                          list: myGetxController.receiveOrderList,
                          shadowColor: Colors.white,
                          index: index,
                          isDeliveryScreen: true,
                          onTap: () => pushMethod(
                              context,
                              ReceiveDetail(
                                orderId: myGetxController
                                    .receiveOrderList[index]['id'],
                                isFromAnotherScreen: false,
                              )),
                          isOrderScreen: false,
                        );
                      },
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          myGetxController.receiveFilteredOrderList.length,
                      padding: isExpandSearch == false
                          ? EdgeInsets.symmetric(vertical: 15)
                          : EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return OrderQuatationCommanCard(
                          list: myGetxController.receiveFilteredOrderList,
                          shadowColor: Colors.white,
                          index: index,
                          isDeliveryScreen: true,
                          onTap: () => pushMethod(
                              context,
                              ReceiveDetail(
                                orderId: myGetxController
                                    .receiveFilteredOrderList[index]['id'],
                                isFromAnotherScreen: false,
                              )),
                          isOrderScreen: false,
                        );
                      },
                    )
              : myGetxController.noDataInReceiveScreen.value == false
                  ? CenterCircularProgressIndicator()
                  : centerNoOrderText("No Order Found")),
        )
      ],
    ));
  }

  checkWlanForReceiveScreenData(bool isSearchData) {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                isSearchData == true
                    ? getSearchDataOfReceiveScreen(apiUrl, token)
                    : getDataOfReceiveScreen(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            isSearchData == true
                ? getSearchDataOfReceiveScreen(apiUrl, token)
                : getDataOfReceiveScreen(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  getDataOfReceiveScreen(String apiUrl, String token) async {
    String deliveryDate = get5daysBeforeDate();
    String domain =
        "[('state','in',['partially' ,'pending','deliver']),('delivery_date' , '>=' , '$deliveryDate')]";
    var params = {
      'filters': domain.toString(),
      'limit': '5',
      'offset': '$receiveScreenOffset',
      'order': 'id desc'
    };
    Uri uri = Uri.parse("http://$apiUrl/api/rental.rental");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri, headers: {
      'Access-Token': token,
      'Content-Type': 'application/http',
      'Connection': 'keep-alive'
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['count'] != 0) {
        myGetxController.receiveOrderList.addAll(data['results']);
      } else {
        if (receiveScreenOffset <= 0) {
          myGetxController.noDataInReceiveScreen.value = true;
        }
      }
    } else {
      dialog(context, "Something Went Wrong !", Colors.red.shade300);
    }
  }

  getSearchDataOfReceiveScreen(String apiUrl, String token) async {
    String? domain;
    List domainData = [];

    if (nameController.text != "") {
      domainData.add(
          "('customer_name', 'ilike', '${nameController.text}'),('state' , 'not in' , ('cancel','done','draft'))");
    }
    if (numberController.text != "") {
      domainData.add(
          "('mobile1', 'ilike', '${numberController.text}'),('state' , 'not in' , ('cancel','done','draft'))");
    }
    if (orderNumberController.text != "") {
      domainData.add(
          "('name', 'ilike', '${orderNumberController.text}'),('state' , 'not in' , ('cancel','done','draft'))");
    }
    if (domainData.length == 1) {
      domain = "[${domainData[0]}]";
    } else if (domainData.length == 2) {
      domain = "['|' , ${domainData[0]} , ${domainData[1]}]";
    } else if (domainData.length == 3) {
      domain =
          "['|' , '|', ${domainData[0]} , ${domainData[1]} , ${domainData[2]}]";
    } else {
      myGetxController.receiveFilteredOrderList.value = [];
    }
    var params = {'filters': domain.toString()};
    Uri uri = Uri.parse("http://$apiUrl/api/rental.rental");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri,
        headers: {'Access-Token': token, 'Content-Type': 'application/http'});
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['count'] != 0) {
        setState(() {
          isSearchLoadData = false;
        });
        myGetxController.receiveFilteredOrderList.addAll(data['results']);
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
