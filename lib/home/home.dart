import 'dart:io';
import 'dart:typed_data';
import 'package:animated_background/animated_background.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:gj5_rental/constant/constant.dart';
import 'package:gj5_rental/getx/getx_controller.dart';
import 'package:gj5_rental/login/login_page.dart';
import 'package:gj5_rental/screen/delivery/delivery.dart';
import 'package:gj5_rental/screen/extra_product/extra_product.dart';
import 'package:gj5_rental/screen/main_product/main_product.dart';
import 'package:gj5_rental/screen/order/order.dart';
import 'package:gj5_rental/screen/product_detail/product_detail.dart';
import 'package:gj5_rental/screen/quatation/quatation.dart';
import 'package:gj5_rental/screen/service/service.dart';
import 'package:gj5_rental/screen/service/servicecontroller.dart';
import 'package:gj5_rental/screen/service_line/service_line.dart';
import 'package:gj5_rental/screen/service_status/service_status.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'dart:io' as Io;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../drawer_pages/about_us.dart';
import '../drawer_pages/change_theme_screen.dart';
import '../drawer_pages/contact_us.dart';
import '../drawer_pages/notification.dart';
import '../screen/Order_line/order_line.dart';
import '../screen/booking status/booking_status.dart';
import '../screen/cancel_order/cancel_order.dart';
import '../screen/cash_book/cash_book.dart';
import '../screen/receive/receive.dart';
import 'home_model.dart';

class HomeScreen extends StatefulWidget {
  final int userId;

  HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late FancyDrawerController _controller;
  String? themeName;

