import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import '../../Utils/textfield_utils.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/booking%20status/booking_status.dart';
import 'package:gj5_rental/screen/quatation/quatation.dart';
import 'package:gj5_rental/screen/quatation/quotation_detail.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

import '../../Utils/utils.dart';
import '../../constant/constant.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({Key? key}) : super(key: key);

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController number2Controller = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String returnDate = "";
  String deliveryDate = "";
  String DformatedDate = "";
  String RformatedDate = "";
  DateTime returnNotFormatedDate=DateTime.now();
  DateTime deliveryNotFormatedDate = DateTime.now();
  bool initialValidDDate = true;
  bool initialValidRDate = true;
  bool isValidDDate = true;
  bool isValidRDate = true;
  File? image1;
  File? image2;
  String? binaryImage1;
  String? binaryImage2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            allScreenInitialSizedBox(context),
            ScreenAppBar(screenName: "Create Order"),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: getWidth(0.04, context)),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
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
                        ), //name
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Address : ",
                              style: primaryStyle,
                            ),
                            Container(
                              width: getWidth(0.65, context),
                              child: textFieldWidget(
                                  "Address",
                                  addressController,
                                  false,
                                  false,
                                  Colors.grey.withOpacity(0.1),
                                  TextInputType.text,
                                  0,
                                  Colors.greenAccent,
                                  3),
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
                              child: numberValidatorTextfield(
                                  numberController, "Mobile number"),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        //number
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mobile2 : ",
                        style: primaryStyle,
                      ),
                      FittedBox(
                        child: Container(
                          width: getWidth(0.65, context),
                          child: numberValidatorTextfield(
                              number2Controller, "Mobile number2"),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  remarkContainer(context, remarkController, 0.65, 0,
                      MainAxisAlignment.spaceBetween),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "D Date : ",
                        style: primaryStyle,
                      ),
                      InkWell(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          pickedDate(context).then((value) {
                            if (value != null) {
                              deliveryNotFormatedDate = value;
                              setState(() {
                                isValidDDate = true;
                                initialValidDDate = true;
                                deliveryDate = DateFormat(passApiGlobalDateFormat)
                                    .format(deliveryNotFormatedDate);
                                DformatedDate = DateFormat(showGlobalDateFormat)
                                    .format(deliveryNotFormatedDate);
                              });
                            }
                          });
                        },
                        child: Container(
                          width: getWidth(0.65, context),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 45,
                          decoration: BoxDecoration(
                            border: isValidDDate == true &&
                                    initialValidDDate == true
                                ? null
                                : Border.all(color: Colors.red),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          child: Row(
                            children: [
                              calenderIcon,
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                DformatedDate,
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
                        "R Date : ",
                        style: primaryStyle,
                      ),
                      InkWell(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          pickedDate(context).then((value) {
                            if (value != null) {
                              returnNotFormatedDate = value;
                              setState(() {
                                isValidRDate = true;
                                initialValidRDate = true;
                                returnDate = DateFormat(passApiGlobalDateFormat)
                                    .format(returnNotFormatedDate);
                                RformatedDate = DateFormat(showGlobalDateFormat)
                                    .format(returnNotFormatedDate);
                              });
                            }
                          });
                        },
                        child: Container(
                          width: getWidth(0.65, context),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 45,
                          decoration: BoxDecoration(
                            border: isValidRDate == true &&
                                    initialValidRDate == true
                                ? null
                                : Border.all(color: Colors.red),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          child: Row(
                            children: [
                              calenderIcon,
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                RformatedDate,
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
                        "Image 1 : ",
                        style: primaryStyle,
                      ),
                      image1 == null
                          ? InkWell(
                              onTap: () {
                                showImageOption(true);
                              },
                              child: imageContainer(context, "Pick Image"),
                            )
                          : Container(
                              width: getWidth(0.65, context),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: primary2Color)),
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
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Image 2 : ",
                        style: primaryStyle,
                      ),
                      image2 == null
                          ? InkWell(
                              onTap: () {
                                showImageOption(false);
                              },
                              child: imageContainer(context, "Pick Image 2"),
                            )
                          : Container(
                              width: getWidth(0.65, context),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: primary2Color)),
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
                                    child: cancelIcon,
                                  )
                                ],
                              ),
                            )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 45,
              margin: const EdgeInsets.all(15),
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(primary: primary2Color),
                  onPressed: () {
                    if (_formKey.currentState?.validate() == true &&
                        nameController.text.isNotEmpty &&
                        numberController.text.isNotEmpty &&
                        addressController.text.isNotEmpty) {
                      checkValidation();
                    }
                  },
                  child: Text("CREATE ORDER")),
            ),
            Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 10))
          ],
        ),
      ),
    );
  }

  checkValidation() {
    if (returnDate == "" || deliveryDate == "") {
      setState(() {
        isValidDDate = false;
        isValidRDate = false;
        initialValidDDate = false;
        initialValidRDate = false;
      });
    } else {
      if (deliveryNotFormatedDate
              .isBefore(returnNotFormatedDate) ==
          true) {
        checkWifiForCreateOrder();
      } else {
        setState(() {
          isValidRDate = false;
        });
        showToast("You can not select Delivery date bigger than Return Date!");
      }
    }
  }

  checkWifiForCreateOrder() {
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                createOrder(value, token.toString());
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            createOrder(value, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  Future<void> createOrder(String apiUrl, String token) async {
    CustomProgressDialog progressDialog =
        CustomProgressDialog(context, blur: 10, dismissable: false);
    print(returnDate);
    print(deliveryDate);
    progressDialog.setLoadingWidget(CenterCircularProgressIndicator());
    progressDialog.show();
    MyGetxController myGetxController = Get.find();
    Map body;
    Map tempBody;
    final partnerIdResponse =
        await http.post(Uri.parse("http://$apiUrl/api/res.customer"),
            headers: {'Access-Token': token},
            body: jsonEncode({
              'name': nameController.text,
              'mobile1': numberController.text,
              'address': addressController.text
            }));
    Map data = jsonDecode(partnerIdResponse.body);
    body = {
      'partner_id': data['id'],
      'mobile1': numberController.text,
      'mobile2': number2Controller.text,
      'delivery_address': addressController.text,
      'delivery_date': deliveryDate,
      'return_date': returnDate,
      'remarks': remarkController.text,
    };
    if (image1 != null) {
      tempBody = {'document_1': binaryImage1};
      body.addAll(tempBody);
    }
    if (image2 != null) {
      tempBody = {'document_2': binaryImage2};
      body.addAll(tempBody);
    }
    final response =
        await http.post(Uri.parse("http://$apiUrl/api/rental.rental"),
            headers: {
              'Access-Token': token,
            },
            body: jsonEncode(body));
    Map datas = jsonDecode(response.body);
    print(response.body);

    if (response.statusCode == 200) {
      myGetxController.quotationData.clear();
      quotationOffset = 0;
      getDraftOrderData(context, apiUrl, token, 0).whenComplete(() {
        progressDialog.dismiss();
        pushMethod(
            context,
            QuatationDetailScreen(
              id: datas['id'],
              isFromAnotherScreen: false,
            ));
      });
    } else {
      progressDialog.dismiss();
      dialog(context, "Error in Order Creation !", Colors.red.shade300);
    }
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
}

modelSheetContainer(String text) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    alignment: Alignment.center,
    height: 50,
    width: double.infinity,
    decoration: BoxDecoration(
        border: Border.all(color: primary2Color.withOpacity(0.5), width: 0.8),
        color: primary2Color.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20)),
    child: Text(
      text,
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 19,
          letterSpacing: 1),
    ),
  );
}

imageContainer(BuildContext context, String text) {
  return Container(
    alignment: Alignment.center,
    width: getWidth(0.65, context),
    padding: EdgeInsets.symmetric(horizontal: 10),
    height: 45,
    decoration: BoxDecoration(
      color: Colors.grey.withOpacity(0.1),
    ),
    child: Text(text,
        style: TextStyle(
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w500,
            fontSize: 16)),
  );
}
