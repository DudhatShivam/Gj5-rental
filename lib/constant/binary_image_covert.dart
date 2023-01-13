import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

import '../Utils/utils.dart';

convert_image(String image_data) {
  Uint8List _bytesImages;
  String _imgString = image_data;
  _bytesImages = Base64Decoder().convert(_imgString);
  return _bytesImages;
}

binary_image_container(File? image, {double? h, double? w}) {
  return Container(
    decoration: BoxDecoration(border: Border.all(color: primary2Color)),
    child: Image.file(
      image!,
      height: h ?? 100,
      width: w ?? 100,
      fit: BoxFit.cover,
    ),
  );
}
