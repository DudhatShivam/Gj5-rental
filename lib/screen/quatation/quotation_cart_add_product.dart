import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../../getx/getx_controller.dart';

class QuotatiopnCartAddProduct extends StatefulWidget {
  final int? index;

  const QuotatiopnCartAddProduct({Key? key, this.index}) : super(key: key);

  @override
  State<QuotatiopnCartAddProduct> createState() =>
      _QuotatiopnCartAddProductState();
}

class _QuotatiopnCartAddProductState extends State<QuotatiopnCartAddProduct> {
  MyGetxController myGetxController = Get.find();
  final searchKey = GlobalKey<FormState>();
  TextEditingController productSearchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  List<dynamic> gotProductListFromPreferences = [];
  String returnDate = "";
  String deliveryDate = "";
  DateTime? returnNotFormatedDate;
  DateTime? deliveryNotFormatedDate;
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getProductList();
    deliveryDate =
        myGetxController.quotationCartList[widget.index ?? 0]['ddate'];
    returnDate = myGetxController.quotationCartList[widget.index ?? 0]['rdate'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 10,
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: FadeInLeft(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.teal,
                      size: 30,
                    ),
                  ),
                ),
              ),
              FadeInLeft(
                child: Text(
                  "Add Product",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 23,
                      color: Colors.teal),
                ),
              ),
            ],
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "D Date",
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
              Text(
                "R Date",
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
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
                        deliveryNotFormatedDate = value;
                        setState(() {
                          deliveryDate = "";
                          deliveryDate = DateFormat('dd-MM-yyyy')
                              .format(deliveryNotFormatedDate!);
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
                      deliveryDate.toString(),
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
                        returnNotFormatedDate = value;
                        setState(() {
                          returnDate = "";
                          returnDate = DateFormat('dd-MM-yyyy')
                              .format(returnNotFormatedDate!);
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
                      returnDate.toString(),
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: SearchField(
              controller: productSearchController,
              suggestionsDecoration: BoxDecoration(
                  border: Border.all(color: Colors.teal.shade400),
                  color: Colors.transparent),
              suggestionItemDecoration: BoxDecoration(),
              searchStyle: primaryStyle,
              searchInputDecoration: InputDecoration(
                  suffixIcon: productSearchController.text.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            myGetxController.isSetTextFieldData.value = false;
                            productSearchController.clear();
                            FocusScope.of(context).unfocus();
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
                    borderSide: BorderSide(color: Colors.teal),
                  )),
              onSuggestionTap: (val) {
                getIdFromTextFieldData();
              },
              itemHeight: 45,
              suggestions: gotProductListFromPreferences.map((e) {
                String search = e['default_code'] + " - " + e['name'];
                return SearchFieldListItem(search);
              }).toList(),
              suggestionAction: SuggestionAction.next,
            ),
          ),
        ],
      ),
    );
  }

  void getProductList() {
    getStringPreference('ProductList').then((value) {
      Map<String, dynamic> data = jsonDecode(value);
      gotProductListFromPreferences = data['results'];
    });
  }

  void getIdFromTextFieldData() {
    int? id;
    String value = productSearchController.text.split(' ').first;
    gotProductListFromPreferences.forEach((element) {
      if (element['default_code'] == value) {
        id = element['id'];
      }
    });
    print(id);
  }
}
