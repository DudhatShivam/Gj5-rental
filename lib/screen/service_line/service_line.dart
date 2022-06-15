import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceLineScreen extends StatefulWidget {
  const ServiceLineScreen({Key? key}) : super(key: key);

  @override
  State<ServiceLineScreen> createState() => _ServiceLineScreenState();
}

class _ServiceLineScreenState extends State<ServiceLineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Service Line Screen"),
      ),
    );
  }
}
