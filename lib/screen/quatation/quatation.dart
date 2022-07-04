import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:badges/badges.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/constant/order_quotation_comman_card.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/quatation/create_order.dart';
import 'package:gj5_rental/screen/quatation/quatation_cart.dart';
import 'package:gj5_rental/screen/quatation/quotation_detail.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../../home/home.dart';

class QuatationScreen extends StatefulWidget {
  const QuatationScreen({Key? key}) : super(key: key);

  @override
  State<QuatationScreen> createState() => _QuatationScreenState();
}

class _QuatationScreenState extends State<QuatationScreen> {
  MyGetxController myGetxController = Get.put(MyGetxController());
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  final GlobalKey<ExpansionTileCardState> findCard = new GlobalKey();
  ScrollController scrollController = ScrollController();
  bool isSearchLoadData = false;

  @override
  void initState() {
    super.initState();
    myGetxController.filteredQuotationData.clear();
    if (myGetxController.quotationData.isEmpty) {
      getData();
    }
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        quotationOffset = quotationOffset + 5;
        getData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => pushRemoveUntilMethod(context, HomeScreen()),
      child: Scaffold(
          floatingActionButton: FadeInRight(
            child: CustomFABWidget(
              isCreateOrder: true,
              transitionType: ContainerTransitionType.fade,
            ),
          ),
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
                                pushRemoveUntilMethod(context, HomeScreen());
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
                              "Quotation",
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
                          quotationOffset = 0;
                          myGetxController.quotationData.clear();
                          myGetxController.filteredQuotationData.clear();
                          getData();
                        },
                        child: FadeInRight(
                            child: Icon(Icons.refresh,
                                size: 30, color: Colors.teal))),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Text(
                          "Find Order :",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.blueGrey),
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
                              width: getWidth(0.30, context),
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
                              "Mobile :",
                              style: primaryStyle,
                            ),
                            Container(
                              width: getWidth(0.30, context),
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
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isSearchLoadData = true;
                              });
                              findCard.currentState?.toggleExpansion();
                              searchProduct();
                            },
                            child: Text("Search")),
                      ),
                    ],
                  )
                ],
              ),
              Expanded(
                child: Obx(() => myGetxController.quotationData.isNotEmpty &&
                        isSearchLoadData == false
                    ? myGetxController.filteredQuotationData.isEmpty
                        ? ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: myGetxController.quotationData.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  editQuotationCount = 0;
                                  pushMethod(
                                      context,
                                      QuatationDetailScreen(
                                        id: myGetxController
                                            .quotationData[index]['id'],
                                        isFromAnotherScreen: false,
                                      ));
                                },
                                child: OrderQuatationCommanCard(
                                  index: index,
                                  backGroundColor: Colors.white,
                                  isOrderScreen: false,
                                  isDeliveryScreen: false,
                                  list: myGetxController.quotationData,
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                myGetxController.filteredQuotationData.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return OrderQuatationCommanCard(
                                index: index,
                                backGroundColor: Colors.white,
                                isOrderScreen: false,
                                isDeliveryScreen: false,
                                list: myGetxController.filteredQuotationData,
                                onTap: () => pushMethod(
                                    context,
                                    QuatationDetailScreen(
                                      id: myGetxController
                                          .filteredQuotationData[index]['id'],
                                      isFromAnotherScreen: false,
                                    )),
                              );
                            },
                          )
                    : Container(
                        child: Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.teal))),
                      )),
              )
            ],
          )),
    );
  }

  getData() async {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                getDraftOrderData(context, apiUrl, token, 0);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            getDraftOrderData(context, apiUrl, token, 0);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  searchProduct() {
    print(MediaQuery.of(context).viewInsets.bottom);
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                getSearchData(apiUrl, token);
              } else {
                setState(() {
                  isSearchLoadData = false;
                });
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            getSearchData(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        setState(() {
          isSearchLoadData = false;
        });
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  getSearchData(String apiUrl, String token) async {
    String? domain;
    List datas = [];

    if (nameController.text != "") {
      datas.add(
          "('customer_name', 'ilike', '${nameController.text}'),('state','=','draft')");
    }
    if (numberController.text != "") {
      datas.add(
          "('mobile1', 'ilike', '${numberController.text}'),('state','=','draft')");
    }
    if (datas.length == 1) {
      domain = "[${datas[0]},('state','=','draft')]";
    } else if (datas.length == 2) {
      domain = "['|' , ${datas[0]} , ${datas[1]}]";
    } else {
      myGetxController.filteredQuotationData.value = [];
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
        myGetxController.filteredQuotationData.addAll(data['results']);
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
