import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/screen/quatation/quatation.dart';
import 'package:gj5_rental/screen/quatation/quotation_const/quotation_constant.dart';
import 'package:gj5_rental/screen/quatation/quotation_detail_add_product.dart';
import 'package:gj5_rental/screen/service/servicecontroller.dart';
import 'package:intl/intl.dart';

import '../../Utils/utils.dart';
import '../../constant/constant.dart';
import '../../constant/extraproduct_card.dart';
import '../../constant/order_quotation_amount_card.dart';
import '../../constant/order_quotation_comman_card.dart';
import '../../constant/order_quotation_detail_card.dart';
import '../service/add_service/add_service.dart';
import '../service/service_add_product/service_add_product.dart';
import 'add_extra_product/quotation_add_extra_product.dart';
import 'create_order.dart';

class QuatationDetailScreen extends StatefulWidget {
  final int? id;
  final bool isFromAnotherScreen;

  const QuatationDetailScreen({
    Key? key,
    this.id,
    required this.isFromAnotherScreen,
  }) : super(key: key);

  @override
  State<QuatationDetailScreen> createState() => _QuatationDetailScreenState();
}

class _QuatationDetailScreenState extends State<QuatationDetailScreen> {
  MyGetxController myGetxController = Get.find();

  @override
  void initState() {
    super.initState();
    if (widget.isFromAnotherScreen == true) {
      isFromAnotherScreen = true;
    }
    checkQuotationAndOrderDetailData(context, widget.id ?? 0, false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPopNavigateFunction(),
      child: Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomFABWidget(
                transitionType: ContainerTransitionType.fade,
                isQuotationDetailAddExtraProduct: true),
            SizedBox(
              height: 5,
            ),
            CustomFABWidget(
                transitionType: ContainerTransitionType.fade,
                isQuotationDetailAddProduct: true),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            allScreenInitialSizedBox(context),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () {
                      onWillPopNavigateFunction();
                    },
                    child: FadeInLeft(child: backArrowIcon)),
                SizedBox(
                  width: 10,
                ),
                FadeInLeft(
                  child: Text(
                    "Order Detail",
                    style: pageTitleTextStyle,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Obx(
              () => myGetxController.quotationOrder.isNotEmpty
                  ? OrderQuatationCommanCard(
                      list: myGetxController.quotationOrder,
                      isOrderScreen: false,
                      backGroundColor: Colors.grey.withOpacity(0.1),
                      index: 0,
                      isDeliveryScreen: false)
                  : Container(),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Product Details : ",
                style: pageTitleTextStyle,
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Obx(() => Column(
                    children: [
                      myGetxController.quotationDetailOrderList.isNotEmpty
                          ? ListView.builder(
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: myGetxController
                                  .quotationDetailOrderList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return OrderQuotationDetailCard(
                                  orderDetailsList:
                                      myGetxController.quotationDetailOrderList,
                                  index: index,
                                  productDetail: myGetxController
                                      .quotationDetailProductDetailList,
                                  isOrderScreen: false,
                                  orderId: widget.id ?? 0,
                                  isDeliveryScreen: false,
                                  isReceiveScreen: false,
                                  isFromBookingOrderScreen:
                                      widget.isFromAnotherScreen,
                                );
                              })
                          : Container(),
                      myGetxController.quotationExtraProductList.isNotEmpty
                          ? Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Extra Product : ",
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 21),
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                      padding: EdgeInsets.only(bottom: 15),
                                      itemCount: myGetxController
                                          .quotationExtraProductList.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return ExtraProductCard(
                                          extraProductList: myGetxController
                                              .quotationExtraProductList,
                                          index: index,
                                        );
                                      }),
                                ],
                              ),
                            )
                          : Container(),
                      myGetxController.quotationOrder.isNotEmpty
                          ? OrderQuotationAmountCard(
                              list: myGetxController.quotationOrder)
                          : Container(),
                      SizedBox(
                        height: 15,
                      )
                    ],
                  )),
            )),
          ],
        ),
      ),
    );
  }

  onWillPopNavigateFunction() {
    widget.isFromAnotherScreen == false && isFromAnotherScreen == false
        ? Navigator.of(context).popUntil(ModalRoute.withName("/QuotationHome"))
        : myGetxController.quotationData.isEmpty &&
                myGetxController.filteredQuotationData.isEmpty
            ? navvvv()
            : Navigate();
  }

  navvvv() {
    print("navvvv");
    pushRemoveUntilMethod(context, QuatationScreen());
  }

  Navigate() {
    print("this navigate called");
    if (editQuotationCount == 0) {
      print("this navigate called if");
      Navigator.pop(context);
    } else {
      print("this navigate called else");
      for (int i = 1;
          i <= editQuotationCount * 3 - (editQuotationCount - 1);
          i++) {
        Navigator.pop(context);
      }
    }
  }
}

class CustomFABWidget extends StatelessWidget {
  final ContainerTransitionType? transitionType;
  final bool? isCreateOrder;
  final bool? isQuotationDetailAddProduct;
  final bool? isAddService;
  final bool? isAddProductInService;
  final bool? isQuotationDetailAddExtraProduct;

  CustomFABWidget({
    Key? key,
    @required this.transitionType,
    this.isCreateOrder,
    this.isQuotationDetailAddProduct,
    this.isAddService,
    this.isAddProductInService,
    this.isQuotationDetailAddExtraProduct,
  }) : super(key: key);
  MyGetxController myGetxController = Get.find();
  ServiceController serviceController = Get.put(ServiceController());
  double fabSize = 56;

  @override
  Widget build(BuildContext context) => OpenContainer(
        transitionDuration: Duration(milliseconds: 800),
        openBuilder: (context, _) => isCreateOrder == true
            ? CreateOrder()
            : isQuotationDetailAddProduct == true
                ? QuotationDetailAddProduct(
                    deliveryDate: DateFormat("dd/MM/yyyy").format(
                        DateTime.parse(myGetxController.quotationOrder[0]
                            ['delivery_date'])),
                    returnDate: DateFormat("dd/MM/yyyy").format(DateTime.parse(
                        myGetxController.quotationOrder[0]['return_date'])),
                    orderId: myGetxController.quotationOrder[0]['id'],
                  )
                : isAddService == true
                    ? AddServiceScreen()
                    : isAddProductInService == true
                        ? ServiceAddProduct(
                            serviceId: serviceController
                                .particularServiceList[0]['id'],
                            serviceType: serviceController
                                .particularServiceList[0]['service_type'])
                        : QuotationAddExtraProduct(),
        closedShape: CircleBorder(),
        closedColor: primary2Color,
        closedBuilder: (context, openContainer) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primary2Color,
          ),
          height: fabSize,
          width: fabSize,
          alignment: Alignment.center,
          child: isQuotationDetailAddExtraProduct == true
              ? Text(
                  "EX",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      letterSpacing: 2),
                )
              : Icon(Icons.add, color: Colors.white, size: 30),
        ),
      );
}
