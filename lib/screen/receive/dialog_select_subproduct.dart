import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';

import '../../Utils/utils.dart';

class DialogSelectSubProduct extends StatefulWidget {
  final List<dynamic> subProductList;
  final String defaultCode;
  final int orderLineId;
  final String orderLineIsReceive;

  const DialogSelectSubProduct(
      {Key? key,
      required this.subProductList,
      required this.defaultCode,
      required this.orderLineId,
      required this.orderLineIsReceive})
      : super(key: key);

  @override
  State<DialogSelectSubProduct> createState() => _DialogSelectSubProductState();
}

class _DialogSelectSubProductState extends State<DialogSelectSubProduct> {
  MyGetxController myGetxController = Get.find();
  bool isChecked = false;

  @override
  void initState() {
    if (myGetxController.receiveSelectedOrderLineList
            .contains(widget.orderLineId) ==
        true) {
      setState(() {
        isChecked = true;
      });
    }
    setDefaultCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.orderLineIsReceive == "true"
                  ? Container()
                  : Column(
                      children: [
                        Text(
                          "MainProduct",
                          style: TextStyle(
                              color: primary2Color,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              activeColor: primary2Color,
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value ?? false;
                                });
                              },
                            ),
                            FittedBox(
                              child: Text(
                                widget.defaultCode.toString(),
                                style: primaryStyle,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
              widget.subProductList.isNotEmpty
                  ? Column(
                      children: [
                        Text(
                          "SubProduct",
                          style: TextStyle(
                              color: primary2Color,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                        GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, mainAxisExtent: 40),
                            shrinkWrap: true,
                            cacheExtent: 35,
                            itemCount: widget.subProductList.length,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Checkbox(
                                    activeColor: primary2Color,
                                    value: widget.subProductList[index]
                                        ['isChecked'],
                                    onChanged: (value) {
                                      setState(() {
                                        widget.subProductList[index]
                                            ['isChecked'] = value ?? false;
                                      });
                                    },
                                  ),
                                  FittedBox(
                                    child: Text(
                                      widget.subProductList[index]
                                          ['default_code'],
                                      style: primaryStyle,
                                    ),
                                  )
                                ],
                              );
                            }),
                      ],
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green.shade300),
                      onPressed: () {
                        addSubProductInSelectedReceiveList();
                        Navigator.pop(context);
                      },
                      child: Text("Receive")),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red.shade300),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"))
                ],
              )
            ],
          ),
        ));
  }

  void addSubProductInSelectedReceiveList() {
    if (widget.orderLineIsReceive == "null") {
      addMainProductInList();
    }
    widget.subProductList.forEach((element) {
      if (element['isChecked'] == true) {
        if (myGetxController.receiveSelectedSubProductList
                .contains(element['id']) ==
            false) {
          myGetxController.receiveSelectedSubProductList.add(element['id']);
        }
      } else {
        if (myGetxController.receiveSelectedSubProductList
                .contains(element['id']) ==
            true) {
          myGetxController.receiveSelectedSubProductList.remove(element['id']);
        }
      }
    });
  }

  addMainProductInList() {
    if (isChecked == true) {
      if (myGetxController.receiveSelectedOrderLineList
              .contains(widget.orderLineId) ==
          false) {
        myGetxController.receiveSelectedOrderLineList.add(widget.orderLineId);
      }
    } else {
      if (myGetxController.receiveSelectedOrderLineList
              .contains(widget.orderLineId) ==
          true) {
        myGetxController.receiveSelectedOrderLineList
            .remove(widget.orderLineId);
      }
    }
  }

  Future<void> setDefaultCheck() async {
    widget.subProductList.forEach((element) {
      if (myGetxController.receiveSelectedSubProductList
              .contains(element['id']) ==
          true) {
        setState(() {
          element['isChecked'] = true;
        });
      }
    });
  }
}
