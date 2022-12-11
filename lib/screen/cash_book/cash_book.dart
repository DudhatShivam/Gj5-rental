import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/constant/constant.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../Utils/utils.dart';
import '../../getx/getx_controller.dart';
import '../booking status/booking_status.dart';

class CashBookScreen extends StatefulWidget {
  const CashBookScreen({Key? key}) : super(key: key);

  @override
  State<CashBookScreen> createState() => _CashBookScreenState();
}

class _CashBookScreenState extends State<CashBookScreen> {
  String? fromDate;
  String? toDate;
  int? curIndex;
  String? uid;

  List detailCashBookList = [];
  List grandTotal = [];
  List totalList = [];

  MyGetxController myGetxController = Get.put(MyGetxController());

  @override
  void initState() {
    super.initState();
    getUid();
    fromDate = DateFormat(showGlobalDateFormat).format(DateTime.now());
    toDate = DateFormat(showGlobalDateFormat).format(DateTime.now());
  }

  TextStyle creditTextStyle =
      TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.green);
  TextStyle debitTextStyle =
      TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.red);
  TextStyle totalStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          allScreenInitialSizedBox(context),
          ScreenAppBar(
            screenName: "Cash Book",
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Date From",
                                    style: allCardSubText,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      pickedPastDate(context).then((value) {
                                        if (value != null) {
                                          fromDate =
                                              DateFormat(showGlobalDateFormat)
                                                  .format(value);
                                          setState(() {});
                                        }
                                      });
                                    },
                                    child: dateContainer(fromDate ?? ""),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Date To",
                                    style: allCardSubText,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      pickedPastDate(context).then((value) {
                                        if (value != null) {
                                          toDate =
                                              DateFormat(showGlobalDateFormat)
                                                  .format(value);
                                          setState(() {});
                                        }
                                      });
                                    },
                                    child: dateContainer(toDate ?? ""),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              toDate = null;
                              fromDate = null;
                              curIndex = null;
                              setState(() {});
                              clearList();
                            },
                            child: Icon(Icons.clear, size: 25))
                      ],
                    ),
                    toDate != null && fromDate != null
                        ? Obx(() => myGetxController.cashBookList.isEmpty
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    width: getWidth(0.85, context),
                                    height: 45,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: primary2Color),
                                        onPressed: () {
                                          checkWlanForServiceScreenData();
                                        },
                                        child: Text("GET DATA")),
                                  ),
                                ],
                              )
                            : Container())
                        : Container(),
                    SizedBox(
                      height: 15,
                    ),
                    Obx(() => myGetxController.cashBookList.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                  itemCount:
                                      myGetxController.cashBookList.length - 1,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    Map data =
                                        myGetxController.cashBookList[index];
                                    detailCashBookList = myGetxController
                                        .detailCashBookList[index];
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (curIndex != null) {
                                              curIndex = null;
                                            } else {
                                              curIndex = index;
                                            }
                                            setState(() {});
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: curIndex == index
                                                    ? Colors.grey.shade300
                                                    : Colors.white,
                                                border: Border.all(
                                                    color: curIndex == index
                                                        ? Colors.grey.shade500
                                                        : Color(0xffE6ECF2),
                                                    width: 0.7),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "${data.keys.toString().toUpperCase().replaceAll('(', '').replaceAll(')', '')}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: curIndex == index
                                                          ? Colors.black
                                                          : Colors
                                                              .grey.shade600,
                                                      fontSize: 17),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${totalList[index]['credit'].toString()}",
                                                      style: creditTextStyle,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "${totalList[index]['debit'].toString()}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: debitTextStyle,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${totalList[index]['credit'] - totalList[index]['debit']}",
                                                      style: totalStyle,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        AnimatedSize(
                                          duration: Duration(milliseconds: 500),
                                          child: Container(
                                            height:
                                                curIndex == index ? null : 0,
                                            child: ListView.builder(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                itemCount:
                                                    detailCashBookList.length,
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemBuilder:
                                                    (context, detailIndex) {
                                                  return Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 2),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: AutoSizeText(
                                                                  "${myGetxController.detailCashBookList[index][detailIndex]['text']}",
                                                                  style:
                                                                      totalStyle),
                                                            ),
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "${myGetxController.detailCashBookList[index][detailIndex]['credit'].toString()}",
                                                                    style:
                                                                        creditTextStyle,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Text(
                                                                    "${myGetxController.detailCashBookList[index][detailIndex]['debit'].toString()}",
                                                                    style:
                                                                        debitTextStyle,
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Final Total :",
                                  style: allCardSubText,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 20),
                                child: Row(
                                  children: [
                                    Text(
                                      grandTotal[0]['credit']
                                          .toStringAsFixed(1),
                                      style: deliveryDateStyle,
                                    ),
                                    Expanded(
                                        child: Text(
                                      grandTotal[0]['debit'].toStringAsFixed(1),
                                      style: returnDateStyle,
                                      textAlign: TextAlign.center,
                                    )),
                                    Text(
                                      "${double.parse(grandTotal[0]['credit'].toStringAsFixed(1)) - double.parse(grandTotal[0]['debit'].toStringAsFixed(1))}",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        : Container()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  dateContainer(String date) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(12),
      width: getWidth(0.32, context),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15)),
      child: Text(
        date,
        style: primaryStyle,
      ),
    );
  }

  void getUid() {
    clearList();
    getStringPreference("uid").then((value) {
      uid = value;
    });
  }

  Future<void> checkWlanForServiceScreenData() async {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                getDailyCashBookData(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            getDailyCashBookData(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  Future<void> getDailyCashBookData(apiUrl, token) async {
    String fDate = changeDateFormatTopPassApiDate(fromDate ?? "");
    String tDate = changeDateFormatTopPassApiDate(toDate ?? "");
    final response = await http.put(
        Uri.parse(
            "http://$apiUrl/api/res.users/$uid/get_daily_cashbook?date_from=$fDate&date_to=$tDate"),
        headers: {
          'Access-Token': token,
        });
    print(response.body);
    try {
      if (response.statusCode == 200) {
        List<dynamic> cashBookList = jsonDecode(response.body);
        myGetxController.cashBookList.addAll(cashBookList);
        myGetxController.cashBookList.forEach((element) {
          Map data = element;
          data.forEach((key, value) {
            if (key == "final_total") {
              grandTotal.addAll(value);
            }
            myGetxController.detailCashBookList.add(value);
          });
        });
        getTotalFromList();
      } else {
        dialog(context, "Error While Retrieving Data", Colors.red.shade300);
      }
    } catch (e) {
      dialog(context, "Check Wi-Fi Connectivity Speed", Colors.red.shade300);
    }
  }

  void clearList() {
    myGetxController.cashBookList.clear();
    myGetxController.detailCashBookList.clear();
    grandTotal.clear();
    totalList.clear();
  }

  void getTotalFromList() {
    myGetxController.detailCashBookList.forEach((element) {
      List data = element;
      totalList.add(data.last);
    });
  }
}
