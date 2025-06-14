import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gj5_rental/constant/constant.dart';
import 'package:gj5_rental/screen/booking%20status/booking_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/utils.dart';
import '../home/home.dart';

class ChangeThemeScreen extends StatefulWidget {
  const ChangeThemeScreen({Key? key}) : super(key: key);

  @override
  State<ChangeThemeScreen> createState() => _ChangeThemeScreenState();
}

class _ChangeThemeScreenState extends State<ChangeThemeScreen> {
  String imagePath = "assets/images/theme_image/";
  int curIndex = 0;

  @override
  void initState() {
    super.initState();
    setTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          allScreenInitialSizedBox(context),
          ScreenAppBar(screenName: "Change Theme"),
          GridView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shrinkWrap: true,
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: getHeight(0.4, context),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    themeChangingDialog(index);
                  },
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: primary2Color)),
                        height: getHeight(0.4, context),
                        width: getWidth(0.5, context),
                        child: Image.asset(
                          index == 0
                              ? "${imagePath}default_theme.jpeg"
                              : index == 1
                                  ? "${imagePath}background_theme.jpeg"
                                  : index == 2
                                      ? "${imagePath}animated_theme.jpeg"
                                      : "${imagePath}no_background_theme.jpeg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      curIndex == index
                          ? Container(
                              margin: EdgeInsets.only(top: 5, right: 5),
                              height: 25,
                              alignment: Alignment.center,
                              width: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.blue),
                              child: Icon(
                                Icons.check,
                                size: 20,
                                color: Colors.white,
                              ),
                            )
                          : Container()
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }

  void themeChangingDialog(int index) {
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Do you want to change theme ?",
                      style: allCardSubText,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                               backgroundColor: Colors.red.shade300),
                            onPressed: () {},
                            child: Text("Cancel")),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade300),
                              onPressed: () {
                                setState(() {
                                  curIndex = index;
                                });
                                setThemePref(index);
                              },
                              child: Text("Ok")),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> setThemePref(int index) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (index == 0) {
      sharedPreferences.setString("theme", "default_theme");
    } else if (index == 1) {
      sharedPreferences.setString("theme", "background_theme");
    } else if (index == 2) {
      sharedPreferences.setString("theme", "animated_theme");
    } else if (index == 3) {
      sharedPreferences.setString("theme", "no_background_theme");
    }
    Navigator.pop(context);
    pushMethod(context, HomeScreen(userId: 0));
  }

  Future<void> setTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? theme = sharedPreferences.getString("theme");
    if (theme == "background_theme") {
      curIndex = 1;
    } else if (theme == "animated_theme") {
      curIndex = 2;
    } else if (theme == "no_background_theme") {
      curIndex = 3;
    }
    setState(() {});
  }
}
