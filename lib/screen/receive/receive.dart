import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Utils/utils.dart';

class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({Key? key}) : super(key: key);

  @override
  State<ReceiveScreen> createState() => _RceiveScreenState();
}

class _RceiveScreenState extends State<ReceiveScreen> {

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

  @override
  void initState() {

  }
}
