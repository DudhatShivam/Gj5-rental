import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:http/http.dart' as http;

import '../../Utils/textfield_utils.dart';
import '../../constant/constant.dart';
import '../../constant/order_quotation_comman_card.dart';
import '../../getx/getx_controller.dart';
import 'cancel_order_detail.dart';

class CancelOrderScreen extends StatefulWidget {
  const CancelOrderScreen({Key? key}) : super(key: key);

  @override
  State<CancelOrderScreen> createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController orderNumberController = TextEditingController();
  ScrollController scrollController = ScrollController();
  MyGetxController myGetxController = Get.put(MyGetxController());
  bool isExpandSearch = false;


  @override
  void initState() {
    super.initState();
    clearList();
    checkWlanForCancelOrderData(false);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        cancelOrderOffset = quotationOffset + 5;
        checkWlanForCancelOrderData(false);
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
                      child: Text("Cancelled Order", style: pageTitleTextStyle),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          clearList();
                          checkWlanForCancelOrderData(false);
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
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order : ",
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
                              "Mobile number",
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
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: primary2Color),
                          onPressed: () {
                            myGetxController.isShowCancelOrderScreenFilteredList
                                .value = true;
                            myGetxController.noDataInCancelOrderScreen.value =
                                false;
                            setState(() {
                              isExpandSearch = false;
                            });
                            checkWlanForCancelOrderData(true);
                          },
                          child: Text("Search")),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(() => Expanded(
              child: myGetxController
                          .isShowCancelOrderScreenFilteredList.value ==
                      false
                  ? myGetxController.cancelOrderList.isNotEmpty
                      ? ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: myGetxController.cancelOrderList.length,
                          padding: isExpandSearch == false
                              ? EdgeInsets.symmetric(vertical: 15)
                              : EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return OrderQuatationCommanCard(
                              index: index,
                              shadowColor: Colors.white,
                              isDeliveryScreen: true,
                              list: myGetxController.cancelOrderList,
                              isOrderScreen: false,
                              onTap: () => pushMethod(
                                  context,
                                  CancelOrderDetailScreen(
                                    orderId: myGetxController
                                        .cancelOrderList[index]['id'],
                                    isFromAnotherScreen: false,
                                  )),
                            );
                          },
                        )
                      : myGetxController.noDataInCancelOrderScreen.value ==
                              false
                          ? CenterCircularProgressIndicator()
                          : centerNoOrderText("No Order !")
                  : myGetxController.filteredCancelOrderList.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              myGetxController.filteredCancelOrderList.length,
                          padding: isExpandSearch == false
                              ? EdgeInsets.symmetric(vertical: 15)
                              : EdgeInsets.zero,
                          itemBuilder: (context, indexs) {
                            return OrderQuatationCommanCard(
                              index: indexs,
                              shadowColor: Colors.white,
                              isOrderScreen: false,
                              isDeliveryScreen: false,
                              list: myGetxController.filteredCancelOrderList,
                              onTap: () => pushMethod(
                                  context,
                                  CancelOrderDetailScreen(
                                    orderId: myGetxController
                                        .filteredCancelOrderList[indexs]['id'],
                                    isFromAnotherScreen: false,
                                  )),
                            );
                          },
                        )
                      : myGetxController.noDataInCancelOrderScreen.value ==
                              false
                          ? CenterCircularProgressIndicator()
                          : centerNoOrderText("No Order !")))
        ],
      ),
    );
  }

  void checkWlanForCancelOrderData(bool isSearchData) {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                isSearchData == false
                    ? getCancelOrderData(apiUrl, token)
                    : getSearchData(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            isSearchData == false
                ? getCancelOrderData(apiUrl, token)
                : getSearchData(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  void clearList() {
    myGetxController.cancelOrderList.clear();
    myGetxController.filteredCancelOrderList.clear();
    myGetxController.noDataInCancelOrderScreen.value = false;
    myGetxController.isShowCancelOrderScreenFilteredList.value = false;
    cancelOrderOffset = 0;
    setState(() {});
  }

  getCancelOrderData(apiUrl, token) async {
    String domain = "[('state','=','cancel')]";
    var params = {
      'filters': domain.toString(),
      'limit': '5',
      'offset': '$cancelOrderOffset',
      'order': 'id desc'
    };
    Uri uri = Uri.parse("http://$apiUrl/api/rental.rental");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri, headers: {
      'Access-Token': token,
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['count'] != 0) {
        myGetxController.cancelOrderList.addAll(data['results']);
      } else {
        if (cancelOrderOffset <= 0) {
          myGetxController.noDataInCancelOrderScreen.value = true;
        }
      }
    } else {
      dialog(context, "Something Went Wrong !", Colors.red.shade300);
    }
  }

  getSearchData(apiUrl, token) async {
    String? domain;
    List datas = [];

    if (nameController.text != "") {
      datas.add(
          "('customer_name', 'ilike', '${nameController.text}'),('state','=','cancel')");
    }
    if (numberController.text != "") {
      datas.add(
          "('mobile1', 'ilike', '${numberController.text}'),('state','=','cancel')");
    }
    if (orderNumberController.text != "") {
      datas.add(
          "('name', 'ilike', '${orderNumberController.text}'),('state','=','cancel')");
    }

    if (datas.length == 1) {
      domain = "[${datas[0]}]";
    } else if (datas.length == 2) {
      domain = "['|' , ${datas[0]} , ${datas[1]}]";
    } else if (datas.length == 3) {
      domain = "['|' , '|' , ${datas[0]} , ${datas[1]} , ${datas[2]}]";
    }

    var params = {'filters': domain.toString()};
    Uri uri = Uri.parse("http://$apiUrl/api/rental.rental");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri,
        headers: {'Access-Token': token, 'Content-Type': 'application/http'});

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['count'] != 0) {
        myGetxController.filteredCancelOrderList.clear();
        myGetxController.filteredCancelOrderList.addAll(data['results']);
      } else {
        myGetxController.noDataInCancelOrderScreen.value = true;
      }
    } else {
      dialog(context, "Something Went Wrong !", Colors.red.shade300);
    }
  }
}


centerNoOrderText(String text) {
  return Center(
      child: Text(
    text,
    style: TextStyle(
        color: Colors.grey.shade300, fontSize: 25, fontWeight: FontWeight.w500),
  ));
}
