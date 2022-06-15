import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:gj5_rental/home/home.dart';
import 'package:gj5_rental/login/login_page.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAccount extends StatefulWidget {
  const AddAccount({Key? key}) : super(key: key);

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  List<dynamic> finalData = [];

  @override
  void initState() {
    super.initState();
    getAccountData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: finalData.isNotEmpty
            ? Center(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: finalData.length,
                    itemBuilder: (context, index) {
                      print(finalData.length);
                      return InkWell(
                        onTap: () {
                          checkAccountListLoginStatus(index);
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      finalData[index]['username'].toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      finalData[index]['branchName'].toString(),
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  finalData[index]['serverUrl'].toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              )
            : Container(
                child: Center(
                  child: Text(
                    "No Account added",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 21),
                  ),
                ),
              ));
  }

  getAccountData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var retreiveData = preferences.getString('accountList');
    setState(() {
      finalData = jsonDecode(retreiveData ?? "");
    });
    print("it is saved data");
    print(finalData);
  }

  Future<void> checkAccountListLoginStatus(int index) async {
    String serverUrl = finalData[index]['serverUrl'];
    String dbName = finalData[index]['dbName'];
    String username = finalData[index]['name'];
    String password = finalData[index]['password'];
    String branchName = finalData[index]['branchName'];
    try {
      if (serverUrl.startsWith("192")) {
        showConnectivity().then((result) async {
          if (result == ConnectivityResult.wifi) {
            checkAccountData(index, serverUrl, username, password);
          } else {
            dialog(context,"Connect to Showroom Network");
          }
        });
      } else {
        checkAccountData(index, serverUrl, username, password);
      }
    } on SocketException catch (err) {
      dialog(context,"Connect to Showroom Network");
    }
  }

  checkAccountData(
      int index, String serverUrl, String username, String password) async {
    try {
      String dbListUrl = "http://$serverUrl/api/dblist";
      final dbListResponse = await http.get(Uri.parse(dbListUrl));
      if (dbListResponse.statusCode == 200) {
        final response =
            await http.post(Uri.parse("http://$serverUrl/api/auth/get_tokens"),
                headers: <String, String>{
                  'Content-Type': 'application/http; charset=UTF-8',
                },
                body: jsonEncode({
                  'db': dbListResponse.body,
                  'username': username.trim(),
                  'password': password.trim()
                }));
        print(response.statusCode);
        if (response.statusCode == 200) {
          removePreference().whenComplete(() {
            final data = jsonDecode(response.body);
            setLogIn(true);
            setLogInData(
                    serverUrl,
                    data['access_token'],
                    data['uid'].toString(),
                    data['partner_id'].toString(),
                    data['name'].toString(),
                    data['image'].toString(),
                    data['branch_name'])
                .whenComplete(() {
              pushRemoveUntilMethod(context, HomeScreen());
            });
          });
        } else {
          pushMethod(
              context,
              LogInPage(
                savedServerUrl: serverUrl,
                savedUsername: username,
              ));
        }
      }
    } on SocketException catch (err) {
      print(err);
      dialog(context,"Connect to Showroom Network");
    }
  }
}
