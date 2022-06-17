import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Utils/utils.dart';
import '../booking status/booking_status.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  void initState() {
    super.initState();
    checkWifiForProductDetailData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Coming Soon",
          style: primaryStyle,
        ),
      ),
    );
  }

  Future<void> checkWifiForProductDetailData() async {
    String apiUrl = await getStringPreference('apiUrl');
    String accessToken = await getStringPreference('accessToken');
    try {
      if (apiUrl.toString().startsWith("192")) {
        showConnectivity().then((result) async {
          if (result == ConnectivityResult.wifi) {
            getProductDetail(apiUrl, accessToken);
          } else {
            dialog(context, "Connect to Showroom Network");
          }
        });
      } else {
        getProductDetail(apiUrl, accessToken);
      }
    } on SocketException catch (err) {
      dialog(context, "Connect to Showroom Network");
    }
  }

  Future<void> getProductDetail(String apiUrl, String accessToken) async {
    String domain =
        "[('product['id']', '!=', 'null')]";
    var params = {'filters': domain.toString()};
    Uri uri = Uri.parse("http://$apiUrl/api/product.details");
    final finalUri = uri.replace(queryParameters: params);
    final response =
        await http.get(finalUri, headers: {'Access-Token': accessToken});
    print(response.statusCode);
    if(response.statusCode == 200){
      final data=jsonDecode(response.body);
      print(data['count']);
    }
  }
}
