import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gj5_rental/screen/booking%20status/booking_status.dart';
import 'package:http/http.dart' as http;
import '../../Utils/utils.dart';

class ServiceLineScreen extends StatefulWidget {
  const ServiceLineScreen({Key? key}) : super(key: key);

  @override
  State<ServiceLineScreen> createState() => _ServiceLineScreenState();
}

class _ServiceLineScreenState extends State<ServiceLineScreen> {
  @override
  void initState() {
    super.initState();
    checkWlanForServiceLineData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).padding.top + 10,
        ),
        ScreenAppBar(
          screenName: "Service Line",
        )
      ],
    ));
  }

  void checkWlanForServiceLineData() {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                getServiceLineData(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            getServiceLineData(apiUrl, token);
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
    Uri uri = Uri.parse("http://${apiUrl}/api/product.service.line");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri,
        headers: {'Access-Token': token, 'Connection': 'keep-alive'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data['count']);
    }
  }
}
