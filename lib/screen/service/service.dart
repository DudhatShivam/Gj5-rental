import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Utils/utils.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Text(
          "Coming Soon",
          style: primaryStyle,
        ),
      ),
    );
  }
}
