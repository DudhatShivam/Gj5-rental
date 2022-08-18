import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../cancel_order/cancel_order.dart';
import '../service/service_detail_card.dart';

class ServiceLineScreen extends StatefulWidget {
  const ServiceLineScreen({Key? key}) : super(key: key);

  @override
  State<ServiceLineScreen> createState() => _ServiceLineScreenState();
}

class _ServiceLineScreenState extends State<ServiceLineScreen>
    with TickerProviderStateMixin {
  MyGetxController myGetxController = Get.find();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  TextEditingController productCodeSearchController = TextEditingController();
  int? selectedFilterIndex;
  int? selectedGroupByIndex;
  int? groupByListIndex;
  bool isExpandSearch = false;
  DateTime? notFormatedDDate;
  String? deliveryDate;

  List filterList = [
    'washing',
    'stitching',
    'Today deliver',
    'Tomorrow deliver',
    '2 days After deliver',
    '3 days After deliver',
    '4 days After deliver',
    '5 days After deliver',
    'This Week deliver',
  ];
  List groupByList = [
    'Bill No',
    'Product',
    'Partner',
    'Service Type',
  ];

  @override
  void initState() {
    super.initState();
    myGetxController.serviceLineScreenList.clear();
    checkWlanForServiceLineData(false);
    showDefaultData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: Drawer(
          child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                mainColor1.withOpacity(0.20),
                mainColor2.withOpacity(0.05)
              ])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      mainColor1.withOpacity(0.35),
                      mainColor2.withOpacity(0.15)
                    ])),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: MediaQuery.of(context).padding.top +
                        getHeight(0.13, context),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Apply Filters",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          onTap: () {
                            myGetxController.serviceLineScreenList.clear();
                            discardGroupBy();
                            showDefaultData();
                            checkWlanForServiceLineData(false);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 15),
                            height: getHeight(0.04, context),
                            width: getWidth(0.35, context),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: FittedBox(
                              child: Text(
                                "Clear / Refresh",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  drawerFilterContainer("Filters :", context),
                  ListView.builder(
                      padding: EdgeInsets.only(left: 15),
                      itemCount: filterList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedFilterIndex = index;
                            });
                            if (index == 0) {
                              typeFilter(filterList[index]);
                            } else if (index == 1) {
                              typeFilter(filterList[index]);
                            } else if (index == 2) {
                              setFilteredData(0, 0);
                            } else if (index == 3) {
                              setFilteredData(1, 0);
                            } else if (index == 4) {
                              setFilteredData(2, 0);
                            } else if (index == 5) {
                              setFilteredData(3, 0);
                            } else if (index == 6) {
                              setFilteredData(4, 1);
                            } else if (index == 7) {
                              setFilteredData(5, 0);
                            } else if (index == 8) {
                              setFilteredData(0, 1);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: getHeight(0.008, context),
                                horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  filterList[index],
                                  style: drawerTextStyle,
                                ),
                                selectedFilterIndex == index
                                    ? Icon(Icons.check)
                                    : Container()
                              ],
                            ),
                          ),
                        );
                      }),
                  drawerFilterContainer("Group By :", context),
                  ListView.builder(
                      padding: EdgeInsets.only(left: 15),
                      itemCount: groupByList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedGroupByIndex = index;
                            });
                            if (index == 0) {
                              groupByField("rental_id", "name");
                            } else if (index == 1) {
                              groupByField("product_id", "name");
                            } else if (index == 2) {
                              groupByField("service_partner_id", "name");
                            } else if (index == 3) {
                              groupByField("service_type", "");
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: getHeight(0.008, context),
                                horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  groupByList[index],
                                  style: drawerTextStyle,
                                ),
                                selectedGroupByIndex == index
                                    ? Icon(Icons.check)
                                    : Container()
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              )),
        ),
        body: Column(
          children: [
            allScreenInitialSizedBox(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              _key.currentState?.openDrawer();
                            },
                            child: FadeInLeft(child: drawerMenuIcon)),
                        SizedBox(
                          width: 15,
                        ),
                        FadeInLeft(
                          child: Text(
                            "Service Line",
                            style: pageTitleTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isExpandSearch = !isExpandSearch;
                      });
                    },
                    child: isExpandSearch == false
                        ? FadeInRight(
                            child: searchIcon,
                          )
                        : cancelIcon,
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
                          horizontal: 20, vertical: 8),
                      child: Text(
                        "Find Service :",
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
                            "Code :",
                            style: primaryStyle,
                          ),
                          Container(
                            width: getWidth(0.6, context),
                            child: textFieldWidget(
                                "Product Code",
                                productCodeSearchController,
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
                            "D Date",
                            style: primaryStyle,
                          ),
                          InkWell(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              picked7DateAbove(context).then((value) {
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
                              width: getWidth(0.6, context),
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
                                        deliveryDate ?? "",
                                        style: primaryStyle,
                                      ),
                                    ],
                                  )),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        deliveryDate = "";
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primary2Color),
                            onPressed: () {
                              myGetxController.noDataInServiceLineScreen.value =
                                  false;
                              checkWlanForServiceLineData(true);
                              setState(() {
                                isExpandSearch = false;
                              });
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
                            .serviceLineIsShowGroupByData.value ==
                        true
                    ? myGetxController.serviceLineGroupByList.isNotEmpty
                        ? ListView.builder(
                            padding: isExpandSearch == true
                                ? EdgeInsets.zero
                                : EdgeInsets.symmetric(vertical: 15),
                            scrollDirection: Axis.vertical,
                            itemCount:
                                myGetxController.serviceLineGroupByList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              List lst = myGetxController
                                  .serviceLineGroupByList[index]['data'];
                              return Container(
                                width: double.infinity,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          myGetxController
                                                  .serviceLineIsExpand.value =
                                              !myGetxController
                                                  .serviceLineIsExpand.value;
                                          setState(() {
                                            groupByListIndex = index;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              child: Row(
                                                children: [
                                                  myGetxController.serviceLineIsExpand
                                                                  .value ==
                                                              true &&
                                                          index ==
                                                              groupByListIndex
                                                      ? Icon(Icons
                                                          .arrow_drop_up_outlined)
                                                      : Icon(Icons
                                                          .arrow_drop_down_outlined),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      myGetxController
                                                          .serviceLineGroupByList[
                                                              index]['Name']
                                                          .toString()
                                                          .toUpperCase(),
                                                      style: primaryStyle,
                                                    ),
                                                  ),
                                                  Text(
                                                    " (${lst.length})",
                                                    style: primaryStyle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      myGetxController.serviceLineIsExpand
                                                      .value ==
                                                  true &&
                                              index == groupByListIndex
                                          ? ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: lst.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, indexs) {
                                                return ServiceDetailCard(
                                                  list: lst,
                                                  index: indexs,
                                                  isServiceLineSceen: true,
                                                  isFromNotificationScreen:
                                                      false,
                                                  isFromServiceScreen: false,
                                                );
                                              })
                                          : Container()
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : CenterCircularProgressIndicator()
                    : myGetxController.serviceLineIsShowFilteredData.value ==
                            true
                        ? myGetxController.serviceLineFilteredList.isNotEmpty
                            ? ListView.builder(
                                padding: isExpandSearch == true
                                    ? EdgeInsets.zero
                                    : EdgeInsets.symmetric(vertical: 15),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: myGetxController
                                    .serviceLineFilteredList.length,
                                itemBuilder: (context, index) {
                                  return ServiceDetailCard(
                                    list: myGetxController
                                        .serviceLineFilteredList,
                                    isFromNotificationScreen: false,
                                    index: index,
                                    isServiceLineSceen: true,
                                    isFromServiceScreen: false,
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                "No Service !",
                                style: TextStyle(
                                    color: Colors.grey.shade300,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500),
                              ))
                        : myGetxController.serviceLineScreenList.isNotEmpty
                            ? ListView.builder(
                                padding: isExpandSearch == true
                                    ? EdgeInsets.zero
                                    : EdgeInsets.symmetric(vertical: 15),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: myGetxController
                                    .serviceLineScreenList.length,
                                itemBuilder: (context, index) {
                                  return ServiceDetailCard(
                                    list:
                                        myGetxController.serviceLineScreenList,
                                    isFromNotificationScreen: false,
                                    index: index,
                                    isServiceLineSceen: true,
                                    isFromServiceScreen: false,
                                  );
                                },
                              )
                            : myGetxController
                                        .noDataInServiceLineScreen.value ==
                                    false
                                ? CenterCircularProgressIndicator()
                                : centerNoOrderText("No Service Line")))
          ],
        ));
  }

  void checkWlanForServiceLineData(bool isSearchData) {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                isSearchData == false
                    ? getServiceLineData(apiUrl, token)
                    : getSearchData(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            isSearchData == false
                ? getServiceLineData(apiUrl, token)
                : getSearchData(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  Future<void> getServiceLineData(apiUrl, token) async {
    String domain = "[('out_date','=',False)]";
    var params = {
      'filters': domain.toString(),
    };
    Uri uri = Uri.parse("http://$apiUrl/api/product.service.line");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri,
        headers: {'Access-Token': token, 'Connection': 'keep-alive'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['count'] > 0) {
        myGetxController.serviceLineScreenList.addAll(data['results']);
      } else {
        myGetxController.noDataInServiceLineScreen.value = true;
      }
    } else {
      dialog(context, "Something Went Wrong", Colors.red.shade300);
    }
  }

  void setFilteredData(int startDay, int endDay) {
    myGetxController.serviceLineIsShowFilteredData.value = true;
    String deliveryDate1 = "";
    if (myGetxController.serviceLineScreenList.isNotEmpty) {
      discardGroupBy();
      showFilterData();
      if (endDay == 0) {
        if (startDay == 0) {
          deliveryDate1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
        } else {
          DateTime dateTime = DateTime.now().add(Duration(days: startDay));
          deliveryDate1 = DateFormat('yyyy-MM-dd').format(dateTime);
        }
        myGetxController.serviceLineScreenList.forEach((element) {
          if (element['delivery_date'] != null) {
            if (element['delivery_date'] == deliveryDate1) {
              myGetxController.serviceLineFilteredList.add(element);
            }
          }
        });
      } else {
        DateTime now = DateTime.now();
        int currentDay = now.weekday;
        DateTime firstDayOfWeek = now.subtract(Duration(days: currentDay));
        DateTime lastDayOfWeek =
            now.add(Duration(days: DateTime.daysPerWeek - now.weekday + 1));
        myGetxController.serviceLineScreenList.forEach((element) {
          if (element['delivery_date'] != null) {
            DateTime dateTime =
                DateFormat("yyyy-MM-dd").parse(element['delivery_date']);
            if (dateTime.isAfter(firstDayOfWeek) &&
                dateTime.isBefore(lastDayOfWeek)) {
              myGetxController.serviceLineFilteredList.add(element);
            }
          }
        });
      }
    }
  }

  void typeFilter(String serviceType) {
    if (myGetxController.serviceLineScreenList.isNotEmpty) {
      discardGroupBy();
      showFilterData();
      myGetxController.serviceLineScreenList.forEach((element) {
        if (element['service_type'] == serviceType) {
          myGetxController.serviceLineFilteredList.add(element);
        }
      });
    }
  }

  groupByField(
    String firstField,
    String secondField,
  ) {
    if (myGetxController.serviceLineScreenList.isNotEmpty) {
      showGroupBy();
      Map newMap;
      if (secondField != "") {
        newMap = myGetxController.serviceLineIsShowFilteredData == false
            ? groupBy<dynamic, dynamic>(myGetxController.serviceLineScreenList,
                (obj) => obj['$firstField']['$secondField'])
            : groupBy<dynamic, dynamic>(
                myGetxController.serviceLineFilteredList,
                (obj) => obj['$firstField']['$secondField']);
      } else {
        newMap = myGetxController.serviceLineIsShowFilteredData == false
            ? groupBy<dynamic, dynamic>(myGetxController.serviceLineScreenList,
                (obj) => obj['$firstField'])
            : groupBy<dynamic, dynamic>(
                myGetxController.serviceLineFilteredList,
                (obj) => obj['$firstField']);
      }
      newMap.forEach((key, value) {
        Map a = {'Name': key, 'data': value};
        myGetxController.serviceLineGroupByList.add(a);
      });
    }
  }

  showFilterData() {
    _key.currentState?.closeDrawer();
    myGetxController.serviceLineFilteredList.clear();
    myGetxController.serviceLineIsShowFilteredData.value = true;
  }

  showDefaultData() {
    myGetxController.noDataInServiceLineScreen.value = false;
    myGetxController.serviceLineFilteredList.clear();
    myGetxController.serviceLineIsShowFilteredData.value = false;
    myGetxController.serviceLineIsShowGroupByData.value = false;
    selectedGroupByIndex = null;
    selectedFilterIndex = null;
    setState(() {});
  }

  void showGroupBy() {
    _key.currentState?.closeDrawer();
    myGetxController.serviceLineGroupByList.clear();
    myGetxController.serviceLineIsExpand.value = false;
    myGetxController.serviceLineIsShowGroupByData.value = true;
  }

  void discardGroupBy() {
    _key.currentState?.closeDrawer();
    myGetxController.serviceLineIsShowGroupByData.value = false;
    myGetxController.serviceLineGroupByList.clear();
  }

  getSearchData(apiUrl, token) async {
    try {
      String dDate =
          DateFormat('yyyy/MM/dd').format(notFormatedDDate ?? DateTime.now());
      List datas = [];
      String? domain;
      if (productCodeSearchController.text.isNotEmpty) {
        datas.add(
            "('default_code', 'ilike', '${productCodeSearchController.text}')");
      }
      if (deliveryDate != "") {
        datas.add("('delivery_date', '=', '${dDate}')");
      }

      if (datas.length == 1) {
        domain = "[${datas[0]}]";
      } else if (datas.length == 2) {
        domain = "[${datas[0]},${datas[1]}]";
      } else {
        myGetxController.serviceLineFilteredList.value = [];
      }
      var params = {
        'filters': domain.toString(),
      };
      Uri uri = Uri.parse("http://$apiUrl/api/product.service.line");
      final finalUri = uri.replace(queryParameters: params);
      final response =
          await http.get(finalUri, headers: {'Access-Token': token});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['count'] > 0) {
          discardGroupBy();
          showFilterData();
          myGetxController.serviceLineFilteredList.addAll(data['results']);
        } else {
          dialog(context, "No Data Found !", Colors.red.shade300);
        }
      } else {
        dialog(context, "Something Went Wrong !", Colors.red.shade300);
      }
    } catch (e) {}
  }
}
