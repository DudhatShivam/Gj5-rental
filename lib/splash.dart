import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gj5_rental/login/login_page.dart';

import 'Utils/utils.dart';
import 'home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;
  int seconds = 60;

  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () {
      getLogIn().then((value) {
        if (value == true) {
          pushRemoveUntilMethod(context, HomeScreen());
        } else {
          pushMethod(context, LogInPage());
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              Image.asset(
                "assets/images/gj5_logo.png",
                height: 250,
                width: 250,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Text(
                "Welcome to GJ-5 ",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                    letterSpacing: 2,
                    color: Color(0xff9A2929)),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: Color(0xff9A2929),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
