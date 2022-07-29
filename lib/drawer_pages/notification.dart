import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:gj5_rental/constant/constant.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/notification/notification_database.dart';
import 'package:gj5_rental/notification/notification_model.dart';

import '../screen/booking status/booking_status.dart';
import '../splash.dart';

class ShowNotification extends StatefulWidget {
  const ShowNotification({Key? key}) : super(key: key);

  @override
  State<ShowNotification> createState() => _ShowNotificationState();
}

class _ShowNotificationState extends State<ShowNotification> {
  MyGetxController myGetxController = Get.put(MyGetxController());
  NotificationDatabase notificationDatabase = NotificationDatabase();

  @override
  void initState() {
    getNotificationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          allScreenInitialSizedBox(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ScreenAppBar(
                screenName: "My Notification",
              ),
              InkWell(
                onTap: () {
                  getNotificationData();
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: refreshIcon,
                ),
              )
            ],
          ),
          Expanded(
            child: Obx(() => myGetxController.notificationList.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    shrinkWrap: true,
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: myGetxController.notificationList.length,
                    itemBuilder: (context, index) {
                      NotificationModel data =
                          myGetxController.notificationList[index];
                      return InkWell(
                        onTap: () {
                          notificationClickNavigation(
                              data.keyword, data.orderId);
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          margin:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Color(0xffE6ECF2), width: 0.7),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                child: Text(
                                  data.title.toString(),
                                  style: remarkTextStyle,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  data.body.toString(),
                                  style: allCardSubText,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "date :",
                                    style: allCardMainText,
                                  ),
                                  Text(
                                    data.date.toString(),
                                    style: deliveryDateStyle,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    })
                : Center(
                    child: Text(
                    "No Notification !",
                    style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 25,
                        fontWeight: FontWeight.w500),
                  ))),
          )
        ],
      ),
    );
  }

  Future<void> getNotificationData() async {
    myGetxController.notificationList.clear();
    List data = await notificationDatabase.dbSelect();
    myGetxController.notificationList.value = data.reversed.toList();
  }
}
