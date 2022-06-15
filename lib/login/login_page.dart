import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/home/home.dart';
import 'package:gj5_rental/login/add_account.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/utils.dart';
import '../constant/constant.dart';
import '../myactivity.dart';

class LogInPage extends StatefulWidget {
  final String? savedServerUrl;
  final String? savedUsername;

  const LogInPage({Key? key, this.savedServerUrl, this.savedUsername})
      : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("SavedData");
    userNameController.text = widget.savedUsername ?? "";
    serverCode.text = widget.savedServerUrl ?? "";
    getAccountData();
  }

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController serverCode = TextEditingController();
  MyGetxController myGetxController = Get.put(MyGetxController());
  final form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top +
                    getHeight(0.2, context),
                //318172
              ),
              Text(
                "Log In",
                style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Comfortaa'),
              ),
              SizedBox(
                height: getHeight(0.02, context),
              ),
              Obx(() => Text(
                    myGetxController.logInPageError.value,
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.red),
                  )),
              SizedBox(
                height: getHeight(0.02, context),
              ),
              Form(
                  key: form,
                  child: Column(
                    children: [
                      textFieldWidget(
                          "Your server url",
                          serverCode,
                          false,
                          false,
                          Colors.white,
                          TextInputType.text,
                          25,
                          Colors.white,
                          1),
                      SizedBox(
                        height: 20,
                      ),
                      textFieldWidget(
                          "Your username ",
                          userNameController,
                          false,
                          false,
                          Colors.white,
                          TextInputType.text,
                          25,
                          Colors.white,
                          1),
                      SizedBox(
                        height: 20,
                      ),
                      textFieldWidget(
                          "Your password",
                          passwordController,
                          true,
                          false,
                          Colors.white,
                          TextInputType.text,
                          25,
                          Colors.white,
                          1),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child:
                            Obx(() => myGetxController.isLoggedIn.value == false
                                ? SizedBox(
                                    height: 60,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xff318172),
                                          onPrimary: Colors.white,
                                        ),
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          if (form.currentState!.validate()) {
                                            myGetxController.isLoggedIn.value =
                                                true;
                                            checkLogIn(
                                                serverCode.text,
                                                userNameController.text,
                                                passwordController.text);
                                          }
                                        },
                                        child: Text("LOGIN")))
                                : CircularProgressIndicator()),
                      )
                    ],
                  )),
              SizedBox(
                height: 15,
              ),
              InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddAccount()));
                  },
                  child: Text(
                    "switch account",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 10))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkLogIn(
      String serverUrl, String username, String password) async {
    try {
      if (serverUrl.startsWith("192")) {
        showConnectivity().then((value) async {
          if (value == ConnectivityResult.wifi) {
            getAndSetData(serverUrl, username, password);
          } else {
            dialog(context, "Connect to Showroom Network");
            myGetxController.isLoggedIn.value = false;
          }
        });
      } else {
        getAndSetData(serverUrl, username, password);
      }
    } on SocketException catch (err) {
      myGetxController.isLoggedIn.value = false;
    }
  }

  void setAddAccountData(String serverUrl, String dbName, String profileName,
      String username, String password, String branchName) async {
    getAccountData().then((value) async {
      if (value != null) {
        List<dynamic> getdata = value;
        var toRemove = [];
        getdata.forEach((element) {
          if (element['serverUrl'] == serverUrl &&
              element['dbName'] == dbName &&
              element['name'] == username) {
            print("inside called");
            toRemove.add(element);
          }
        });
        getdata.removeWhere((element) => toRemove.contains(element));
        Map data = {
          'serverUrl': serverUrl,
          'dbName': dbName,
          'name': username,
          'username': profileName,
          'password': password,
          'branchName': branchName
        };
        List<dynamic> accountData = [];
        accountData.add(getdata);
        getdata.add(data);
        var list = jsonEncode(getdata);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences
            .setString("accountList", list)
            .whenComplete(() => print("DataSet"));
      } else {
        Map data = {
          'serverUrl': serverUrl,
          'dbName': dbName,
          'name': username,
          'username': profileName,
          'password': password,
          'branchName': branchName
        };
        List<dynamic> accountData = [];
        accountData.add(data);
        var list = jsonEncode(accountData);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences
            .setString("accountList", list)
            .whenComplete(() => print("DataSet"));
      }
    });
  }

  Future getAccountData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var retreiveData = preferences.getString('accountList');
    if (retreiveData?.isNotEmpty == true) {
      List<dynamic> finalData = jsonDecode(retreiveData ?? "");
      print("it is saved account list");
      return finalData;
    }
    return null;
  }

  getAndSetData(String serverUrl, String username, String password) async {
    try {
      String dbListUrl = "http://$serverUrl/api/dblist";
      final DbListResponse = await http.get(Uri.parse(dbListUrl));
      print(DbListResponse.body);
      if (DbListResponse.statusCode == 200) {
        myGetxController.logInPageError.value = "";
        final response =
            await http.post(Uri.parse("http://$serverUrl/api/auth/get_tokens"),
                headers: <String, String>{
                  'Content-Type': 'application/http; charset=UTF-8',
                },
                body: jsonEncode({
                  'db': DbListResponse.body,
                  'username': username.trim(),
                  'password': password.trim()
                }));
        print(response.statusCode);
        if (response.statusCode == 200) {
          myGetxController.logInPageError.value = "";
          print(response.body);
          final data = jsonDecode(response.body);
          setAddAccountData(
              serverCode.text,
              DbListResponse.body.toString(),
              data['name'].toString(),
              username,
              password.trim(),
              data['branch_name'].toString());
          setLogInData(
            serverUrl,
            data['access_token'],
            data['uid'].toString(),
            data['partner_id'].toString(),
            data['name'].toString(),
            data['image'].toString(),
            data['branch_name'],
          ).whenComplete(() {
            setLogIn(true);
            myGetxController.isLoggedIn.value = false;
            pushRemoveUntilMethod(context, HomeScreen());
          });
        } else if (response.statusCode == 400) {
          myGetxController.isLoggedIn.value = false;
          myGetxController.logInPageError.value =
              "Enter valid server url or username or password";
        } else if (response.statusCode == 401) {
          myGetxController.isLoggedIn.value = false;
          myGetxController.logInPageError.value = "user not found";
        } else {
          myGetxController.isLoggedIn.value = false;
          myGetxController.logInPageError.value = "something went wrong";
        }
      } else {
        myGetxController.isLoggedIn.value = false;
        myGetxController.logInPageError.value = "something went wrong";
      }
    } on SocketException catch (err) {
      myGetxController.isLoggedIn.value = false;
      myGetxController.logInPageError.value = "something went wrong";
    }
  }
}
