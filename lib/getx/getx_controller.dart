import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyGetxController extends GetxController {
  RxString pName = "".obs;
  RxString branchName = "".obs;
  RxString logInPageError = "".obs;
  RxBool isLoggedIn = false.obs;
  RxBool isSetTextFieldData = false.obs;
  RxBool isSyncData = false.obs;

  //About us
  RxList<dynamic> showRoomList = [].obs;

  //Notification screen
  RxList<dynamic> notificationList = [].obs;

  //booking status screen
  RxList<dynamic> isMainProductTrueProductList = [].obs;

  //orderScreen
  RxList<dynamic> orderData = [].obs;
  RxList<dynamic> filteredOrderList = [].obs;
  RxList<dynamic> orderLineList = [].obs;
  RxList<dynamic> particularOrderData = [].obs;
  RxList<dynamic> orderLineProductList = [].obs;
  RxString waitingThumbPopUpSelectedValue = "Return".obs;

  //QuotationScreen

  RxList<dynamic> quotationData = [].obs;
  RxList<dynamic> filteredQuotationData = [].obs;
  RxInt badgeText = 0.obs;
  RxList<dynamic> quotationCartList = [].obs;
  RxList<dynamic> quotationOrder = [].obs;
  RxList<dynamic> quotationDetailOrderList = [].obs;
  RxList<dynamic> quotationDetailProductDetailList = [].obs;
  RxList<dynamic> quotationExtraProductList = [].obs;
  RxList<dynamic> isMainProductFalseProductList = [].obs;
  RxBool isUpdateData = false.obs;
  RxBool isShowQuotationFilteredList = false.obs;
  RxBool noDataInQuotationScreen = false.obs;
  RxList<dynamic> quotationMainProductTypeList = [].obs;
  RxList<dynamic> quotationMainProductList = [].obs;
  RxList<dynamic> orginalProductList = [].obs;

  //editQuotationOrder
  RxList<dynamic> wholeSubProductList = [].obs;
  RxList<dynamic> subProductList = [].obs;
  RxList productControllers = [].obs;
  RxList remarkControllerList = [].obs;

  //ProductScreen
  RxList<dynamic> mainProductList = [].obs;
  RxList<dynamic> mainProductDetailList = [].obs;

  //delivery screen
  RxList<dynamic> deliveryScreenOrderList = [].obs;
  RxList<dynamic> deliveryScreenFilteredOrderList = [].obs;
  RxList<dynamic> deliveryScreenParticularOrder = [].obs;
  RxList<dynamic> deliveryScreenParticularOrderLineList = [].obs;
  RxList<dynamic> deliveryScreenParticularOrderLineProductList = [].obs;
  RxList<dynamic> deliveryScreenParticularOrderLineExtraProductList = [].obs;
  RxList<dynamic> selectedOrderLineList = [].obs;
  RxList<dynamic> selectedOrderLineSubProductList = [].obs;
  RxList<dynamic> deliverySelectedExtraProductList = [].obs;
  RxBool noDataInDeliveryScreen = false.obs;

  //OrderLine Screen
  RxList<dynamic> orderLineScreenList = [].obs;
  RxList<dynamic> orderLineScreenProductList = [].obs;
  RxBool noDataInOrderLine = false.obs;
  RxList<dynamic> groupByList = [].obs;
  RxList<dynamic> groupByDetailList = [].obs;
  RxList<dynamic> filteredListOrderLine = [].obs;
  RxBool isShowFilteredDataInOrderLine = false.obs;
  RxList<dynamic> orderLineFilteredTag = [].obs;

  //productDetail screen
  RxList<dynamic> productDetailList = [].obs;

  //ReceiveScreen
  RxList<dynamic> receiveOrderList = [].obs;
  RxList<dynamic> receiveFilteredOrderList = [].obs;
  RxList<dynamic> receiveParticularOrderList = [].obs;
  RxList<dynamic> receiveOrderLineList = [].obs;
  RxList<dynamic> receiveSubProductList = [].obs;
  RxList<dynamic> receiveExtraProductList = [].obs;
  RxList<dynamic> receiveSelectedOrderLineList = [].obs;
  RxList<dynamic> receiveSelectedSubProductList = [].obs;
  RxList<dynamic> receiveSelectedExtraProductList = [].obs;
  RxBool noDataInReceiveScreen = false.obs;

  //ServiceLineScreen
  RxList<dynamic> serviceLineScreenList = [].obs;
  RxList<dynamic> serviceLineFilteredList = [].obs;
  RxList<dynamic> serviceLineGroupByList = [].obs;
  RxBool serviceLineIsShowFilteredData = false.obs;
  RxBool serviceLineIsShowGroupByData = false.obs;
  RxBool serviceLineIsExpand = false.obs;
  RxBool noDataInServiceLineScreen = false.obs;

  //CancelOrderScreen
  RxList<dynamic> cancelOrderList = [].obs;
  RxList<dynamic> filteredCancelOrderList = [].obs;
  RxBool isShowCancelOrderScreenFilteredList = false.obs;
  RxBool noDataInCancelOrderScreen = false.obs;
  RxList<dynamic> cancelParticularOrderList = [].obs;
  RxList<dynamic> cancelParticularOrderLineList = [].obs;
  RxList<dynamic> cancelParticularOrderProductList = [].obs;

  //extra Product Screen
  RxList<dynamic> extraProductList = [].obs;
  RxList<dynamic> extraProductFilteredList = [].obs;
  RxBool noDataInExtraProductScreen = false.obs;

  //cash book screen
  RxList<dynamic> cashBookList = [].obs;
  RxList<dynamic> detailCashBookList = [].obs;
}
