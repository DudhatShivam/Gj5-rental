import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/home/home.dart';
import 'package:gj5_rental/login/account_db/account_database.dart';
import 'package:gj5_rental/login/account_model/account_model.dart';
import 'package:gj5_rental/login/add_account.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/utils.dart';
import '../constant/constant.dart';

class LogInPage extends StatefulWidget {
  final String? savedServerUrl;
  final String? savedUsername;
  final bool? isAccountEmptyList;

  const LogInPage(
      {Key? key,
      this.savedServerUrl,
      this.savedUsername,
      this.isAccountEmptyList})
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
    userNameController.text = widget.savedUsername ?? "";
    serverCode.text = widget.savedServerUrl ?? "";
    getAccountData();
  }

  AccountDatabase accountDatabase = AccountDatabase();

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController serverCode = TextEditingController();
  MyGetxController myGetxController = Get.put(MyGetxController());
  final form = GlobalKey<FormState>();
  List<dynamic> finalData = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEFF1F3),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            mainColor1.withOpacity(0.25),
            mainColor2.withOpacity(0.25)
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).padding.top +
                    getHeight(0.25, context),
                padding: const EdgeInsets.only(left: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        FadeInLeft(
                          child: Text(
                            "Welcome",
                            style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff223843)),
                          ),
                        ),
                        Lottie.asset('assets/images/login_animation.json',
                            height: 40, width: 40),
                      ],
                    ),
                    FadeInLeft(
                      child: Text(
                        "Sign in to continue!",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffA5ABB5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: getHeight(0.02, context),
              // ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xffFBF8FB),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                height: MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).padding.top +
                        getHeight(0.25, context)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Obx(() => Text(
                          myGetxController.logInPageError.value,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.red),
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    Form(
                        key: form,
                        child: Column(
                          children: [
                            textFieldWidget(
                                "Server Url",
                                serverCode,
                                false,
                                false,
                                Colors.white70,
                                TextInputType.text,
                                25,
                                Color(0xffFB578E).withOpacity(0.3),
                                1),
                            SizedBox(
                              height: 20,
                            ),
                            textFieldWidget(
                                "Username ",
                                userNameController,
                                false,
                                false,
                                Colors.white70,
                                TextInputType.text,
                                25,
                                Color(0xffFB578E).withOpacity(0.3),
                                1),
                            SizedBox(
                              height: 20,
                            ),
                            textFieldWidget(
                                "Password",
                                passwordController,
                                true,
                                false,
                                Colors.white70,
                                TextInputType.text,
                                25,
                                Color(0xffFB578E).withOpacity(0.3),
                                1),
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Obx(() => myGetxController
                                          .isLoggedIn.value ==
                                      false
                                  ? InkWell(
                                      onTap: () {
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
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              gradient: LinearGradient(colors: [
                                                mainColor1,
                                                mainColor2
                                              ])),
                                          alignment: Alignment.center,
                                          height: 60,
                                          width: double.infinity,
                                          child: Text(
                                            "Login",
                                            style: TextStyle(
                                                color: Colors.white,
                                                letterSpacing: 1,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          )),
                                    )
                                  : CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xffFB578E)),
                                    )),
                            )
                          ],
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          finalData.isNotEmpty
                              ? pushMethod(context, AddAccount())
                              : showToast("Login first");
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                mainColor1.withOpacity(0.25),
                                mainColor2.withOpacity(0.25)
                              ])),
                          alignment: Alignment.center,
                          height: 60,
                          width: double.infinity,
                          child: Text(
                            "Switch Account",
                            style: TextStyle(
                              color: Color(0xffF66395),
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              letterSpacing: 1,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              MediaQuery.of(context).viewInsets.bottom > 0
                  ? Padding(padding: EdgeInsets.only(bottom: 55))
                  : Container()
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
            dialog(context, "Connect to Showroom Network", Colors.red.shade300);
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
    List<AccountModel> accountList = await accountDatabase.dbSelect();
    if (accountList.isNotEmpty) {
      accountList.forEach((element) async {
        if (element.serverUrl == serverUrl &&
            element.dbName == dbName &&
            element.name == username) {
          await accountDatabase.dbDelete(element.id);
        }
      });
      insertData(
          serverUrl, dbName, profileName, username, password, branchName);
    } else {
      insertData(
          serverUrl, dbName, profileName, username, password, branchName);
    }
  }

  insertData(String serverUrl, String dbName, String profileName,
      String username, String password, String branchName) async {
    AccountModel accountModel = AccountModel(
        serverUrl: serverUrl,
        dbName: dbName,
        userName: profileName,
        name: username,
        password: password,
        branchName: branchName);
    await accountDatabase.dbInsert(accountModel);
  }
   getAccountData() async {
     finalData = await accountDatabase.dbSelect();
  }

  getAndSetData(String serverUrl, String username, String password) async {
    try {
      String dbListUrl = "http://$serverUrl/api/dblist";
      final DbListResponse = await http.get(Uri.parse(dbListUrl));

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
        if (response.statusCode == 200) {
          myGetxController.logInPageError.value = "";
          final data = jsonDecode(response.body);
          if (data['is_user'] == true) {
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
                    data['past_day_order'].toString(),
                    data['next_day_order'].toString(),
                    data['is_user'] ?? true,
                    data['is_servicer'] ?? true,
                    data['is_receiver'] ?? true,
                    data['is_deliver'] ?? true,
                    data['change_product'] ?? true,
                    data['is_manager'] ?? true,
            data['daily_cashbook'])
                .whenComplete(() {
              setLogIn(true);
              myGetxController.isLoggedIn.value = false;
              pushRemoveUntilMethod(
                  context,
                  HomeScreen(
                    userId: data['partner_id'],
                  ));
            });
          } else {
            dialog(context, "You have no Access-Rights to Login",
                Colors.red.shade300);
          }
        } else if (response.statusCode == 400) {
          myGetxController.isLoggedIn.value = false;
          myGetxController.logInPageError.value =
              "Enter valid server url or username or password";
        } else if (response.statusCode == 401) {
          myGetxController.isLoggedIn.value = false;
          myGetxController.logInPageError.value = "user not found";
        } else {
          myGetxController.isLoggedIn.value = false;
          myGetxController.logInPageError.value =
              "logIn response statusCode different then 200,400,401";
        }
      } else {
        myGetxController.isLoggedIn.value = false;
        myGetxController.logInPageError.value =
            "dbList response statusCode different then 200";
      }
    } on SocketException catch (err) {
      myGetxController.isLoggedIn.value = false;
      myGetxController.logInPageError.value =
          "Something Went Wrong ! in socket exception";
    }
  }
}
