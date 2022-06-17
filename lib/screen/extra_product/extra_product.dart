import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:gj5_rental/Utils/utils.dart';

class ExtraProduct extends StatefulWidget {
  const ExtraProduct({Key? key}) : super(key: key);

  @override
  State<ExtraProduct> createState() => _ExtraProductState();
}

class _ExtraProductState extends State<ExtraProduct> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
        child:Text(
          "Coming Soon",
          style: primaryStyle,
        ),
      )),
    );
  }
}
