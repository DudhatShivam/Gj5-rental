import 'package:flutter/material.dart';

class DEMMO extends StatefulWidget {
  const DEMMO({Key? key}) : super(key: key);

  @override
  State<DEMMO> createState() => _DEMMOState();
}

class _DEMMOState extends State<DEMMO> {
  String storeId = "6319b51282bd537fa7749967";
  int? id;
  List data = [
    {"_id": "6319b51282bd537fa7749967", "name": "pinku"},
    {"_id": "6319b50382bd537fa7749964", "name": "avani"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  @override
  void initState() {
    getData();
  }

  void getData() {
    for (int i = 0; i < data.length; i++) {
      if (data[i]['_id'] != storeId) {
        id = i;
      }
    }
    print(id);
  }
}
