import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:gj5_rental/constant/constant.dart';
import 'package:gj5_rental/drawer_pages/contact_us.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  MyGetxController myGetxController = Get.put(MyGetxController());
  SwipeActionController controller = SwipeActionController();

  @override
  void initState() {
    chekWlanForData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            allScreenInitialSizedBox(context),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: primary2Color.withOpacity(0.8)),
              height: getHeight(0.05, context),
              width: double.infinity,
              child: Text(
                "ABOUT US",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.8,
                    fontSize: 20),
              ),
            ),
            Expanded(
              child: Obx(() => myGetxController.showRoomList.isNotEmpty
                  ? ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: myGetxController.showRoomList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SwipeActionCell(
                              controller: controller,
                              key: ObjectKey(
                                  myGetxController.showRoomList[index]),
                              leadingActions: [
                                SwipeAction(
                                    onTap: (CompletionHandler handler) async {
                                      controller.closeAllOpenCell();
                                      Share.share(
                                          "Branch :: ${myGetxController.showRoomList[index]['showroom_name']} \n Mobile :: ${myGetxController.showRoomList[index]['mobile1'] ?? ""}/${myGetxController.showRoomList[index]['mobile2'] ?? ""} \n Address :: ${myGetxController.showRoomList[index]['address']} \n E-mail :: gj5fashion.01@gmail.com \n Facebook :: ${myGetxController.showRoomList[index]['facebook_id']} \n Instagram :: ${myGetxController.showRoomList[index]['instagram_id']} \n Location :: ${myGetxController.showRoomList[index]['location']}");
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.share,
                                      color: Colors.white,
                                    ),
                                    color: Colors.blue)
                              ],
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Color(0xffFEF2E2),
                                    border: Border.all(
                                        color:
                                            Color(0xff883E3F).withOpacity(0.1),
                                        width: 0.7),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      ":: ${myGetxController.showRoomList[index]['showroom_name']} ::",
                                      style: TextStyle(
                                          color: Color(0xff883E3F),
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.2,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Name : ",
                                          style: allCardMainText,
                                        ),
                                        Text(
                                          "GJ_05",
                                          style: allCardSubText,
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: FittedBox(
                                        child: Row(
                                          children: [
                                            Text(
                                              "Mobile : ",
                                              style: allCardMainText,
                                            ),
                                            myGetxController.showRoomList[index]
                                                        ['mobile1'] !=
                                                    null
                                                ? Row(
                                                    children: [
                                                      Text(
                                                        "${myGetxController.showRoomList[index]['mobile1']} ",
                                                        style: allCardSubText,
                                                      ),
                                                      CircleAvatar(
                                                          backgroundColor:
                                                              primary2Color,
                                                          radius: 13,
                                                          child: Icon(
                                                            Icons.call,
                                                            size: 17,
                                                            color: Colors.white,
                                                          )),
                                                    ],
                                                  )
                                                : Container(),
                                            myGetxController.showRoomList[index]
                                                        ['mobile2'] !=
                                                    null
                                                ? Row(
                                                    children: [
                                                      Text(
                                                        " / ${myGetxController.showRoomList[index]['mobile2']} ",
                                                        style: allCardSubText,
                                                      ),
                                                      CircleAvatar(
                                                          backgroundColor:
                                                              primary2Color,
                                                          radius: 13,
                                                          child: Icon(
                                                            Icons.call,
                                                            size: 17,
                                                            color: Colors.white,
                                                          ))
                                                    ],
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    myGetxController.showRoomList[index]
                                                ['mobile1'] !=
                                            null
                                        ? Row(
                                            children: [
                                              // Icon(
                                              //     Icons.whatsapp,
                                              //     color: Color(0xff0CC253),
                                              // ),
                                              Text(
                                                " ${myGetxController.showRoomList[index]['mobile1']}",
                                                style: allCardSubText,
                                              )
                                            ],
                                          )
                                        : Container(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.location_on_sharp,
                                          color: primary2Color,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${myGetxController.showRoomList[index]['address']}",
                                            style: allCardSubText,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Divider(
                                      color: Color(0xff883E3F),
                                      thickness: 0.5,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            launchApp(context,
                                                "mailto:gj5fashion.01@gmail.com?subject=Greetings&body=Hello%20GJ-05 Fashion");
                                          },
                                          child: Icon(
                                            Icons.email,
                                            color: primary2Color,
                                            size: 27,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: InkWell(
                                            onTap: () {
                                              launchApp(context,
                                                  "${myGetxController.showRoomList[index]['facebook_id']}");
                                            },
                                            child: Icon(
                                              Icons.facebook,
                                              color: primary2Color,
                                              size: 27,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            launchApp(context,
                                                "${myGetxController.showRoomList[index]['instagram_id']}");
                                          },
                                          child: Icon(
                                            FontAwesomeIcons.instagram,
                                            color: primary2Color,
                                            size: 27,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      })
                  : CenterCircularProgressIndicator()),
            )
          ],
        ),
      ),
    );
  }

  Future<void> chekWlanForData() async {
    String apiUrl = await getStringPreference('apiUrl');
    String accessToken = await getStringPreference('accessToken');
    try {
      if (apiUrl.toString().startsWith("192")) {
        showConnectivity().then((result) async {
          if (result == ConnectivityResult.wifi) {
            getAboutUsDetail(apiUrl, accessToken);
          } else {
            dialog(context, "Connect to Showroom Network", Colors.red.shade300);
          }
        });
      } else {
        getAboutUsDetail(apiUrl, accessToken);
      }
    } on SocketException catch (err) {
      dialog(context, "Connect to Showroom Network", Colors.red.shade300);
    }
  }

  Future<void> getAboutUsDetail(String apiUrl, String accessToken) async {
    final response = await http.get(
        Uri.parse("http://$apiUrl/api/branch.details"),
        headers: {'Access-Token': accessToken});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      myGetxController.showRoomList.addAll(data['results']);
    } else {
      dialog(context, "Something went wrong !", Colors.red.shade300);
    }
  }
}
