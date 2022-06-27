import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/utils.dart';
import '../../../getx/getx_controller.dart';
import 'order_line_card.dart';

class OrderLineServicePopUp extends StatefulWidget {
  final int orderId;
  final int index;
  final bool isShowFromGroupBy;
  final int? groupByMainListIndex;

  const OrderLineServicePopUp(
      {Key? key, required this.orderId, required this.index, required this.isShowFromGroupBy, this.groupByMainListIndex})
      : super(key: key);

  @override
  State<OrderLineServicePopUp> createState() => _OrderLineServicePopUpState();
}

class _OrderLineServicePopUpState extends State<OrderLineServicePopUp> {
  MyGetxController myGetxController = Get.find();
  String? gender;
  String? selectedValue;
  List lst = [];
  List<String> serviceOrderLineDropDownList = [];


  @override
  void initState() {
    print(widget.isShowFromGroupBy);
    print(widget.index);
    print(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Servicing",
              style: dialogTitleStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio(
                        value: "washing",
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = null;
                            serviceOrderLineDropDownList.clear();
                            gender = value.toString();
                            getResPartnerData(value.toString());
                          });
                        }),
                    Text(
                      "Washing",
                      style: primaryStyle,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: "stitching",
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = null;
                            serviceOrderLineDropDownList.clear();
                            gender = value.toString();
                            getResPartnerData(value.toString());
                          });
                        }),
                    Text(
                      "Stitching",
                      style: primaryStyle,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              color: Colors.grey.shade100,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Select Item',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                  items: serviceOrderLineDropDownList
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                item,
                                style: primaryStyle,
                              ),
                            ),
                          ))
                      .toList(),
                  value: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value as String;
                    });
                  },
                  buttonHeight: 40,
                  buttonWidth: getWidth(0.25, context),
                  itemHeight: 40,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                selectedValue == null
                    ? Container()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green.shade300),
                        onPressed: () {
                          setService();
                        },
                        child: Text("Servicing")),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: Colors.red.shade300),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"))
              ],
            )
          ],
        ),
      ),
    );
  }

  void getResPartnerData(String service) {
    getStringPreference('apiUrl').then((apiUrl) {
      getStringPreference('accessToken').then((token) async {
        String domain =
            "[('vendor_type'  , '='  , 'service'),('service_type'  , '='  , '$service')]";
        var params = {'filters': domain.toString()};
        Uri uri = Uri.parse("http://$apiUrl/api/res.partner");
        final finalUri = uri.replace(queryParameters: params);
        final response = await http.get(finalUri, headers: {
          'Access-Token': token,
          'Content-Type': 'application/http',
          'Connection': 'keep-alive'
        });
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['count'] != 0) {
            lst = data['results'];
            lst.forEach((element) {
              serviceOrderLineDropDownList.add(element['name']);
            });
            setState(() {});
          }
        } else {
          dialog(context, "Something Went Wrong !");
        }
      });
    });
  }

  void setService() {
    int? partnerId;
    int orderLineId = widget.orderId;
    lst.forEach((element) {
      if (element['name'] == selectedValue) {
        partnerId = element['id'];
      }
    });
    print(partnerId);
    if (partnerId != null) {
      getStringPreference('apiUrl').then((apiUrl) {
        getStringPreference('accessToken').then((token) async {
          final finalUri = Uri.parse(
              "http://$apiUrl/api/rental.line/$orderLineId/btn_service_api?service_type=$gender&service_partner_id=$partnerId");
          final response = await http.put(finalUri, headers: {
            'Access-Token': token,
          });
          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            if (data['status'] == 0) {
              Navigator.pop(context);
              dialog(context, data['msg']);
            } else {
              widget.isShowFromGroupBy == true ?  setDataOfUpdatedIdInGroupByListOrderLineScreen(widget.orderId, widget.index,widget.groupByMainListIndex ?? 0) : setDataOfUpdatedIdInOrderLineScreen(widget.orderId, widget.index);
              Navigator.pop(context);
            }
          } else {
            dialog(context, "Something Went Wrong !");
          }
        });
      });
    }
  }

}