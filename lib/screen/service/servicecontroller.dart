import 'package:get/get.dart';

class ServiceController extends GetxController {
  RxList<dynamic> serviceList = [].obs;
  RxList<dynamic> serviceFilteredList = [].obs;
  RxBool isShowServiceFilteredList = false.obs;
  RxBool noDataInServiceScreen = false.obs;
  RxList<dynamic> particularServiceList = [].obs;
  RxList<dynamic> serviceLineList = [].obs;
  RxList<dynamic> serviceLineAddProductList = [].obs;
  RxList<dynamic> serviceIsMainProductTrueList = [].obs;
  RxList<dynamic> serviceStatusList = [].obs;
}
