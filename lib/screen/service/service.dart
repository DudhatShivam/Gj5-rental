import 'dart:convert';
import 'dart:io';
import '../../Utils/textfield_utils.dart';

import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/screen/cancel_order/cancel_order.dart';
import 'package:gj5_rental/screen/service/service_card.dart';
import 'package:gj5_rental/screen/service/service_detail.dart';
import 'package:gj5_rental/screen/service/servicecontroller.dart';
import 'package:http/http.dart' as http;

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../../home/home.dart';
import '../quatation/quotation_detail.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  ServiceController serviceController = Get.put(ServiceController());
  ScrollController scrollController = ScrollController();
  TextEditingController serviceNumberController = TextEditingController();
  TextEditingController partnerController = TextEditingController();
  String? serviceType;
  bool isExpandSearch = false;

  @override
  void initState() {
    super.initState();
    clearFilteredList();
    checkWlanForServiceScreenData(false);
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
      onWillPop: () => pushRemoveUntilMethod(
          context,
          HomeScreen(
            userId: 0,
          )),
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
                            pushRemoveUntilMethod(
                                context,
                                HomeScreen(
                                  userId: 0,
                                ));
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
                            width: getWidth(0.6, context),
                            child: textFieldWidget(
                                "Service Number",
                                serviceNumberController,
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
                            width: getWidth(0.62, context),
                            child: FittedBox(
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
                                    width: getWidth(0.02, context),
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
                            "Partner : ",
                            style: primaryStyle,
                          ),
                          Container(
                            width: getWidth(0.6, context),
                            child: textFieldWidget(
                                "Partner Name",
                                partnerController,
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
                              serviceController.serviceFilteredList.clear();
                              serviceController
                                  .isShowServiceFilteredList.value = true;
                              serviceController.noDataInServiceScreen.value =
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
                child: Obx(() => serviceController
                            .isShowServiceFilteredList.value ==
                        false
                    ? serviceController.serviceList.isNotEmpty
                        ? ListView.builder(
                            padding: isExpandSearch == false
                                ? EdgeInsets.symmetric(vertical: 15)
                                : EdgeInsets.zero,
                            itemCount: serviceController.serviceList.length,
                            shrinkWrap: true,
                            controller: scrollController,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return ServiceCard(
                                list: serviceController.serviceList,
                                index: index,
                                shadowColor: Colors.white,
                                onTap: () => pushMethod(
                                    context,
                                    ServiceDetailScreen(
                                      serviceLineId: serviceController
                                          .serviceList[index]['id'],
                                      isFromAnotherScreen: false,
                                    )),
                              );
                            },
                          )
                        : serviceController.noDataInServiceScreen.value == true
                            ? centerNoOrderText("No Service Found !")
                            : CenterCircularProgressIndicator()
                    : serviceController.serviceFilteredList.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            itemCount:
                                serviceController.serviceFilteredList.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return ServiceCard(
                                list: serviceController.serviceFilteredList,
                                index: index,
                                shadowColor: Colors.white,
                                onTap: () => pushMethod(
                                    context,
                                    ServiceDetailScreen(
                                      serviceLineId: serviceController
                                          .serviceFilteredList[index]['id'],
                                      isFromAnotherScreen: false,
                                    )),
                              );
                            },
                          )
                        : serviceController.noDataInServiceScreen.value == true
                            ? centerNoOrderText("No Service Found !")
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
                    : getDataOfServiceScreen(context, apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            isSearchData == true
                ? getSearchDataOfServiceScreen(apiUrl, token)
                : getDataOfServiceScreen(context, apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  getSearchDataOfServiceScreen(apiUrl, token) async {
    String? domain;
    List datas = [];
    if (serviceNumberController.text != "") {
      datas.add("('name', 'ilike', '${serviceNumberController.text}')");
    }
    if (serviceType != null) {
      datas.add("('service_type', '=', '$serviceType')");
    }
    if (partnerController.text != "") {
      datas.add(
          "('service_partner_name', 'ilike', '${partnerController.text}')");
    }
    if (datas.length == 1) {
      domain = "[${datas[0]}]";
    } else if (datas.length == 2) {
      domain = "[${datas[0]},${datas[1]}]";
    } else if (datas.length == 3) {
      domain = "[${datas[0]},${datas[1]},${datas[2]}]";
    } else {
      serviceController.serviceFilteredList.value = [];
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
        serviceController.serviceFilteredList.addAll(data['results']);
      } else {
        serviceController.noDataInServiceScreen.value = true;
        dialog(context, "No Service Found", Colors.red.shade300);
      }
    } else {
      dialog(context, "Something Went Wrong !", Colors.red.shade300);
    }
  }

  void clearFilteredList() {
    serviceScreenOffset = 0;
    serviceController.serviceList.clear();
    serviceController.noDataInServiceScreen.value == false;
    serviceController.isShowServiceFilteredList.value = false;
    serviceController.serviceFilteredList.clear();
  }

  resetFilter() {
    serviceType = null;
    serviceNumberController.clear();
    partnerController.clear();
    setState(() {});
  }
}

Future<void> getDataOfServiceScreen(BuildContext context, apiUrl, token) async {
  ServiceController serviceController = Get.find();
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
      serviceController.serviceList.addAll(data['results']);
    } else {
      if (serviceScreenOffset <= 0) {
        serviceController.noDataInServiceScreen.value = true;
      }
    }
  } else {
    dialog(context, "Something Went Wrong !", Colors.red.shade300);
  }
}
