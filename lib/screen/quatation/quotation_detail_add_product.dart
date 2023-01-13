import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:gj5_rental/constant/binary_image_covert.dart';
import 'package:gj5_rental/screen/quatation/create_order.dart';
import 'package:image_picker/image_picker.dart';

import '../../Utils/textfield_utils.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/screen/booking%20status/booking_status.dart';
import 'package:gj5_rental/screen/quatation/quotation_const/quotation_constant.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../../getx/getx_controller.dart';
import '../order/add_sub_product/confirm_order_add_subproduct.dart';

class QuotationDetailAddProduct extends StatefulWidget {
  const QuotationDetailAddProduct(
      {Key? key,
      this.deliveryDate,
      this.returnDate,
      this.orderId,
      required this.confirmOrderScreen})
      : super(key: key);
  final String? deliveryDate;
  final String? returnDate;
  final int? orderId;
  final bool confirmOrderScreen;

  @override
  State<QuotationDetailAddProduct> createState() =>
      _QuotationDetailAddProductState();
}

class _QuotationDetailAddProductState extends State<QuotationDetailAddProduct> {
  TextEditingController productSearchController = TextEditingController();
  TextEditingController rentController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  MyGetxController myGetxController = Get.put(MyGetxController());
  String returnDate = "";
  String deliveryDate = "";
  List<dynamic> responseOfApi = [];
  bool isDisplayResponseApiList = false;
  int? productId;
  int? orderId;
  Uint8List? _bytesImage;
  File? image1;
  String? binaryImage1;
  bool isSubmitLoad = false;

