import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Utils/utils.dart';

class ServiceStatusScreen extends StatefulWidget {
  const ServiceStatusScreen({Key? key}) : super(key: key);

  @override
  State<ServiceStatusScreen> createState() => _ServiceStatusScreenState();
}

class _ServiceStatusScreenState extends State<ServiceStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Coming Soon",
          style: primaryStyle,
        ),
      ),
    );
  }
}
