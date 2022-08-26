import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/Order_line/orderline_constant/order_line_card.dart';
import 'package:gj5_rental/screen/cancel_order/cancel_order.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../constant/constant.dart';

class OrderLineScreen extends StatefulWidget {
  const OrderLineScreen({Key? key}) : super(key: key);

  @override
  State<OrderLineScreen> createState() => _OrderLineScreenState();
}

class _OrderLineScreenState extends State<OrderLineScreen>
    with TickerProviderStateMixin {
  int filterOffset = 0;
  int? startDay;
  int? endDay;
  ScrollController scrollController = ScrollController();
  ScrollController filterScrollController = ScrollController();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  MyGetxController myGetxController = Get.find();
  bool isExpand = false;
  int? selectedIndex;
  bool isShowGroupByData = false;
  int? drawerSelectedIndex;
  int? drawerGroupBySelectedIndex;
  TextEditingController orderNumberController = TextEditingController();
  TextEditingController orderCodeController = TextEditingController();
  String deliveryDate = "";
  DateTime notFormatedDDate = DateTime.now();
  String toDeliveryDate = "";
  DateTime notFormatedToDDate = DateTime.now();
  bool isExpandSearch = false;
  bool isShowToDate = false;
  bool ARService = false;
  bool ARManager = false;

  List<String> filterList = [
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
    'status',
    'Delivery Date',
    'product Type',
  ];

  @override
  void initState() {
    super.initState();
    getAccessRight();
    clearList();
    cheCkWlanForOrderLineData(context, false);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        orderLineOffset = orderLineOffset + 5;
        cheCkWlanForOrderLineData(context, false);
      }
    });
    filterScrollController.addListener(() {
      if (filterScrollController.position.pixels ==
          filterScrollController.position.maxScrollExtent) {
        filterOffset = filterOffset + 5;
        checkWlanForDrawerFilterData(startDay, endDay, "");
      }
    });
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
                  height: MediaQuery.of(context).padding.top +
                      getHeight(0.13, context),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                          myGetxController.orderLineScreenList.clear();
                          myGetxController.orderLineScreenProductList.clear();
                          myGetxController.isShowFilteredDataInOrderLine.value =
                              false;
                          clearList().whenComplete(() {
                            setState(() {
                              isShowGroupByData = false;
                              orderLineOffset = 0;
                              filterOffset = 0;
                              drawerSelectedIndex = null;
                              drawerGroupBySelectedIndex = null;
                            });
                            cheCkWlanForOrderLineData(context, false);
                          });
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
                          myGetxController.orderLineFilteredTag.clear();
                          myGetxController.filteredListOrderLine.clear();
                          if (index == 0) {
                            startDay = 0;
                            endDay = 0;
                            checkWlanForDrawerFilterData(
                                startDay!, endDay!, "Today Deliver");
                          } else if (index == 1) {
                            startDay = 1;
                            endDay = 0;
                            checkWlanForDrawerFilterData(
                                1, 0, "Tomorrow Deliver");
                          } else if (index == 2) {
                            startDay = 2;
                            endDay = 0;
                            checkWlanForDrawerFilterData(
                                2, 0, "2 days After Deliver");
                          } else if (index == 3) {
                            startDay = 3;
                            endDay = 0;
                            checkWlanForDrawerFilterData(
                                3, 0, "3 days After Deliver");
                          } else if (index == 4) {
                            startDay = 4;
                            endDay = 0;
                            checkWlanForDrawerFilterData(
                                4, 0, "4 days After Deliver");
                          } else if (index == 5) {
                            startDay = 5;
                            endDay = 0;
                            checkWlanForDrawerFilterData(
                                5, 0, "5 days After Deliver");
                          } else if (index == 6) {
                            startDay = 0;
                            endDay = 1;
                            checkWlanForDrawerFilterData(
                                0, 1, "This Week Deliver");
                          }
                          drawerSelectedIndex = index;
                          _key.currentState?.closeDrawer();
                          filterOffset = 0;
                          setState(() {});
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
                              drawerSelectedIndex == index
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
                            drawerGroupBySelectedIndex = index;
                          });
                          if (index == 0) {
                            groupByField('rental_id', 'name', index);
                          } else if (index == 1) {
                            groupByField('product_id', 'name', index);
                          } else if (index == 2) {
                            groupByField('state', "", index);
                          } else if (index == 3) {
                            groupByField('delivery_date', "", index);
                          } else if (index == 4) {
                            groupByField('product_type', "", index);
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
                              drawerGroupBySelectedIndex == index
                                  ? Icon(Icons.check)
                                  : Container()
                            ],
                          ),
                        ),
                      );
                    }),
                InkWell(
                  onTap: () {
                    setState(() {
                      isShowGroupByData = false;
                      orderLineOffset = 0;
                    });
                    myGetxController.groupByList.clear();
                    myGetxController.groupByDetailList.clear();
                    myGetxController.orderLineScreenList.clear();
                    myGetxController.filteredListOrderLine.clear();
                    myGetxController.isShowFilteredDataInOrderLine.value =
                        false;
                    cheCkWlanForOrderLineData(context, true);
                    _key.currentState?.closeDrawer();
                  },
                  child: drawerFilterContainer("Load All ", context),
                )
              ],
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                              child: FadeInLeft(
                                child: drawerMenuIcon,
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          FadeInLeft(
                            child: Text(
                              "Order Line",
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
                )),
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
                            "Order : ",
                            style: primaryStyle,
                          ),
                          Container(
                            width: getWidth(0.68, context),
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
                      height: 5,
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
                            width: getWidth(0.68, context),
                            child: textFieldWidget(
                                "Product Code",
                                orderCodeController,
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
                          Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  picked7DateAbove(context).then((value) {
                                    if (value != null) {
                                      notFormatedDDate = value;
                                      setState(() {
                                        deliveryDate = DateFormat('dd/MM/yyyy')
                                            .format(value);
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                  width: getWidth(0.6, context),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: 48,
                                  decoration: BoxDecoration(
                                      color:
                                          Colors.greenAccent.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10)),
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
                                          setState(() {
                                            deliveryDate = "";
                                          });
                                        },
                                        child: textFieldCancelIcon,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isShowToDate = !isShowToDate;
                                    toDeliveryDate = "";
                                  });
                                },
                                child: Icon(
                                  isShowToDate == false
                                      ? Icons.add
                                      : Icons.remove,
                                  color: primary2Color,
                                  size: 28,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    isShowToDate == true
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "To Date   ",
                                  style: primaryStyle,
                                ),
                                SizedBox(
                                  width: getWidth(0.031, context),
                                ),
                                InkWell(
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    picked7DateAbove(context).then((value) {
                                      if (value != null) {
                                        notFormatedToDDate = value;
                                        setState(() {
                                          toDeliveryDate =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(value);
                                        });
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: getWidth(0.6, context),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 48,
                                    decoration: BoxDecoration(
                                        color:
                                            Colors.greenAccent.withOpacity(0.3),
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                              toDeliveryDate,
                                              style: primaryStyle,
                                            ),
                                          ],
                                        )),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              toDeliveryDate = "";
                                            });
                                          },
                                          child: textFieldCancelIcon,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primary2Color),
                            onPressed: () {
                              myGetxController.orderLineFilteredTag.clear();
                              if (toDeliveryDate != "") {
                                if (notFormatedToDDate
                                        .isAfter(notFormatedDDate) ==
                                    true) {
                                  searchTimeCall();
                                } else {
                                  dialog(
                                      context,
                                      "You can not select fromDate greater than toDate",
                                      Colors.red.shade300);
                                }
                              } else {
                                searchTimeCall();
                              }
                            },
                            child: Text("Search")),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                    children:
                        myGetxController.orderLineFilteredTag.map((element) {
                  return element != ""
                      ? Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5),
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: primary2Color.withOpacity(0.5)),
                          margin: EdgeInsets.only(right: 8),
                          child: Text(
                            element,
                            style: allCardSubText,
                          ),
                        )
                      : Container();
                }).toList()),
              ),
            ),
            isShowGroupByData == true
                ? Expanded(
                    child: Obx(() => myGetxController.groupByList.isNotEmpty
                        ? ListView.builder(
                            padding: isExpandSearch == true
                                ? EdgeInsets.zero
                                : EdgeInsets.symmetric(vertical: 15),
                            scrollDirection: Axis.vertical,
                            itemCount: myGetxController.groupByList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              List lst =
                                  myGetxController.groupByList[index]['data'];
                              return Container(
                                width: double.infinity,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isExpand = !isExpand;
                                            selectedIndex = index;
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
                                                  isExpand == true &&
                                                          index == selectedIndex
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
                                                          .groupByList[index]
                                                              ['Name']
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
                                      isExpand == true && index == selectedIndex
                                          ? ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: lst.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, indexs) {
                                                return OrderLineCard(
                                                  orderList: lst,
                                                  productList: myGetxController
                                                      .orderLineScreenProductList,
                                                  index: indexs,
                                                  isProductDetailScreen: false,
                                                  isShowFromGroupBy: true,
                                                  groupByMainListIndex: index,
                                                  ARManager: ARManager,
                                                  ARService: ARService,
                                                );
                                              })
                                          : Container()
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : CenterCircularProgressIndicator()))
                : Obx(
                    () => myGetxController
                                .isShowFilteredDataInOrderLine.value ==
                            true
                        ? Expanded(
                            child: myGetxController
                                    .filteredListOrderLine.isNotEmpty
                                ? ListView.builder(
                                    controller: filterScrollController,
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.vertical,
                                    itemCount: myGetxController
                                        .filteredListOrderLine.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return OrderLineCard(
                                        orderList: myGetxController
                                            .filteredListOrderLine,
                                        productList: myGetxController
                                            .orderLineScreenProductList,
                                        index: index,
                                        isProductDetailScreen: false,
                                        isShowFromGroupBy: false,
                                        ARManager: ARManager,
                                        ARService: ARService,
                                      );
                                    })
                                : myGetxController.noDataInOrderLine.value ==
                                        true
                                    ? centerNoOrderText("No Order !")
                                    : CenterCircularProgressIndicator())
                        : Expanded(
                            child: myGetxController
                                    .orderLineScreenList.isNotEmpty
                                ? ListView.builder(
                                    controller: scrollController,
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.vertical,
                                    itemCount: myGetxController
                                        .orderLineScreenList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return OrderLineCard(
                                        orderList: myGetxController
                                            .orderLineScreenList,
                                        productList: myGetxController
                                            .orderLineScreenProductList,
                                        index: index,
                                        isProductDetailScreen: false,
                                        isShowFromGroupBy: false,
                                        ARManager: ARManager,
                                        ARService: ARService,
                                      );
                                    })
                                : myGetxController.noDataInOrderLine.value ==
                                        false
                                    ? CenterCircularProgressIndicator()
                                    : centerNoOrderText("No Order !"),
                          ),
                  )
          ],
        ));
  }

  checkWlanForDrawerFilterData(int? startDay, int? endDay, String whenDeliver) {
    myGetxController.orderLineFilteredTag.add(whenDeliver);
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                setFilteredData(startDay, endDay, apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            setFilteredData(startDay, endDay, apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  searchTimeCall() {
    myGetxController.orderLineScreenList.clear();
    myGetxController.noDataInOrderLine.value = false;
    checkWlanForFilteredData();
    setState(() {
      isExpandSearch = false;
      isShowGroupByData = false;
      drawerGroupBySelectedIndex = null;
      drawerSelectedIndex = null;
      filterOffset = 0;
    });
  }

  checkWlanForFilteredData() {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                searchOrderLineOrder(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            searchOrderLineOrder(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  searchOrderLineOrder(String apiUrl, String token) async {
    myGetxController.filteredListOrderLine.clear();
    String? domain;
    List datas = [];
    String dDate = DateFormat('dd/MM/yyyy').format(notFormatedDDate);
    String toDDate = DateFormat('dd/MM/yyyy').format(notFormatedToDDate);
    if (orderNumberController.text != "") {
      myGetxController.orderLineFilteredTag
          .add("Order : ${orderNumberController.text}");
      datas.add(
          "('order_no', 'ilike', '${orderNumberController.text}'),('order_status' , 'not in' , ('cancel','done'))");
    }
    if (orderCodeController.text != "") {
      myGetxController.orderLineFilteredTag
          .add("Product Code : ${orderCodeController.text}");
      datas.add(
          "('p_default_code', 'ilike', '${orderCodeController.text}'),('order_status' , 'not in' , ('draft','cancel','done')), ('state' , 'not in' , ('cancel','receive','deliver'))");
    }
    if (deliveryDate != "") {
      if (toDeliveryDate != "") {
        myGetxController.orderLineFilteredTag
            .add("Delivery Date : ${deliveryDate} to ${toDeliveryDate}");
        datas.add(
            "('delivery_date', '>=', '${dDate}'),('delivery_date', '<=', '${toDDate}'),('order_status' , 'not in' , ('cancel','done')), ('state' , 'not in' , ('cancel','receive'))");
      } else {
        myGetxController.orderLineFilteredTag
            .add("Delivery Date : ${deliveryDate}");
        datas.add(
            "('delivery_date', '=', '${dDate}'),('order_status' , 'not in' , ('cancel','done')), ('state' , 'not in' , ('cancel','receive'))");
      }
    }

    if (datas.length == 1) {
      domain = "[${datas[0]}]";
    } else if (datas.length == 2) {
      domain = "[${datas[0]},${datas[1]}]";
    } else if (datas.length == 3) {
      domain = "[${datas[0]},${datas[1]},${datas[2]}]";
    } else {
      myGetxController.filteredListOrderLine.value = [];
    }
    var params = {
      'filters': domain,
    };
    getFilterData(params, apiUrl, token);
  }

  getFilterData(var params, String apiUrl, String token) async {
    Uri uri = Uri.parse("http://$apiUrl/api/rental.line");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri,
        headers: {'Access-Token': token, 'Content-Type': 'application/http'});

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['count'] != 0) {
        myGetxController.groupByList.clear();
        myGetxController.groupByDetailList.clear();
        myGetxController.filteredListOrderLine.addAll(data['results']);
        myGetxController.isShowFilteredDataInOrderLine.value = true;
        setState(() {
          isShowGroupByData = false;
        });
      } else {
        if (myGetxController.filteredListOrderLine.isEmpty) {
          myGetxController.noDataInOrderLine.value = true;
        }
      }
    } else {
      dialog(context, "Something Went Wrong !", Colors.red.shade300);
    }
  }

  groupByField(String firstField, String secondField, int index) {
    setState(() {
      isShowGroupByData = true;
    });
    myGetxController.groupByList.clear();
    _key.currentState?.closeDrawer();
    setDataInGroupByList(firstField, secondField, index);
  }

  setDataInGroupByList(String firstField, String secondField, int index) {
    setState(() {
      isExpand = false;
    });
    Map newMap;
    if (secondField != "") {
      newMap = myGetxController.isShowFilteredDataInOrderLine == false
          ? groupBy<dynamic, dynamic>(myGetxController.orderLineScreenList,
              (obj) => obj['$firstField']['$secondField'])
          : groupBy<dynamic, dynamic>(myGetxController.filteredListOrderLine,
              (obj) => obj['$firstField']['$secondField']);
    } else {
      newMap = myGetxController.isShowFilteredDataInOrderLine == false
          ? groupBy<dynamic, dynamic>(
              myGetxController.orderLineScreenList, (obj) => obj['$firstField'])
          : groupBy<dynamic, dynamic>(myGetxController.filteredListOrderLine,
              (obj) => obj['$firstField']);
    }
    newMap.forEach((key, value) {
      if (index == 10) {
        DateTime tempDDate = DateFormat("yyyy-MM-dd").parse(key);
        String date = DateFormat("dd/MM/yyyy").format(tempDDate);
        Map a = {'Name': date, 'data': value};
        myGetxController.groupByList.add(a);
      } else {
        Map a = {'Name': key, 'data': value};
        myGetxController.groupByList.add(a);
      }
    });
  }

  clearList() async {
    myGetxController.orderLineFilteredTag.clear();
    orderLineOffset = 0;
    myGetxController.orderLineScreenList.clear();
    myGetxController.orderLineScreenProductList.clear();
    myGetxController.noDataInOrderLine.value == false;
    myGetxController.isShowFilteredDataInOrderLine.value = false;
    myGetxController.filteredListOrderLine.clear();
    myGetxController.groupByList.clear();
    _key.currentState?.closeDrawer();
  }

  setFilteredData(int? startDay, int? endDay, String apiUrl, String token) async {
    String deliveryDate1 = "";
    String domain = "";
    if (endDay == 0) {
      if (startDay == 0) {
        deliveryDate1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
      } else {
        DateTime dateTime = DateTime.now().add(Duration(days: startDay ?? 0));
        deliveryDate1 = DateFormat('yyyy-MM-dd').format(dateTime);
      }
      domain =
          "('delivery_date', '=', '${deliveryDate1}'),('order_status' , 'not in' , ('cancel','done')), ('state' , 'not in' , ('cancel','receive'))";
    } else {
      DateTime now = DateTime.now();
      int currentDay = now.weekday;
      DateTime firstDayOfWeek = now.subtract(Duration(days: currentDay));
      DateTime lastDayOfWeek =
          now.add(Duration(days: DateTime.daysPerWeek - now.weekday + 1));
      domain =
          "('delivery_date', '>', '${firstDayOfWeek}'),('delivery_date', '<', '${lastDayOfWeek}'),('order_status' , 'not in' , ('cancel','done')), ('state' , 'not in' , ('cancel','receive'))";
    }
    var params = {
      'filters': domain,
      'limit': '5',
      'offset': '$filterOffset',
      'order': 'id desc'
    };
    getFilterData(params, apiUrl, token);
  }

  Future<void> getAccessRight() async {
    ARManager = await getBoolPreference('ARManager');
    ARService = await getBoolPreference('ARService');
  }
}
