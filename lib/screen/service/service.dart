import 'dart:convert';
import 'dart:io';
import 'package:animations/animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/service/service_detail.dart';
import 'package:http/http.dart' as http;

import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gj5_rental/screen/service/service_card.dart';
import 'package:intl/intl.dart';

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../../home/home.dart';
import '../quatation/quotation_detail.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen>
    with TickerProviderStateMixin {
  MyGetxController myGetxController = Get.find();
  ScrollController scrollController = ScrollController();
  TextEditingController serviceNumberController = TextEditingController();
  String? serviceType;
  String deliveryDate = "";
  DateTime notFormatedDDate = DateTime.now();
  bool isExpandSearch = false;

  @override
  void initState() {
    super.initState();
    clearFilteredList();
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
    return WillPopScope(
      onWillPop: () => pushRemoveUntilMethod(context, HomeScreen()),
      child: Scaffold(
        floatingActionButton: CustomFABWidget(
          transitionType: ContainerTransitionType.fade,
          isAddService: true,
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
                            pushRemoveUntilMethod(context, HomeScreen());
                          },
                          child: FadeInLeft(
                            child: backArrowIcon,
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      FadeInLeft(
                        child: Text(
                          "Service",
                          style: pageTitleTextStyle,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            myGetxController.serviceList.clear();
                            clearFilteredList();
                            resetFilter();
                            checkWlanForServiceScreenData(false);
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
            AnimatedSize(
              duration: Duration(milliseconds: 500),
              child: Container(
                height: isExpandSearch ? null : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        "Find Service :",
                        style: drawerTextStyle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Service : ",
                            style: primaryStyle,
                          ),
                          Container(
                            width: getWidth(0.30, context),
                            child: textFieldWidget(
                                "Service Number",
                                serviceNumberController,
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
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Type : ",
                            style: primaryStyle,
                          ),
                          Container(
                            width: getWidth(0.31, context),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => primary2Color),
                                        value: "washing",
                                        groupValue: serviceType,
                                        onChanged: (value) {
                                          setState(() {
                                            serviceType = value.toString();
                                          });
                                        }),
                                    Text(
                                      "Washing",
                                      style: primaryStyle,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => primary2Color),
                                        value: "stitching",
                                        groupValue: serviceType,
                                        onChanged: (value) {
                                          setState(() {
                                            serviceType = value.toString();
                                          });
                                        }),
                                    Text(
                                      "Stitching",
                                      style: primaryStyle,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: getWidth(0.015, context),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      serviceType = null;
                                    });
                                  },
                                  child: textFieldCancelIcon,
                                )
                              ],
                            ),
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
                            "D Date",
                            style: primaryStyle,
                          ),
                          InkWell(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              pickedDate(context).then((value) {
                                if (value != null) {
                                  notFormatedDDate = value;
                                  setState(() {
                                    deliveryDate =
                                        DateFormat('dd/MM/yyyy').format(value);
                                  });
                                }
                              });
                            },
                            child: Container(
                              width: getWidth(0.30, context),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.greenAccent.withOpacity(0.3),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Row(
                                    children: [
                                      calenderIcon,
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        deliveryDate,
                                        style: primaryStyle,
                                      ),
                                    ],
                                  )),
                                  InkWell(
                                    onTap: () {
                                      deliveryDate = "";
                                    },
                                    child: textFieldCancelIcon,
                                  )
                                ],
                              ),
                            ),
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
                              setState(() {
                                isExpandSearch = false;
                              });
                              myGetxController.serviceFilteredList.clear();
                              myGetxController.isShowServiceFilteredList.value =
                                  true;
                              myGetxController.noDataInServiceScreen.value =
                                  false;
                              checkWlanForServiceScreenData(true);
                            },
                            child: Text("Search")),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: Obx(() => myGetxController
                            .isShowServiceFilteredList.value ==
                        false
                    ? myGetxController.serviceList.isNotEmpty
                        ? ListView.builder(
                            padding: isExpandSearch == false
                                ? EdgeInsets.symmetric(vertical: 15)
                                : EdgeInsets.zero,
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
                                      serviceLineId: myGetxController
                                          .serviceList[index]['id'],
                                    )),
                              );
                            },
                          )
                        : CenterCircularProgressIndicator()
                    : myGetxController.serviceFilteredList.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            itemCount:
                                myGetxController.serviceFilteredList.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return ServiceCard(
                                list: myGetxController.serviceFilteredList,
                                index: index,
                                backGroundColor: Colors.white,
                                onTap: () => pushMethod(
                                    context,
                                    ServiceDetailScreen(
                                      serviceLineId: myGetxController
                                          .serviceFilteredList[index]['id'],
                                    )),
                              );
                            },
                          )
                        : myGetxController.noDataInServiceScreen.value == true
                            ? Center(
                                child: Text(
                                "No Order !",
                                style: TextStyle(
                                    color: Colors.grey.shade300,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500),
                              ))
                            : CenterCircularProgressIndicator()))
          ],
        ),
      ),
    );
  }

  Future<void> checkWlanForServiceScreenData(bool isSearchData) async {
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

  getSearchDataOfServiceScreen(apiUrl, token) async {
    String? domain;
    List datas = [];
    String dDate = DateFormat('yyyy/MM/dd').format(notFormatedDDate);
    if (serviceNumberController.text != "") {
      datas.add("('name', 'ilike', '${serviceNumberController.text}')");
    }
    if (serviceType != null) {
      datas.add("('service_type', '=', '$serviceType')");
    }
    if (deliveryDate != "") {
      datas.add("('delivery_date', '=', '${dDate}')");
    }
    if (datas.length == 1) {
      domain = "[${datas[0]}]";
    } else if (datas.length == 2) {
      domain = "[${datas[0]},${datas[1]}]";
    } else if (datas.length == 3) {
      domain = "[${datas[0]},${datas[1]},${datas[2]}]";
    } else {
      myGetxController.serviceFilteredList.value = [];
    }
    var params = {
      'filters': domain.toString(),
    };
    Uri uri = Uri.parse("http://$apiUrl/api/service.service");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri,
        headers: {'Access-Token': token, 'Connection': 'keep-alive'});

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['count'] != 0) {
        myGetxController.serviceFilteredList.addAll(data['results']);
      } else {
        myGetxController.noDataInServiceScreen.value = true;
        dialog(context, "No Order Found", Colors.red.shade300);
      }
    } else {
      dialog(context, "Something Went Wrong !", Colors.red.shade300);
    }
  }

  void clearFilteredList() {
    myGetxController.noDataInServiceScreen.value == false;
    myGetxController.isShowServiceFilteredList.value = false;
    myGetxController.serviceFilteredList.clear();
  }

  resetFilter() {
    serviceType = null;
    serviceNumberController.clear();
    deliveryDate = "";
    setState(() {});
  }
}
