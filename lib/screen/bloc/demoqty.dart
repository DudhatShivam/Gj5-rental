import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:gj5_rental/constant/constant.dart';
import 'package:http/http.dart' as http;

import '../constant/order_quotation_comman_card.dart';
import 'demoqty_model.dart';

class DemoQty extends StatefulWidget {
  const DemoQty({Key? key}) : super(key: key);

  @override
  State<DemoQty> createState() => _DemoQtyState();
}

class _DemoQtyState extends State<DemoQty> {
  StreamController<List<DataModel>> _streamController = StreamController();
  List<DataModel> lst = [];

  @override
  void dispose() {
    // stop streaming when app close
    _streamController.close();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // A Timer method that run every 3 seconds
    Timer.periodic(Duration(seconds: 3), (timer) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          allScreenInitialSizedBox(context),
          StreamBuilder<List<DataModel>>(
              stream: _streamController.stream,
              builder: (context, AsyncSnapshot<List<DataModel>> snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      itemBuilder: (context, index) {
                        DataModel dataModel = snapshot.data![index];
                        return Container(
                          padding: EdgeInsets.all(15),
                          margin:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              border: Border.all(
                                  color: Color(0xffE6ECF2), width: 0.7),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text("Order No : ",
                                            style: primaryStyle),
                                        Text(
                                          dataModel.orderNo,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: primaryColor
                                                  .withOpacity(0.9)),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(dataModel.state,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.green.shade300)),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Customer : ", style: primaryStyle),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Expanded(
                                    child: Text(
                                      dataModel.customerName,
                                      style: allCardSubText,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Row(
                                children: [
                                  Text(
                                    dataModel.mobile1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: primaryColor.withOpacity(0.9)),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        // bool? res = await FlutterPhoneDirectCaller.callNumber(
                                        //     list[index]['mobile1']);
                                        // _makingPhoneCall(list[index]['mobile1'], context);
                                      },
                                      child: CircleAvatar(
                                          radius: 13,
                                          child: Icon(
                                            Icons.call,
                                            size: 17,
                                          ))),
                                  Row(
                                    children: [
                                      Text(" / "),
                                      Text(
                                        dataModel.mobile2 ?? "",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color:
                                                primaryColor.withOpacity(0.9)),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                          onTap: () async {
                                            // bool? res = await FlutterPhoneDirectCaller
                                            //     .callNumber(list[index]['mobile2']);
                                            // _makingPhoneCall(
                                            //     list[index]['mobile2'], context);
                                          },
                                          child: CircleAvatar(
                                              radius: 13,
                                              child: Icon(
                                                Icons.call,
                                                size: 17,
                                              ))),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Row(
                                children: [
                                  Text(
                                    dataModel.bookPersonName,
                                    style: allCardSubText,
                                  ),
                                ],
                              ),
                              dataModel.remark == null
                                  ? Container()
                                  : Column(
                                      children: [
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Remarks : ",
                                                style: primaryStyle),
                                            Expanded(
                                              child: SingleChildScrollView(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  dataModel.remark ?? "",
                                                  style: remarkTextStyle,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: 7,
                              ),
                              Divider(
                                height: 0.5,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "D. Date : ",
                                        style: primaryStyle,
                                      ),
                                      Text(
                                        dataModel.deliveryDate,
                                        style: deliveryDateStyle,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "R. Date : ",
                                        style: primaryStyle,
                                      ),
                                      Text(
                                        dataModel.returnDate,
                                        style: returnDateStyle,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return CenterCircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }

  Future<void> getData() async {
    getStringPreference('accessToken').then((value) async {
      String domain = "[('state','=','draft')]";
      var params = {'filters': domain.toString(), 'limit': '5'};
      Uri uri = Uri.parse("http://192.168.1.20:8867/api/rental.rental");
      final finalUri = uri.replace(queryParameters: params);
      final response = await http.get(finalUri, headers: {
        'Access-Token': value,
      });
      final data = jsonDecode(response.body);
      List databody = data['results'];
      lst.clear();
      databody.forEach((element) {
        lst.add(DataModel.fromJson(element));
      });
      _streamController.sink.add(lst);
    });
  }
}
