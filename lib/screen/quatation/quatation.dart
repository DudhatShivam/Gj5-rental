import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/constant/order_quotation_comman_card.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/quatation/quotation_detail.dart';
import 'package:http/http.dart' as http;

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../../home/home.dart';

class QuatationScreen extends StatefulWidget {
  const QuatationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<QuatationScreen> createState() => _QuatationScreenState();
}

class _QuatationScreenState extends State<QuatationScreen> {
  MyGetxController myGetxController = Get.put(MyGetxController());
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isExpandSearch = false;

  @override
  void initState() {
    super.initState();
    print(isFromAnotherScreen);
    clearList();
    getData(false);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        quotationOffset = quotationOffset + 5;
        getData(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => pushRemoveUntilMethod(context, HomeScreen(userId: 0,)),
      child: Scaffold(
          floatingActionButton: FadeInRight(
            child: CustomFABWidget(
              isCreateOrder: true,
              transitionType: ContainerTransitionType.fade,
            ),
          ),
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
                              pushRemoveUntilMethod(context, HomeScreen(userId: 0,));
                            },
                            child: FadeInLeft(
                              child: backArrowIcon,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        FadeInLeft(
                          child: Text("Quotation", style: pageTitleTextStyle),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              clearList();
                              getData(false);
                            },
                            child: FadeInRight(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primary2Color),
                              onPressed: () {
                                myGetxController
                                    .isShowQuotationFilteredList.value = true;
                                setState(() {
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
              Obx(() => Expanded(
                  child: myGetxController.isShowQuotationFilteredList.value ==
                          false
                      ? myGetxController.quotationData.isNotEmpty
                          ? ListView.builder(
                              controller: scrollController,
                              shrinkWrap: true,
                              itemCount: myGetxController.quotationData.length,
                              padding: isExpandSearch == false
                                  ? EdgeInsets.symmetric(vertical: 15)
                                  : EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () async {
                                    editQuotationCount = 0;
                                    pushMethod(
                                        context,
                                        QuatationDetailScreen(
                                          id: myGetxController
                                              .quotationData[index]['id'],
                                          isFromAnotherScreen: isFromAnotherScreen,
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
                          : CenterCircularProgressIndicator()
                      : myGetxController.filteredQuotationData.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  myGetxController.filteredQuotationData.length,
                              padding: isExpandSearch == false
                                  ? EdgeInsets.symmetric(vertical: 15)
                                  : EdgeInsets.zero,
                              itemBuilder: (context, indexs) {
                                return InkWell(
                                  onTap: () {
                                    editQuotationCount = 0;
                                    pushMethod(
                                        context,
                                        QuatationDetailScreen(
                                          id: myGetxController
                                              .quotationData[indexs]['id'],
                                          isFromAnotherScreen: isFromAnotherScreen,
                                        ));
                                  },
                                  child: OrderQuatationCommanCard(
                                    index: indexs,
                                    backGroundColor: Colors.white,
                                    isOrderScreen: false,
                                    isDeliveryScreen: false,
                                    list:
                                        myGetxController.filteredQuotationData,
                                  ),
                                );
                              },
                            )
                          : myGetxController.noDataInQuotationScreen.value ==
                                  false
                              ? CenterCircularProgressIndicator()
                              : Center(
                                  child: Text(
                                  "No Order !",
                                  style: TextStyle(
                                      color: Colors.grey.shade300,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                ))))
            ],
          )),
    );
  }

  getData(bool isSearchData) async {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                isSearchData == false
                    ? getDraftOrderData(context, apiUrl, token, 0)
                    : getSearchData(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            isSearchData == false
                ? getDraftOrderData(context, apiUrl, token, 0)
                : getSearchData(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
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
      domain = "[${datas[0]}]";
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
        myGetxController.filteredQuotationData.addAll(data['results']);
      } else {
        myGetxController.noDataInQuotationScreen.value = true;
        dialog(context, "No Order Found", Colors.red.shade300);
      }
    } else {
      dialog(context, "Something Went Wrong !", Colors.red.shade300);
    }
  }

  void clearList() {
    quotationOffset = 0;
    myGetxController.quotationData.clear();
    myGetxController.isShowQuotationFilteredList.value = false;
    myGetxController.noDataInQuotationScreen.value = false;
    myGetxController.filteredQuotationData.clear();
  }
}

Future<void> getDraftOrderData(
    BuildContext context, String apiUrl, String accessToken, int id) async {
  MyGetxController myGetxController = Get.find();
  String domain = "[('state','=','draft')]";
  var params = {
    'filters': domain.toString(),
    'limit': '5',
    'offset': '$quotationOffset',
    'order': 'id desc'
  };
  Uri uri = Uri.parse("http://$apiUrl/api/rental.rental");
  final finalUri = uri.replace(queryParameters: params);
  final response = await http.get(finalUri, headers: {
    'Access-Token': accessToken,
  });
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    if (data['count'] != 0) {
      myGetxController.quotationData.addAll(data['results']);
    } else {
      if (quotationOffset <= 0) {
        dialog(context, "No Data Found !", Colors.red.shade300);
      }
    }
  } else {
    dialog(context, "Something Went Wrong !", Colors.red.shade300);
  }
}
