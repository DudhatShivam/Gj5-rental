import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gj5_rental/screen/quatation/quotation_const/quotation_constant.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../Utils/utils.dart';

class EditCustomerImageDialog extends StatefulWidget {
  final Uint8List image;
  final int lineId;
  final int orderId;

  const EditCustomerImageDialog(
      {Key? key,
      required this.image,
      required this.orderId,
      required this.lineId})
      : super(key: key);

  @override
  State<EditCustomerImageDialog> createState() =>
      _EditCustomerImageDialogState();
}

class _EditCustomerImageDialogState extends State<EditCustomerImageDialog> {
  TextStyle textStyle =
      TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500);
  File? image1;
  String? binaryImage1;

  @override
  Widget build(BuildContext context) {
    String txt = image1 != null ? "Confirm Edit" : "Edit";
    return Container(
      child: Dialog(
          backgroundColor: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.memory(
                widget.image,
                fit: BoxFit.cover,
                height: getHeight(0.4, context),
                width: double.infinity,
              ),
              image1 != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Text(
                        image1?.path.split('/').last ?? "",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500),
                      ),
                    )
                  : Container(),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      image1 != null
                          ? checkWlanForEditImage(false)
                          : _getImage();
                    },
                    child: edit_delete_btn(txt, Colors.blue),
                  ),
                  Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () {
                      binaryImage1 = "";
                      image1 = null;
                      checkWlanForEditImage(true);
                    },
                    child: edit_delete_btn("Delete", Colors.red),
                  )
                ],
              )
            ],
          )),
    );
  }

  checkWlanForEditImage(bool isDelete) {
    getStringPreference('apiUrl').then((apiUrl) async {
      try {
        getStringPreference('accessToken').then((token) async {
          if (apiUrl.toString().startsWith("192")) {
            showConnectivity().then((result) async {
              if (result == ConnectivityResult.wifi) {
                editImage(apiUrl, token, isDelete);
              } else {
                dialog(context, "Connect to Showroom Network",
                    Colors.red.shade300);
              }
            });
          } else {
            editImage(apiUrl, token, isDelete);
          }
        });
      } on SocketException catch (err) {
        dialog(context, "Connect to Showroom Network", Colors.red.shade300);
      }
    });
  }

  editImage(String url, String token, bool isDelete) async {
    String URL = "http://$url/api/rental.line/${widget.lineId}";
    final response = await http.put(Uri.parse(URL),
        body: jsonEncode({"customer_image": binaryImage1}),
        headers: {
          'Access-Token': token,
        });
    if (response.statusCode == 200) {
      isDelete
          ? showToast("Image Deleted SuccessFully")
          : showToast("Image Edit SuccessFully");
      checkQuotationAndOrderDetailData(context, widget.orderId, false);
      Navigator.pop(context);
    } else {
      image1 == null;
      isDelete
          ? showToast("Error in Image Deletion")
          : showToast("Error in Image Edition");

      setState(() {});
    }
  }

  _getImage() async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image1 = File(pickedFile.path);
      Uint8List? imageBytes = await image1?.readAsBytes(); //convert to bytes
      binaryImage1 = base64.encode(imageBytes!);
      setState(() {});
    }
  }

  edit_delete_btn(String name, Color color) {
    return Container(
      width: getWidth(0.392, context),
      alignment: Alignment.center,
      height: 50,
      color: color,
      child: Text(
        name,
        style: textStyle,
      ),
    );
  }
}
