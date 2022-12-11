import 'dart:convert';
import 'dart:io';
import '../../Utils/textfield_utils.dart';

import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/booking%20status/booking_status.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import 'create_order.dart';

class EditOrder extends StatefulWidget {
  final List list;
  final int index;

  const EditOrder({Key? key, required this.list, required this.index})
      : super(key: key);

  @override
  State<EditOrder> createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  String deliveryDate = "";
  String returnDate = "";
  MyGetxController myGetxController = Get.find();
  List<dynamic> lists = [];
  int indexs = 0;
  File? image1;
  File? image2;
  String? binaryImage1;
  String? binaryImage2;

  @override
  void initState() {
    super.initState();
    lists = widget.list;
    indexs = widget.index;
    setDefaultData();
    setImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          allScreenInitialSizedBox(context),
          ScreenAppBar(
            screenName: "Edit Order",
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: getWidth(0.04, context)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Name : ",
                      style: primaryStyle,
                    ),
                    Container(
                      width: getWidth(0.65, context),
                      child: textFieldWidget(
                          "Name",
                          nameController,
                          false,
                          false,
                          Colors.grey.withOpacity(0.1),
                          TextInputType.text,
                          0,
                          Colors.greenAccent,
                          1),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Mobile : ",
                      style: primaryStyle,
                    ),
                    Container(
                      width: getWidth(0.65, context),
                      child: textFieldWidget(
                          "Mobile Number",
                          numberController,
                          false,
                          false,
                          Colors.grey.withOpacity(0.1),
                          TextInputType.number,
                          0,
                          Colors.greenAccent,
                          1),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Remark :",
                      style: primaryStyle,
                    ),
                    Container(
                      width: getWidth(0.65, context),
                      child: textFieldWidget(
                          "Remark",
                          remarkController,
                          false,
                          false,
                          Colors.grey.withOpacity(0.1),
                          TextInputType.text,
                          0,
                          Colors.greenAccent,
                          1),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "D Date",
                      style: primaryStyle,
                    ),
                    InkWell(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        pickedDate(context).then((value) {
                          if (value != null) {
                            setState(() {
                              deliveryDate = DateFormat(showGlobalDateFormat)
                                  .format(value);
                            });
                          }
                        });
                      },
                      child: Container(
                        width: getWidth(0.65, context),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                        ),
                        child: Row(
                          children: [
                            calenderIcon,
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              deliveryDate,
                              style: primaryStyle,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "R Date",
                      style: primaryStyle,
                    ),
                    InkWell(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        pickedDate(context).then((value) {
                          if (value != null) {
                            setState(() {
                              returnDate = DateFormat(showGlobalDateFormat)
                                  .format(value);
                            });
                          }
                        });
                      },
                      child: Container(
                        width: getWidth(0.65, context),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                        ),
                        child: Row(
                          children: [
                            calenderIcon,
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              returnDate,
                              style: primaryStyle,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Image 1",
                      style: primaryStyle,
                    ),
                    image1 != null
                        ? Container(
                            width: getWidth(0.65, context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: primary2Color)),
                                  child: Image.file(
                                    image1!,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        image1 = null;
                                      });
                                    },
                                    child: cancelIcon)
                              ],
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              showImageOption(true);
                            },
                            child: imageContainer(context, "Pick Image"),
                          )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Image 2",
                      style: primaryStyle,
                    ),
                    image2 != null
                        ? Container(
                            width: getWidth(0.65, context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: primary2Color)),
                                  child: Image.file(
                                    image2!,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        image2 = null;
                                      });
                                    },
                                    child: cancelIcon)
                              ],
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              showImageOption(false);
                            },
                            child: imageContainer(context, "Pick Image 2"),
                          )
                  ],
                ),
              ],
            ),
          ),
          Obx(() => myGetxController.isUpdateData.value == false
              ? Padding(
                  padding: const EdgeInsets.all(15),
                  child: SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: primary2Color),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          checkWifiForupdateOrder();
                        },
                        child: Text("UPDATE"),
                      )),
                )
              : Padding(
                  padding: const EdgeInsets.all(15),
                  child: CenterCircularProgressIndicator(),
                ))
        ],
      ),
    );
  }

  void showImageOption(bool image1) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _getFromGallery(ImageSource.gallery, image1);
                },
                child: modelSheetContainer("Gallery"),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _getFromGallery(ImageSource.camera, image1);
                },
                child: modelSheetContainer("Camera"),
              )
            ],
          );
        });
  }

  _getFromGallery(ImageSource imageSource, bool isImage1) async {
    var pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        isImage1 == true
            ? image1 = File(pickedFile.path)
            : image2 = File(pickedFile.path);
      });
      if (isImage1 == true) {
        Uint8List? imageBytes = await image1?.readAsBytes(); //convert to bytes
        binaryImage1 = base64.encode(imageBytes!);
      } else {
        Uint8List? imageBytes = await image2?.readAsBytes(); //convert to bytes
        binaryImage2 = base64.encode(imageBytes!);
      }
    }
  }

  Future<void> checkWifiForupdateOrder() async {
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                updateData(value, token, lists[indexs]['id'].toString());
                // updateDetail(value, token, widget.lineId);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            updateData(value, token, lists[indexs]['id'].toString());
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  Future<void> updateData(String apiUrl, String token, String orderId) async {
    myGetxController.isUpdateData.value = true;

    Map tempBody;
    Map body;
    String name = nameController.text;
    String number = numberController.text;
    String remark = remarkController.text;
    String dDate=changeDateFormatTopPassApiDate(deliveryDate);
    String rDate=changeDateFormatTopPassApiDate(returnDate);
    body = {
      'customer_name': name,
      'mobile1': number,
      'remarks': remark,
      'delivery_date': dDate,
      'return_date': rDate
    };
    if (image1 != null) {
      tempBody = {'document_1': binaryImage1};
      body.addAll(tempBody);
    } else {
      tempBody = {'document_1': null};
      body.addAll(tempBody);
    }
    if (image2 != null) {
      tempBody = {'document_2': binaryImage2};
      body.addAll(tempBody);
    } else {
      tempBody = {'document_2': null};
      body.addAll(tempBody);
    }
    final response = await http.put(
        Uri.parse("http://$apiUrl/api/rental.rental/$orderId"),
        body: jsonEncode(body),
        headers: {'Access-Token': token, 'Content-Type': 'text/plain'});
    print(response.body);
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      updateQuotationData(apiUrl, token, orderId);
    } else {
      dialog(context, data['error_descrip'], Colors.red.shade300);
    }
    myGetxController.isUpdateData.value = false;
  }

  Future<void> updateQuotationData(
      String apiUrl, String token, String orderId) async {
    final response = await http.get(
        Uri.parse("http://$apiUrl/api/rental.rental/$orderId"),
        headers: {'Access-Token': token, 'Content-Type': 'application/http'});
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      myGetxController.quotationData.removeAt(widget.index);
      myGetxController.quotationData.insert(widget.index, data);
      Navigator.pop(context);
    } else {
      dialog(context, "Error In Getting Data", Colors.red.shade300);
    }
  }

  void setDefaultData() {
    nameController.text = lists[indexs]['customer_name'];
    numberController.text = lists[indexs]['mobile1'];
    remarkController.text = lists[indexs]['remarks'] ?? "";
    deliveryDate = changeDateFormat(lists[indexs]['delivery_date']);
    returnDate = changeDateFormat(lists[indexs]['return_date']);
  }

  setImage() async {
    final tempDir = await getTemporaryDirectory();
    if (lists[indexs]['document_1'] != null) {
      binaryImage1 = lists[indexs]['document_1'];
      image1 = await File('${tempDir.path}/image1.png').create();
      image1?.writeAsBytesSync(
          Base64Decoder().convert(lists[indexs]['document_1'].toString()));
    }
    if (lists[indexs]['document_2'] != null) {
      binaryImage2 = lists[indexs]['document_2'];
      image2 = await File('${tempDir.path}/image2.png').create();
      image2?.writeAsBytesSync(
          Base64Decoder().convert(lists[indexs]['document_2'].toString()));
    }
    setState(() {});
  }
}
