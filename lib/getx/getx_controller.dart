import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/utils.dart';

class MyGetxController extends GetxController {
  RxString pName = "".obs;
  RxString branchName = "".obs;
  RxString logInPageError = "".obs;
  RxBool isLoggedIn = false.obs;
  RxBool isSetTextFieldData = false.obs;

  //booking status screen

  RxList<dynamic> isMainProductTrueProductList = [].obs;

  //orderScreen
  RxList<dynamic> orderData = [].obs;
  RxList<dynamic> filteredOrderList=[].obs;
  RxList<dynamic> orderLineList = [].obs;
  RxList<dynamic> particularOrderData = [].obs;
  RxList<dynamic> orderLineProductList = [].obs;
  RxString waitingThumbPopUpSelectedValue = "Return".obs;
  RxBool isShowReadyIcon = false.obs;
  RxBool isShowWaitingIcon = false.obs;

  //QuotationScreen

  RxList<dynamic> quotationData = [].obs;
  RxList<dynamic> filteredQuotationData=[].obs;
  RxInt badgeText = 0.obs;
  RxList<dynamic> quotationCartList = [].obs;
  RxList<dynamic> quotationOrder = [].obs;
  RxList<dynamic> quotationDetailOrderList = [].obs;
  RxList<dynamic> quotationDetailProductDetailList = [].obs;
  RxList<dynamic> isMainProductFalseProductList = [].obs;
  RxBool isUpdateData = false.obs;

  //ProductScreen
  RxList<dynamic> mainProductList = [].obs;
  RxList<dynamic> mainProductDetailList = [].obs;

  //delivery screen
  RxList<dynamic> deliveryScreenOrderList = [].obs;
  RxList<dynamic> deliveryScreenParticularOrder = [].obs;
  RxList<dynamic> deliveryScreenParticularOrderLineList = [].obs;
  RxList<dynamic> deliveryScreenParticularOrderLineProductList = [].obs;
  RxList<dynamic> deliveryScreenParticularOrderLineExtraProductList = [].obs;
  RxList<dynamic> selectedOrderLineList = [].obs;

  //OrderLine Screen
  RxList<dynamic> orderLineScreenList = [].obs;
  RxList<dynamic> orderLineScreenProductList = [].obs;
  RxBool noDataInOrderLine = false.obs;
  RxList<dynamic> groupByList=[].obs;
  RxList<dynamic> groupByDetailList=[].obs;
  RxList<dynamic> filteredListOrderLine=[].obs;
  RxBool isShowFilteredDataInOrderLine=false.obs;

  //productDetail screen
  RxList<dynamic> productDetailList = [].obs;
}
