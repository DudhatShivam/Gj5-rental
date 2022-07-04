import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:gj5_rental/Utils/utils.dart';

class ChangeProduct extends StatefulWidget {
  const ChangeProduct({Key? key}) : super(key: key);

  @override
  State<ChangeProduct> createState() => _ChangeProductState();
}

class _ChangeProductState extends State<ChangeProduct> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text(
            "coming soon",
          ),
        ),
      ),
    );
  }
}
