import 'dart:typed_data';
import 'package:animated_background/animated_background.dart';
import 'package:dio/dio.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:gj5_rental/constant/constant.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/login/login_page.dart';
import 'package:gj5_rental/screen/change_product/change_product.dart';
import 'package:gj5_rental/screen/delivery/delivery.dart';
import 'package:gj5_rental/screen/extra_product/extra_product.dart';
import 'package:gj5_rental/screen/main_product/main_product.dart';
import 'package:gj5_rental/screen/order/order.dart';
import 'package:gj5_rental/screen/product_detail/product_detail.dart';
import 'package:gj5_rental/screen/quatation/quatation.dart';
import 'package:gj5_rental/screen/service/service.dart';
import 'package:gj5_rental/screen/service_line/service_line.dart';
import 'package:gj5_rental/screen/service_status/service_status.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:io' as Io;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../screen/Order_line/order_line.dart';
import '../screen/booking status/booking_status.dart';
import '../screen/receive/receive.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late FancyDrawerController _controller;

  @override
  void initState() {
    super.initState();
    getData();
    _controller = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  MyGetxController myGetxController = Get.put(MyGetxController());
  Uint8List? _bytesImage;

  List<String> serviceName = [
    'Booking Status',
    'Quotation',
    'Order',
    'Order Line',
    'Product Detail',
    'Extra Product',
    'Service',
    'Service Line',
    'Service Status',
    'Change Product',
    'Delivery',
    'Receive',
    'Product'
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () => ExitDialog(context),
        child: FancyDrawerWrapper(
          backgroundColor: Colors.white,
          controller: _controller,
          drawerItems: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _bytesImage != null && _bytesImage?.isNotEmpty == true
                      ? CircleAvatar(
                          radius: 40,
                          child: Image.memory(
                            _bytesImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue,
                        ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Obx(
                    () => Text(myGetxController.pName.value.toString(),
                        style: drawerTextStyle),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Obx(
                    () => Text(myGetxController.branchName.value.toString(),
                        style: drawerTextStyle),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.10,
                  ),
                  InkWell(
                    onTap: () {
                      _controller.close();
                    },
                    child: Text("Home", style: drawerTextStyle),
                  ),
                  customDrawerDivider(),
                  Text("My Notification", style: drawerTextStyle),
                  customDrawerDivider(),
                  Text("Change Password", style: drawerTextStyle),
                  customDrawerDivider(),
                  Text("Contact Us", style: drawerTextStyle),
                  customDrawerDivider(),
                  Text("About Us", style: drawerTextStyle),
                  customDrawerDivider(),
                  InkWell(
                    onTap: () {
                      _controller.close();
                      // getSyncData();
                    },
                    child: Text("Sync Product", style: drawerTextStyle),
                  ),
                  customDrawerDivider(),
                  InkWell(
                    onTap: () {
                      setLogIn(false);
                      removePreference();
                      pushRemoveUntilMethod(context, LogInPage());
                      myGetxController.logInPageError.value = "";
                    },
                    child: Text("Log out", style: drawerTextStyle),
                  ),
                ],
              ),
            )
          ],
          child: Scaffold(
            body: AnimatedBackground(
              vsync: this,
              behaviour: RandomParticleBehaviour(
                  options: ParticleOptions(
                      image: Image.asset('assets/images/gj5_logo.png'),
                      spawnMaxRadius: 15,
                      spawnMinRadius: 10,
                      spawnMaxSpeed: 20.0,
                      spawnMinSpeed: 10.0,
                      particleCount: 50)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + 10,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.black,
                      size: 35,
                    ),
                    onPressed: () {
                      _controller.toggle();
                    },
                  ),
                  GridView.builder(
                      physics: BouncingScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      shrinkWrap: true,
                      itemCount: serviceName.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisExtent: getHeight(0.15, context),
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 10),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (index == 0) {
                              pushMethod(context, BookingStatus());
                            } else if (index == 1) {
                              pushMethod(context, QuatationScreen());
                            } else if (index == 2) {
                              pushMethod(context, OrderScreen());
                            } else if (index == 3) {
                              pushMethod(context, OrderLineScreen());
                            } else if (index == 4) {
                              pushMethod(context, ProductDetail());
                            } else if (index == 5) {
                              pushMethod(context, ExtraProduct());
                            } else if (index == 6) {
                              pushMethod(context, ServiceScreen());
                            } else if (index == 7) {
                              pushMethod(context, ServiceLineScreen());
                            } else if (index == 8) {
                              pushMethod(context, ServiceStatusScreen());
                            } else if (index == 9) {
                              pushMethod(context, ChangeProduct());
                            } else if (index == 10) {
                              pushMethod(context, DeliveryScreen());
                            } else if (index == 11) {
                              pushMethod(context, ReceiveScreen());
                            } else if (index == 12) {
                              pushMethod(context, MainProductScreen());
                            }
                          },
                          child: Card(
                            elevation: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Color(0xffE6ECF2), width: 0.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12.withOpacity(0.1),
                                    spreadRadius: 0.3,
                                    blurRadius: 2,
                                    offset: Offset(3, 3),
                                    // changes position of shadow
                                  ),
                                ],
                              ),
                              child: TweenAnimationBuilder(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    index == 0
                                        ? Icon(
                                            Icons.search,
                                            color: Colors.red,
                                            size: 50,
                                          )
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Image.asset(
                                              'assets/images/gj5_logo.png',
                                              height: 50,
                                              width: 50,
                                            ),
                                          ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      serviceName[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                                duration: Duration(seconds: 1),
                                tween: Tween<double>(begin: 0, end: 1),
                                builder: (BuildContext context, double _val,
                                    Widget? child) {
                                  return Opacity(
                                    opacity: _val,
                                    child: child,
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getSyncData(String accessToken) async {
    getStringPreference('apiUrl').then((value) async {
      String domain =
          "[('product_type', '=', 'rental'), ('is_main_product', '=',  True)]";
      var params = {'filters': domain.toString()};
      Uri uri = Uri.parse("http://$value/api/product.product");
      final finalUri = uri.replace(queryParameters: params);
      final response =
          await http.get(finalUri, headers: {'Access-Token': accessToken});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        saveProductListInPreferece(data);
      }
    });
  }

  Future<void> saveProductListInPreferece(data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('ProductList', jsonEncode(data)).whenComplete(() {
      print("ProductList data set");
    });
  }

  void getData() {
    getStringPreference('branchName').then((value) {
      myGetxController.branchName.value = value;
    });
    getStringPreference('accessToken').then((value) {
      getSyncData(value);
    });
    getStringPreference('name').then((value) {
      myGetxController.pName.value = value.toString();
    });
    getStringPreference('image').then((value) {
      Uint8List _bytesImages;
      String _imgString = value;
      _bytesImages = Base64Decoder().convert(_imgString);
      setState(() {
        _bytesImage = _bytesImages;
      });
    });
  }

  customDrawerDivider() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      child: Divider(
        color: Colors.grey.shade300.withOpacity(0.5),
        height: 25,
        thickness: 2,
      ),
    );
  }

  void checkForBioMatrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool isDeviceSupport = await auth.canCheckBiometrics;
    bool isAvailableBioMetrics = await auth.isDeviceSupported();
    if (isAvailableBioMetrics && isDeviceSupport) {
      print(await auth.getAvailableBiometrics());
      try {
        final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to Go Inside',
          options:
              AuthenticationOptions(useErrorDialogs: true, stickyAuth: true),
        );
        if (didAuthenticate) {
          pushMethod(context, ReceiveScreen());
        }
        // ···
      } on PlatformException catch (e) {
        pushMethod(context, ReceiveScreen());
      }
    } else {
      pushMethod(context, ReceiveScreen());
    }
  }

  _save() async {
    var response = await Dio().get(
        "https://pbs.twimg.com/profile_images/1479443900368519169/PgOyX1vt_400x400.jpg",
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "hello");
    print(result);
  }
}
