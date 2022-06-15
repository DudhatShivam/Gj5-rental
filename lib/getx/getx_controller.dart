import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/utils.dart';

class MyGetxController extends GetxController {
  RxString pName = "".obs;
  RxString branchName = "".obs;
  RxString logInPageError = "".obs;
  RxBool isLoggedIn=false.obs;
  RxBool isSetTextFieldData = false.obs;

  //orderScreen
  RxList<dynamic> orderData = [].obs;
  RxList<dynamic> orderLineList=[].obs;
  RxList<dynamic> particularOrderData=[].obs;
  RxList<dynamic> orderLineProductList=[].obs;
  RxString waitingThumbPopUpSelectedValue="Return".obs;
  RxBool isShowReadyIcon=false.obs;
  RxBool isShowWaitingIcon=false.obs;
  //

  RxList<dynamic> quotationData = [].obs;
  RxInt badgeText = 0.obs;
  RxList<dynamic> quotationCartList = [].obs;
  RxList<dynamic> quotationOrder = [].obs;
  RxList<dynamic> quotationDetailOrderList = [].obs;
  RxList<dynamic> quotationDetailProductDetailList = [].obs;
  RxBool isUpdateData=false.obs;

  //mainProductScreen
  RxList<dynamic> mainProductList = [].obs;
  RxList<dynamic> mainProductDetailList = [].obs;

  //delivery screen
  RxList<dynamic> deliveryScreenProductList = [].obs;

}