  @override
  void initState() {
    super.initState();
    if (widget.userId != 0) {
      checkWlanForSetAccessToken();
    }
    getSavedTheme();
    setAccessRight();
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

  List<HomeModel> menuList = [
    HomeModel(
        menuName: "Booking Status",
        menuIcon: "assets/images/home_icon/searching.png"),
    HomeModel(
        menuName: "Quotation",
        menuIcon: "assets/images/home_icon/quotation.png"),
    HomeModel(menuName: "Order", menuIcon: "assets/images/home_icon/order.png"),
    HomeModel(
        menuName: "Order Line",
        menuIcon: "assets/images/home_icon/order_line.png"),
    HomeModel(
        menuName: "Cancel Order",
        menuIcon: "assets/images/home_icon/cancel_order.png"),
    HomeModel(
        menuName: "Product", menuIcon: "assets/images/home_icon/product.png"),
    HomeModel(
        menuName: "Product Detail",
        menuIcon: "assets/images/home_icon/product_detail.png"),
    HomeModel(
        menuName: "Extra Product",
        menuIcon: "assets/images/home_icon/extra_product.png"),
    HomeModel(
        menuName: "Service Status",
        menuIcon: "assets/images/home_icon/searching.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () => ExitDialog(context),
        child: GestureDetector(
          onTap: () {
            _controller.close();
          },
          child: FancyDrawerWrapper(
            backgroundColor: mainColor1.withOpacity(0.1),
            controller: _controller,
            drawerItems: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _bytesImage != null && _bytesImage?.isNotEmpty == true
                        ? CircleAvatar(
                            radius: 40,
                            child: ClipRRect(
                              child: Image.memory(
                                _bytesImage!,
                                fit: BoxFit.cover,
                                width: getWidth(0.25, context),
                                height: getWidth(0.25, context),
                              ),
                              borderRadius: BorderRadius.circular(50.0),
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
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    drawerText("Home"),
                    customDrawerDivider(),
                    InkWell(
                        onTap: () {
                          _controller.close();
                          pushMethod(context, ShowNotification());
                        },
                        child: drawerText("My Notification")),
                    customDrawerDivider(),
                    InkWell(
                        onTap: () {
                          _controller.close();
                          pushMethod(context, ContactUsPage());
                        },
                        child: drawerText("Contact Us")),
                    customDrawerDivider(),
                    InkWell(
                        onTap: () {
                          _controller.close();
                          pushMethod(context, AboutUsPage());
                        },
                        child: drawerText("About Us")),
                    customDrawerDivider(),
                    InkWell(
                      onTap: () {
                        _controller.close();
                        chekWlanForNewSyncData();
                      },
                      child: drawerText("Sync Product"),
                    ),
                    customDrawerDivider(),
                    InkWell(
                        onTap: () {
                          _controller.close();
                          pushMethod(context, ChangeThemeScreen());
                        },
                        child: drawerText("Change Theme")),
                    customDrawerDivider(),
                    InkWell(
                      onTap: () {
                        setLogIn(false);
                        removePreference();
                        pushRemoveUntilMethod(context, LogInPage());
                        myGetxController.logInPageError.value = "";
                        Get.deleteAll();
                      },
                      child: drawerText("Log out"),
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
                child: Obx(() => myGetxController.isSyncData.value == false
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).padding.top + 10,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: primary2Color,
                              size: 35,
                            ),
                            onPressed: () {
                              _controller.toggle();
                            },
                          ),
                          GridView.builder(
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              shrinkWrap: true,
                              itemCount: menuList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisExtent: getHeight(0.15, context),
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 10),
                              itemBuilder: (context, index) {
                                HomeModel homeModel = menuList[index];
                                return InkWell(
                                  onTap: () {
                                    onCardTap(index, homeModel);
                                  },
                                  child: themeName == "background_theme"
                                      ? Card(
                                          elevation: 0,
                                          child: Container(
                                            decoration:
                                                cardContainerDecoration(),
                                            child: TweenAnimationBuilder(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  menuImage(homeModel),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  menuText(homeModel),
                                                ],
                                              ),
                                              duration: Duration(seconds: 1),
                                              tween: Tween<double>(
                                                  begin: 0, end: 1),
                                              builder: (BuildContext context,
                                                  double _val, Widget? child) {
                                                return Opacity(
                                                  opacity: _val,
                                                  child: child,
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      : themeName == "animated_theme"
                                          ? Stack(
                                              alignment: Alignment.topCenter,
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      top: 27.5),
                                                  width:
                                                      getWidth(0.29, context),
                                                  height: 90,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Color(0xffF6E5E6),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 28,
                                                            left: 5,
                                                            right: 5),
                                                    child: Text(
                                                      homeModel.menuName,
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff1D2F59),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 17.2,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 55,
                                                  width: 55,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset:
                                                                Offset(0, 12),
                                                            blurRadius: 12,
                                                            spreadRadius: 1,
                                                            color: Color(
                                                                0xffFAC5C8)),
                                                        BoxShadow(
                                                            offset:
                                                                Offset(0, -8),
                                                            blurRadius: 5,
                                                            spreadRadius: 0,
                                                            color:
                                                                Colors.white),
                                                      ]),
                                                  child: Image.asset(
                                                    homeModel.menuIcon,
                                                    fit: BoxFit.cover,
                                                    height: 35,
                                                    width: 35,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : themeName == "no_background_theme"
                                              ? TweenAnimationBuilder(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      menuImage(homeModel),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      menuText(homeModel)
                                                    ],
                                                  ),
                                                  duration:
                                                      Duration(seconds: 1),
                                                  tween: Tween<double>(
                                                      begin: 0, end: 1),
                                                  builder:
                                                      (BuildContext context,
                                                          double _val,
                                                          Widget? child) {
                                                    return Opacity(
                                                      opacity: _val,
                                                      child: child,
                                                    );
                                                  },
                                                )
                                              : Card(
                                                  elevation: 0,
                                                  child: Container(
                                                    decoration:
                                                        cardContainerDecoration(),
                                                    child:
                                                        TweenAnimationBuilder(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          index == 0 ||
                                                                  index == 8
                                                              ? Icon(
                                                                  Icons.search,
                                                                  color:
                                                                      primary2Color,
                                                                  size: 50,
                                                                )
                                                              : Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 5.1),
                                                                  child:
                                                                      FittedBox(
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/gj5_logo.png',
                                                                      height:
                                                                          50,
                                                                      width: 50,
                                                                    ),
                                                                  ),
                                                                ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          menuText(homeModel)
                                                        ],
                                                      ),
                                                      duration:
                                                          Duration(seconds: 1),
                                                      tween: Tween<double>(
                                                          begin: 0, end: 1),
                                                      builder:
                                                          (BuildContext context,
                                                              double _val,
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
                      )
                    : CenterCircularProgressIndicator()),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getSyncData(String accessToken, bool isSetNewSyncData) async {
    if (isSetNewSyncData == false) {
      getStringPreference('ProductList').then((value) {
        if (value == null) {
          setSyncData(accessToken, isSetNewSyncData);
        }
      });
    } else {
      setSyncData(accessToken, isSetNewSyncData);
    }
  }

  setSyncData(String accessToken, bool isSetNewSyncData) {
    getStringPreference('apiUrl').then((value) async {
      String domain = "[('product_type', '=', 'rental')]";
      var params = {'filters': domain.toString()};
      Uri uri = Uri.parse("http://$value/api/product.product");
      final finalUri = uri.replace(queryParameters: params);
      final response =
          await http.get(finalUri, headers: {'Access-Token': accessToken});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        saveProductListInPreferece(data, isSetNewSyncData);
      } else {
        myGetxController.isSyncData.value = false;
        dialog(context, "Error in Sync Product", Colors.red.shade300);
      }
    });
  }

  Future<void> saveProductListInPreferece(data, bool isSetNewSyncData) async {
    ServiceController serviceController = Get.put(ServiceController());
    myGetxController.isMainProductTrueProductList.clear();
    myGetxController.isMainProductFalseProductList.clear();
    serviceController.serviceIsMainProductTrueList.clear();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('ProductList', jsonEncode(data)).whenComplete(() {
      if (isSetNewSyncData == true) {
        myGetxController.isSyncData.value = false;
        dialog(context, "Product Sync SuccessFully", Colors.green.shade300);
      }
    });
  }

  void getData() {
    getStringPreference('branchName').then((value) {
      myGetxController.branchName.value = value;
    });
    getStringPreference('accessToken').then((value) {
      getSyncData(value, false);
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
        // height: 25,
        thickness: 2,
      ),
    );
  }

  void checkForBioMatrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool isDeviceSupport = await auth.canCheckBiometrics;
    bool isAvailableBioMetrics = await auth.isDeviceSupported();
    if (isAvailableBioMetrics && isDeviceSupport) {
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

  Future<void> setNewSyncData() async {
    myGetxController.isSyncData.value = true;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('ProductList');
    getStringPreference('accessToken').then((token) {
      getSyncData(token, true);
    });
  }

  chekWlanForNewSyncData() {
    getStringPreference('apiUrl').then((value) async {
      try {
        if (value.toString().startsWith("192")) {
          showConnectivity().then((result) async {
            if (result == ConnectivityResult.wifi) {
              setNewSyncData();
            } else {
              dialog(
                  context, "Connect to Showroom Network", Colors.red.shade300);
            }
          });
        } else {
          setNewSyncData();
        }
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  Future<void> setAccessRight() async {
    bool ARService = await getBoolPreference('ARService');
    bool ARReceive = await getBoolPreference('ARReceive');
    bool ARDeliver = await getBoolPreference('ARDeliver');
    bool ARManager = await getBoolPreference('ARManager');
    bool ARCashbook = await getBoolPreference('ARCashbook');
    if (ARManager == true) {
      addServiceInMenuList();
      addItemInMenuList("Receive", "receive.png");
      addItemInMenuList("Delivery", "delivery.png");
      addItemInMenuList("Cash Book", "cash_book.png");
    } else {
      if (ARService == true) {
        addServiceInMenuList();
      }
      if (ARDeliver == true) {
        addItemInMenuList("Delivery", "delivery.png");
      }
      if (ARReceive == true) {
        addItemInMenuList("Receive", "receive.png");
      }
      if (ARCashbook == true) {
        addItemInMenuList("Cash Book", "cash_book.png");
      }
    }
  }

  NavigateToScreen(String screen) {
    if (screen == "Service") {
      Navigator.of(context).push(MaterialPageRoute(
          settings: RouteSettings(name: "/ServiceHome"),
          builder: (context) => ServiceScreen()));
    } else if (screen == "Service Line") {
      pushMethod(context, ServiceLineScreen());
    } else if (screen == "Delivery") {
      pushMethod(context, DeliveryScreen());
    } else if (screen == "Receive") {
      pushMethod(context, ReceiveScreen());
    } else if (screen == "Cash Book") {
      pushMethod(context, CashBookScreen());
    }
  }

  void checkWlanForSetAccessToken() {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                setDeviceToken(apiUrl, token);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            setDeviceToken(apiUrl, token);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  Future<void> setDeviceToken(apiUrl, token) async {
    int uid = widget.userId;
    final _firebaseMessaging = await FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((deviceToken) async {
      await http.put(
        Uri.parse(
            "http://$apiUrl/api/res.partner/$uid?device_token=$deviceToken"),
        headers: {'Access-Token': token},
      );
    });
  }

  void addServiceInMenuList() {
    addItemInMenuList("Service", "service.png");
    addItemInMenuList("Service Line", "service_line.png");
  }

  void onCardTap(int index, HomeModel homeModel) {
    _controller.close();
    if (index == 0) {
      pushMethod(context, BookingStatus());
    } else if (index == 1) {
      isFromAnotherScreen = false;
      Navigator.of(context).push(MaterialPageRoute(
          settings: RouteSettings(name: "/QuotationHome"),
          builder: (context) => QuatationScreen()));
    } else if (index == 2) {
      pushMethod(context, OrderScreen());
    } else if (index == 3) {
      pushMethod(context, OrderLineScreen());
    } else if (index == 4) {
      pushMethod(context, CancelOrderScreen());
    } else if (index == 5) {
      pushMethod(context, MainProductScreen());
    } else if (index == 6) {
      pushMethod(context, ProductDetail());
    } else if (index == 7) {
      pushMethod(context, ExtraProduct());
    } else if (index == 8) {
      pushMethod(context, ServiceStatusScreen());
    } else {
      NavigateToScreen(homeModel.menuName);
    }
  }

  Future<void> getSavedTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? theme = sharedPreferences.getString("theme");
    if (theme == "background_theme") {
      themeName = theme;
    } else if (theme == "animated_theme") {
      themeName = theme;
    } else if (theme == "no_background_theme") {
      themeName = theme;
    } else {
      themeName = "default_theme";
    }
    setState(() {});
  }

  menuImage(HomeModel homeModel) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: FittedBox(
        child: Image.asset(
          homeModel.menuIcon,
          height: 50,
          width: 50,
        ),
      ),
    );
  }

  menuText(HomeModel homeModel) {
    return AutoSizeText(
      homeModel.menuName,
      textAlign: TextAlign.center,
      maxLines: 1,
      style: TextStyle(
        color: primary2Color,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  BoxDecoration cardContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Color(0xffE6ECF2), width: 0.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black12.withOpacity(0.1),
          spreadRadius: 0.3,
          blurRadius: 2,
          offset: Offset(3, 3),
          // changes position of shadow
        ),
      ],
    );
  }

  drawerText(String text) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.55,
        child: Text(text, style: drawerTextStyle));
  }

  void addItemInMenuList(String menuName, String menuImage) {
    menuList.add(
      HomeModel(
          menuName: "$menuName",
          menuIcon: "assets/images/home_icon/${menuImage}"),
    );
  }
}