  @override
  void initState() {
    super.initState();
    orderId = widget.orderId;
    getPreferenceProductList();
    deliveryDate = changeDateFormat(widget.deliveryDate ?? "");
    returnDate = changeDateFormat(widget.returnDate ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            allScreenInitialSizedBox(context),
            ScreenAppBar(
              screenName: "Add Product in Order",
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "D Date",
                  style: allCardSubText,
                ),
                Text(
                  "R Date",
                  style: allCardSubText,
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      pickedDate(context).then((value) {
                        if (value != null) {
                          setState(() {
                            deliveryDate =
                                DateFormat(showGlobalDateFormat).format(value);
                          });
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      height: 48,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        deliveryDate,
                        style: primaryStyle,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      pickedDate(context).then((value) {
                        if (value != null) {
                          setState(() {
                            returnDate =
                                DateFormat(showGlobalDateFormat).format(value);
                          });
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      height: 48,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        returnDate,
                        style: primaryStyle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Obx(() => SearchField(
                          controller: productSearchController,
                          maxSuggestionsInViewPort: 5,
                          hasOverlay: false,
                          suggestionsDecoration: BoxDecoration(
                            border: Border.all(color: primary2Color),
                          ),
                          searchStyle: primaryStyle,
                          searchInputDecoration: InputDecoration(
                              suffixIcon:
                                  productSearchController.text.isNotEmpty
                                      ? InkWell(
                                          onTap: () {
                                            myGetxController.isSetTextFieldData
                                                .value = false;
                                            productSearchController.clear();
                                            FocusScope.of(context).unfocus();
                                            setState(() {
                                              isDisplayResponseApiList = false;
                                            });
                                          },
                                          child: Container(
                                            child: Icon(
                                              Icons.cancel,
                                              color: primaryColor,
                                              size: 30,
                                            ),
                                          ),
                                        )
                                      : null,
                              hintText: "Search Product",
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primary2Color),
                              )),
                          onSuggestionTap: (val) {
                            FocusScope.of(context).unfocus();
                            getResponseProductApiList();
                          },
                          itemHeight: 50,
                          suggestions: myGetxController
                              .isMainProductFalseProductList
                              .map((e) {
                            String search =
                                "${e['default_code']} -- ${e['name']}";
                            return SearchFieldListItem(search);
                          }).toList(),
                          suggestionAction: SuggestionAction.next,
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            isDisplayResponseApiList == true
                ? Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.zero,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: responseOfApi.length,
                              itemBuilder: (context, index) {
                                return bookingStatusResponseCard(
                                    responseOfApi, index);
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: getWidth(0.04, context)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Rent : ",
                                  style: primaryStyle,
                                ),
                                Container(
                                  width: getWidth(0.65, context),
                                  child: textFieldWidget(
                                      "Rent",
                                      rentController,
                                      false,
                                      false,
                                      Colors.grey.withOpacity(0.1),
                                      TextInputType.number,
                                      0,
                                      Colors.greenAccent,
                                      1,
                                      ""),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: getWidth(0.04, context)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Remark : ",
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
                                      1,
                                      ""),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              _bytesImage != null &&
                                      _bytesImage?.isNotEmpty == true
                                  ? Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Image.memory(
                                            _bytesImage!,
                                            height: getWidth(0.27, context),
                                            width: getWidth(0.27, context),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                width: 10,
                              ),
                              image1 == null
                                  ? InkWell(
                                      onTap: () {
                                        showImageOption();
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: imageContainer(
                                            context, "Select Image",
                                            con_width: getWidth(0.33, context),
                                            border_radius: 10),
                                      ),
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(top: 10),
                                      width: getWidth(0.64, context),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          binary_image_container(image1,
                                              h: getWidth(0.27, context),
                                              w: getWidth(0.27, context)),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                image1 = null;
                                              });
                                            },
                                            child: cancelIcon,
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                          isSubmitLoad
                              ? CenterCircularProgressIndicator()
                              : Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: SizedBox(
                                      width: double.infinity,
                                      height: 43,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: primary2Color),
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          checkWifiForAddProduct();
                                        },
                                        child: Text("ADD"),
                                      )),
                                ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void showImageOption() {
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
                  _getFromGallery(ImageSource.gallery);
                },
                child: modelSheetContainer("Gallery"),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _getFromGallery(ImageSource.camera);
                },
                child: modelSheetContainer("Camera"),
              )
            ],
          );
        });
  }

  _getFromGallery(ImageSource imageSource) async {
    var pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      image1 = File(pickedFile.path);
      Uint8List? imageBytes = await image1?.readAsBytes(); //convert to bytes
      binaryImage1 = base64.encode(imageBytes!);
      setState(() {});
    }
  }

  getResponseProductApiList() {
    String value =
        productSearchController.text.split('--').first.removeAllWhitespace;
    myGetxController.isMainProductFalseProductList.forEach((element) {
      if (element['default_code'] == value) {
        productId = element['id'];
        rentController.text = element['rent'].toString();
        String s = element['image_medium'] ?? "";
        if (s.isNotEmpty) {
          _bytesImage = convert_image(s);
        }
        setState(() {});
      }
    });
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                getData(value, productId ?? 0, token);
              } else {
                responseOfApi.clear();
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            getData(value, productId ?? 0, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  getData(String apiUrl, int id, String token) async {
    final response = await http.put(
        Uri.parse("http://$apiUrl/api/product.product/$id/get_booking_status"),
        headers: {
          'Access-Token': token,
        }).whenComplete(() {
      setState(() {
        isDisplayResponseApiList = true;
      });
    });
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['status'] == 1) {
      responseOfApi = data['results'];
    }
  }

  checkWifiForAddProduct() {
    getStringPreference('apiUrl').then((value) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (value.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                widget.confirmOrderScreen == true
                    ? chekSubProductIsAvailable(value, token)
                    : addProduct(value, token, true);
              } else {
                responseOfApi.clear();
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            widget.confirmOrderScreen == true
                ? chekSubProductIsAvailable(value, token)
                : addProduct(value, token, true);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  Future<int> addProduct(String apiUrl, String token, bool navigatePop) async {
    try {
      isSubmitLoad = true;
      setState(() {});
      String rent = rentController.text;
      String remark = remarkController.text;
      String dDate = changeDateFormatTopPassApiDate(deliveryDate);
      String rDate = changeDateFormatTopPassApiDate(returnDate);
      final response;
      String url =
          "http://$apiUrl/api/rental.rental/$orderId/add_product_from_api?product_id=$productId&delivery_date=$dDate&return_date=$rDate&rent=$rent&remarks=$remark";
      if (binaryImage1 != null) {
        response = await http.put(Uri.parse(url),
            body: jsonEncode({"customer_image": binaryImage1}),
            headers: {
              'Access-Token': token,
            });
      } else {
        response = await http.put(Uri.parse(url), headers: {
          'Access-Token': token,
        });
      }
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        if (widget.confirmOrderScreen == false) {
          checkQuotationAndOrderDetailData(context, orderId ?? 0, false);
          Navigator.pop(context);
        } else {
          checkWlanForOrderDetailScreen(context, orderId ?? 0);
          if (navigatePop == true) {
            Navigator.pop(context);
          }
          return data['id'];
        }
      } else {
        dialog(context, data['msg'] ?? "Some thing went wrong",
            Colors.red.shade300);
      }
    } catch (e) {
      isSubmitLoad = false;
    }
    setState(() {});
    return 0;
  }

  void getPreferenceProductList() {
    if (myGetxController.isMainProductFalseProductList.isEmpty == true) {
      getStringPreference('ProductList').then((value) async {
        Map<String, dynamic> data = await jsonDecode(value);
        List<dynamic> lst = await data['results'];
        lst.forEach((element) {
          if (element['is_main_product'] == true) {
            myGetxController.isMainProductFalseProductList.add(element);
          }
        });
      });
    }
  }

  Future<void> chekSubProductIsAvailable(String apiUrl, String token) async {
    final response = await http.put(
        Uri.parse(
            "http://$apiUrl/api/product.product/$productId/check_sub_product"),
        headers: {
          'Access-Token': token,
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['success'] == 1) {
        int lineId = await addProduct(apiUrl, token, false);
        addWholeSubProductInList(lineId).then((value) {
          pushMethod(
              context,
              ConfirmOrderAddSubProduct(
                orderLineId: lineId,
                productName: productSearchController.text,
                orderId: orderId ?? 0,
                subProductList: value,
                rent: rentController.text,
                remark: remarkController.text,
                returnDate: returnDate,
                deliveryDate: deliveryDate,
              ));
        });
      } else {
        addProduct(apiUrl, token, true);
      }
    } else {
      dialog(context, "Something Went Wrong", Colors.red.shade300);
    }
  }
}
