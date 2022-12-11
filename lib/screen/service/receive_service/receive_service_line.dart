import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gj5_rental/screen/service_line/service_line.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../Utils/utils.dart';
import '../service_detail.dart';

class ReceiveServiceLine extends StatelessWidget {
  final List<dynamic> list;
  final int index;
  final bool isServiceScreen;
  final int? serviceLineId;

  const ReceiveServiceLine({
    Key? key,
    required this.list,
    required this.index,
    required this.isServiceScreen,
    this.serviceLineId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sure , Are you want to Receive ?",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 19,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  "Product : ",
                  style: allCardMainText,
                ),
                list[index]['product_id']['default_code'] != null
                    ? Text(
                        "[${list[index]['product_id']['default_code']}] ",
                        style: allCardSubText,
                      )
                    : Container(),
                list[index]['service_type'] != null
                    ? Text(
                        "/ ${list[index]['service_type']} ",
                        style: allCardSubText,
                      )
                    : Container(),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade300),
                    onPressed: () {
                      checkWlanForReceiveService(context);
                    },
                    child: Text("Ok")),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red.shade300),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
              ],
            )
          ],
        ),
      ),
    );
  }

  checkWlanForReceiveService(BuildContext context) {
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                receiveService(value, token, context);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            receiveService(value, token, context);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  Future<void> receiveService(
      String apiUrl, String token, BuildContext context) async {
    final response = await http.put(
      Uri.parse(
          "http://$apiUrl/api/product.service.line/${list[index]['id']}/receive_product"),
      headers: {
        'Access-Token': token,
      },
    );
    if (response.statusCode == 200) {
      if (isServiceScreen == false) {
        list.removeAt(index);
      } else {
        getDataOfServiceDetail(context, apiUrl, token, serviceLineId ?? 0);
      }
      Navigator.of(context, rootNavigator: true).pop();
      dialog(context, "Product Receive Successfully", Colors.green.shade300);
    } else {
      dialog(context, "Error In Receive Product", Colors.red.shade300);
    }
  }
}
