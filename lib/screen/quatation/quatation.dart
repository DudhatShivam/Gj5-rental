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
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../../home/home.dart';

class QuatationScreen extends StatefulWidget {
  const QuatationScreen({Key? key}) : super(key: key);

  @override
  State<QuatationScreen> createState() => _QuatationScreenState();
}

class _QuatationScreenState extends State<QuatationScreen>
    with SingleTickerProviderStateMixin {
  MyGetxController myGetxController = Get.put(MyGetxController());
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  final GlobalKey<ExpansionTileCardState> findCard = new GlobalKey();
  late AnimationController animationController;
  Animation? animatedOpacity;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animatedOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.75, 1.0, curve: Curves.easeOut)));
    animationController.forward();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => pushRemoveUntilMethod(context, HomeScreen()),
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return Scaffold(
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
                                    pushRemoveUntilMethod(
                                        context, HomeScreen());
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
                              myGetxController.quotationData.clear();
                              getData();
                            },
                            child: FadeInRight(
                                child: Icon(Icons.cancel,
                                    size: 30, color: Colors.teal))),
                        // SizedBox(
                        //   width: 5,
                        // ),
                        // Obx(() => InkWell(
                        //       onTap: () {
                        //         pushMethod(context, QuotationCart());
                        //       },
                        //       child: FadeInRight(
                        //         child: Badge(
                        //           badgeContent: Text(
                        //             myGetxController.quotationCartList.length
                        //                 .toString()
                        //                 .toString(),
                        //             style: TextStyle(color: Colors.white),
                        //           ),
                        //           badgeColor: Colors.red,
                        //           child: Icon(
                        //             Icons.shopping_cart,
                        //             color: Colors.teal,
                        //           ),
                        //         ),
                        //       ),
                        //     )),
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
                    child: Obx(() => myGetxController.quotationData.length > 0
                        ? Transform.scale(
                            scale: animatedOpacity?.value,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: myGetxController.quotationData.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return OpenContainer(
                                  transitionDuration:
                                      Duration(milliseconds: 800),
                                  transitionType: ContainerTransitionType.fade,
                                  closedBuilder:
                                      (context, VoidCallback opencontainer) =>
                                          OrderQuatationCommanCard(
                                    index: index,
                                    backGroundColor: Colors.white,
                                    isDeliveryScreen: false,
                                    list: myGetxController.quotationData,
                                    onTap: opencontainer,
                                  ),
                                  openBuilder: (context, _) =>
                                      QuatationDetailScreen(
                                          id: myGetxController
                                              .quotationData[index]['id']),
                                );
                              },
                            ),
                          )
                        : Container(
                            child: Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.teal))),
                          )),
                  )
                ],
              ));
        },
      ),
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
                dialog(context, "Connect to Showroom Network");
              }
            });
          } else {
            getDraftOrderData(context, apiUrl, token, 0);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network");
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
    if (datas.length == 1) {
      domain = "[${datas[0]},('state','=','draft')]";
    } else if (datas.length == 2) {
      domain = "[('state','=','draft'), '|' , ${datas[0]} , ${datas[1]}]";
    } else {
      myGetxController.quotationData.value = [];
    }
    var params = {'filters': domain.toString()};
    Uri uri = Uri.parse("http://$apiUrl/api/rental.rental");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri, headers: {
      'Access-Token': token,
      'Content-Type': 'application/http'
    }).whenComplete(() async {
      // if (myGetxController.quotationCartList.isEmpty) {
      //   SharedPreferences preferences = await SharedPreferences.getInstance();
      //   String? data = await preferences.getString('cartList');
      //   myGetxController.quotationCartList.value = jsonDecode(data ?? "");
      // }
    });
    Map<String, dynamic> data = jsonDecode(response.body);
    myGetxController.quotationData.value = data['results'];
  }
}
