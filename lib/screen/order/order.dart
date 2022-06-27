import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
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

class _OrderState extends State<OrderScreen> {
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
  final GlobalKey<ExpansionTileCardState> findCard = new GlobalKey();
  bool isData = false;

  @override
  void initState() {
    super.initState();
    myGetxController.filteredOrderList.clear();
    if (myGetxController.orderData.isEmpty) {
      getData();
    }
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
                        "Order Status",
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
                    myGetxController.orderData.clear();
                    myGetxController.filteredOrderList.clear();
                    getData();
                  },
                  child: FadeInRight(
                      child: Icon(Icons.refresh, size: 30, color: Colors.teal)))
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
                        "Order No. :",
                        style: primaryStyle,
                      ),
                      Container(
                        width: getWidth(0.30, context),
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
                        width: getWidth(0.30, context),
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: ElevatedButton(
                      onPressed: () {
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
          child: Obx(() => myGetxController.orderData.isNotEmpty
              ? myGetxController.filteredOrderList.isEmpty   ? ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
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
                              id: myGetxController.orderData[index]['id'])),
                    );
                  }) : ListView.builder(
              padding: EdgeInsets.zero,
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
                          id: myGetxController.filteredQuotationData[index]['id'])),
                );
              })
              : Container(
                  child: Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.teal))),
                )),
        )
      ],
    ));
  }

  getData() async {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                getOrderData(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network");
              }
            });
          } else {
            getOrderData(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network");
      }
    });
  }

  getOrderData(String apiUrl, String accessToken) {
    myGetxController.orderData.clear();
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
        var params = {'filters': domain.toString()};
        Uri uri = Uri.parse("http://$apiUrl/api/rental.rental");
        final finalUri = uri.replace(queryParameters: params);
        final response = await http.get(finalUri, headers: {
          'Access-Token': accessToken,
          'Content-Type': 'application/http',
          'Connection': 'keep-alive'
        });
        Map<String, dynamic> data = await jsonDecode(response.body);
        myGetxController.orderData.value = data['results'];
      });
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
                dialog(context, "Connect to Showroom Network");
              }
            });
          } else {
            getSearchData(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network");
      }
    });
  }

  getSearchData(String apiUrl, String token) async {
    String? domain;
    List datas = [];

    if (nameController.text != "") {
      datas.add("('customer_name', 'ilike', '${nameController.text}')");
    }
    if (numberController.text != "") {
      datas.add("('mobile1', 'ilike', '${numberController.text}')");
    }
    if (orderNumberController.text != "") {
      datas.add("('name', 'ilike', '${orderNumberController.text}')");
    }
    print(datas);
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
    Uri uri = Uri.parse("http://$apiUrl/api/rental.rental?limit=10");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri,
        headers: {'Access-Token': token, 'Content-Type': 'application/http'});
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['count'] != 0) {
        myGetxController.filteredOrderList.addAll(data['results']);
      } else {
        dialog(context, "No Order Found");
      }
    } else {
      dialog(context, "Something Went Wrong");
    }
  }
}
