import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/screen/Order_line/orderline_constant/order_line_card.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class OrderLineScreen extends StatefulWidget {
  const OrderLineScreen({Key? key}) : super(key: key);

  @override
  State<OrderLineScreen> createState() => _OrderLineScreenState();
}

class _OrderLineScreenState extends State<OrderLineScreen> {
  ScrollController scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  MyGetxController myGetxController = Get.find();
  bool isExpand = false;
  int? selectedIndex;
  bool isShowGroupByData = false;
  int? drawerSelectedIndex;

  List<String> filterList = [
    'Today deliver',
    'Tomorrow deliver',
    '2 days After deliver',
    '3 days After deliver',
    '4 days After deliver',
    '5 days After deliver',
    'This Week deliver',
    'Group by Bill No',
    'Group by Product',
    'Group by status',
  ];

  @override
  void initState() {
    super.initState();
    if (myGetxController.orderLineScreenList.isEmpty) {
      cheCkWlanForOrderLineData(context);
    }
    clearList();
    // scrollController.addListener(() {
    //   if (scrollController.position.pixels ==
    //       scrollController.position.maxScrollExtent) {
    //     orderLineOffset = orderLineOffset + 5;
    //     setDefaultDataInDomainList(context);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: Drawer(
          child: Container(
            color: Colors.teal.shade100.withOpacity(0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).padding.top +
                      getHeight(0.15, context),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.teal.shade300,
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
                            });
                            cheCkWlanForOrderLineData(context);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          height: getHeight(0.04, context),
                          width: getWidth(0.15, context),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Clear / Refresh",
                            style: TextStyle(
                                color: Colors.grey.shade100.withOpacity(0.5),
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filterList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            drawerSelectedIndex = index;
                          });
                          if (index == 0) {
                            setFilteredData(0, 0);
                          } else if (index == 1) {
                            setFilteredData(1, 0);
                          } else if (index == 2) {
                            setFilteredData(2, 0);
                          } else if (index == 3) {
                            setFilteredData(3, 0);
                          } else if (index == 4) {
                            setFilteredData(4, 0);
                          } else if (index == 5) {
                            setFilteredData(5, 0);
                          } else if (index == 6) {
                            setFilteredData(0, 1);
                          } else if (index == 7) {
                            setState(() {
                              isShowGroupByData = true;
                            });
                            groupByField('rental_id', 'name');
                          } else if (index == 8) {
                            setState(() {
                              isShowGroupByData = true;
                            });
                            groupByField('product_id', 'name');
                          } else if (index == 9) {
                            setState(() {
                              isShowGroupByData = true;
                            });
                            groupByField('state', "");
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
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
                    })
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        _key.currentState?.openDrawer();
                      },
                      child: FadeInLeft(
                        child: Icon(
                          Icons.menu,
                          size: 30,
                          color: Colors.teal,
                        ),
                      )),
                  SizedBox(
                    width: 30,
                  ),
                  FadeInLeft(
                    child: Text(
                      "Order Line",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 23,
                          color: Colors.teal),
                    ),
                  ),
                ],
              ),
            ),
            isShowGroupByData == true
                ? Expanded(
                    child: Obx(() => myGetxController.groupByList.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.only(bottom: 15, top: 5),
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
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isExpand = !isExpand;
                                                      selectedIndex = index;
                                                    });
                                                  },
                                                  child: Icon(Icons
                                                      .arrow_drop_down_outlined),
                                                ),
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
                                                );
                                              })
                                          : Container()
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )))
                : Obx(
                    () => myGetxController
                                .isShowFilteredDataInOrderLine.value ==
                            true
                        ? myGetxController.filteredListOrderLine.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                    controller: scrollController,
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
                                      );
                                    }))
                            : Expanded(
                                child: Container(
                                  child: Center(
                                      child: Text(
                                    "No Order !",
                                    style: TextStyle(
                                        color: Colors.grey.shade300,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500),
                                  )),
                                ),
                              )
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
                                      );
                                    })
                                : myGetxController.noDataInOrderLine.value ==
                                        true
                                    ? Container(
                                        child: Center(
                                            child: Text(
                                          "No Order !",
                                          style: TextStyle(
                                              color: Colors.grey.shade300,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500),
                                        )),
                                      )
                                    : Container(
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                          ),
                  )
          ],
        ));
  }

  groupByField(String firstField, String secondField) {
    myGetxController.groupByList.clear();
    if (myGetxController.orderLineScreenList.isNotEmpty) {
      _key.currentState?.closeDrawer();
      setDataInGroupByList(firstField, secondField);
    }
    // else {
    //   clearList();
    //   cheCkWlanForOrderLineData(context);
    //   setDataInGroupByList(isShowGroupByData, firstField, secondField);
    // }
  }

  setDataInGroupByList(String firstField, String secondField) {
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
      newMap = myGetxController.isShowFilteredDataInOrderLine == false ? groupBy<dynamic, dynamic>(
          myGetxController.orderLineScreenList, (obj) => obj['$firstField']) : groupBy<dynamic, dynamic>(
          myGetxController.filteredListOrderLine, (obj) => obj['$firstField']);
    }
    newMap.forEach((key, value) {
      Map a = {'Name': key, 'data': value};
      myGetxController.groupByList.add(a);
    });
  }

  clearList() async {
    myGetxController.noDataInOrderLine.value == false;
    myGetxController.isShowFilteredDataInOrderLine.value = false;
    myGetxController.filteredListOrderLine.clear();
    myGetxController.groupByList.clear();
    _key.currentState?.closeDrawer();
  }

  setFilteredData(int startDay, int endDay) {
    setState(() {
      isShowGroupByData = false;
    });
    myGetxController.groupByList.clear();
    myGetxController.groupByDetailList.clear();
    myGetxController.filteredListOrderLine.clear();
    String deliveryDate1 = "";
    if (myGetxController.orderLineScreenList.isNotEmpty) {
      if (endDay == 0) {
        if (startDay == 0) {
          deliveryDate1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
        } else {
          DateTime dateTime = DateTime.now().add(Duration(days: startDay));
          deliveryDate1 = DateFormat('yyyy-MM-dd').format(dateTime);
        }
        myGetxController.orderLineScreenList.forEach((element) {
          if (element['delivery_date'] == deliveryDate1) {
            myGetxController.filteredListOrderLine.add(element);
          }
        });
      } else {
        DateTime now = DateTime.now();
        int currentDay = now.weekday;
        DateTime firstDayOfWeek = now.subtract(Duration(days: currentDay));
        DateTime lastDayOfWeek =
            now.add(Duration(days: DateTime.daysPerWeek - now.weekday + 1));
        myGetxController.orderLineScreenList.forEach((element) {
          DateTime dateTime =
              DateFormat("yyyy-MM-dd").parse(element['delivery_date']);
          if (dateTime.isAfter(firstDayOfWeek) &&
              dateTime.isBefore(lastDayOfWeek)) {
            myGetxController.filteredListOrderLine.add(element);
          }
        });
      }
    }
    myGetxController.isShowFilteredDataInOrderLine.value = true;
    _key.currentState?.closeDrawer();
  }
}
