import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/constant/order_quotation_comman_card.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/delivery/delivery_detail.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../../home/home.dart';
import '../booking status/booking_status.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryScreen> createState() => _DeliveryScreebState();
}

class _DeliveryScreebState extends State<DeliveryScreen> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  MyGetxController myGetxController = Get.find();
  final GlobalKey<ExpansionTileCardState> findCard = new GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController orderNumberController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkWlanForgetDeliveryData(false);
    myGetxController.deliveryScreenOrderList.clear();
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
                        "Deliver Order Status",
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
                    myGetxController.deliveryScreenOrderList.clear();
                    checkWlanForgetDeliveryData(false);
                  },
                  child: FadeInRight(
                      child: Icon(Icons.cancel, size: 30, color: Colors.teal)))
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
                            "Customer name",
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
                        "Status : ",
                        style: primaryStyle,
                      ),
                      Container(
                        width: getWidth(0.30, context),
                        child: textFieldWidget(
                            "Order Status",
                            stateController,
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
                        checkWlanForgetDeliveryData(true);
                      },
                      child: Text("Search")),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: Obx(() => myGetxController.deliveryScreenOrderList.length > 0
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: myGetxController.deliveryScreenOrderList.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return OrderQuatationCommanCard(
                      list: myGetxController.deliveryScreenOrderList,
                      backGroundColor: Colors.white,
                      index: index,
                      isDeliveryScreen: true,
                      onTap: () => pushMethod(
                          context,
                          DeliveryDetailScreen(
                            id: myGetxController.deliveryScreenOrderList[index]
                                ['id'],
                          )),
                      isOrderScreen: false,
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
    ));
  }

  void checkWlanForgetDeliveryData(bool isSearchData) {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                isSearchData == true
                    ? searchProduct(apiUrl, token)
                    : getDataForDelivery(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network");
              }
            });
          } else {
            isSearchData == true
                ? searchProduct(apiUrl, token)
                : getDataForDelivery(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network");
      }
    });
  }

  getDataForDelivery(String apiUrl, String token) async {
    DateTime dateTime1 = DateTime.now().subtract(Duration(days: 5));
    String deliveryDate = DateFormat('MM/dd/yyyy').format(dateTime1);
    String domain =
        "[('state','in',['confirm', 'waiting', 'ready' ,'partially' ,'pending','deliver']),('delivery_date' , '>=' , '$deliveryDate')]";
    var params = {'filters': domain.toString()};
    Uri uri = Uri.parse("http://$apiUrl/api/rental.rental");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri, headers: {
      'Access-Token': token,
      'Content-Type': 'application/http',
      'Connection': 'keep-alive'
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['results'] != []) {
        myGetxController.deliveryScreenOrderList.addAll(data['results']);
      }
    }
  }

  Future<void> searchProduct(String apiUrl, String token) async {
    String? domain;
    List domainData = [];
    myGetxController.deliveryScreenOrderList.clear();

    if (nameController.text != "") {
      domainData.add("('customer_name', 'ilike', '${nameController.text}')");
    }
    if (numberController.text != "") {
      domainData.add("('mobile1', 'ilike', '${numberController.text}')");
    }
    if (orderNumberController.text != "") {
      domainData.add("('name', 'ilike', '${orderNumberController.text}')");
    }
    if (stateController.text != "") {
      domainData.add("('state', 'ilike', '${stateController.text}')");
    }
    if (domainData.length == 1) {
      domain = "[${domainData[0]}]";
    } else if (domainData.length == 2) {
      domain = "['|' , ${domainData[0]} , ${domainData[1]}]";
    } else if (domainData.length == 3) {
      domain =
          "['|' , '|', ${domainData[0]} , ${domainData[1]} , ${domainData[2]}]";
    } else if (domainData.length == 4) {
      domain =
          "['|' , '|', '|' , ${domainData[0]} , ${domainData[1]} , ${domainData[2]} , ${domainData[3]}]";
    } else {
      myGetxController.deliveryScreenOrderList.value = [];
    }
    var params = {'filters': domain.toString()};
    Uri uri = Uri.parse("http://$apiUrl/api/rental.rental");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri,
        headers: {'Access-Token': token, 'Content-Type': 'application/http'});
    Map<String, dynamic> data = jsonDecode(response.body);
    myGetxController.deliveryScreenOrderList.value = data['results'];
  }
}
