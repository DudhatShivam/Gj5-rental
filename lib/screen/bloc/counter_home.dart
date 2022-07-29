import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gj5_rental/block2/counter_bloc.dart';
import 'package:http/http.dart' as http;

import '../Utils/utils.dart';
import '../screen/demoqty_model.dart';
import 'home2.dart';

class CounterHome extends StatefulWidget {
  const CounterHome({Key? key}) : super(key: key);

  @override
  State<CounterHome> createState() => _CounterHomeState();
}

class _CounterHomeState extends State<CounterHome> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, CounterState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              pushMethod(context, Home2());
            },
            child: Icon(Icons.add),
          ),
          body: state.datamodel.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.datamodel.length,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  itemBuilder: (context, index) {
                    DataModel dataModel = state.datamodel[index];
                    return Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          border:
                              Border.all(color: Color(0xffE6ECF2), width: 0.7),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text("Order No : ", style: primaryStyle),
                                    Text(
                                      dataModel.orderNo,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: primaryColor.withOpacity(0.9)),
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
                                        color: primaryColor.withOpacity(0.9)),
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
                                        Text("Remarks : ", style: primaryStyle),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            physics: BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                )
              : CenterCircularProgressIndicator(),
        );
      },
    );
  }

  @override
  void initState() {
    getData(context);
  }


}
Future<void> getData(BuildContext context) async {
  getStringPreference('accessToken').then((value) async {
    String domain = "[('state','=','draft')]";
    var params = {'filters': domain.toString(), 'limit': '5'};
    Uri uri = Uri.parse("http://192.168.29.45:8867/api/rental.rental");
    final finalUri = uri.replace(queryParameters: params);
    final response = await http.get(finalUri, headers: {
      'Access-Token': value,
    });
    List<DataModel> lst = [];
    final data = jsonDecode(response.body);
    List databody = data['results'];
    databody.forEach((element) {
      lst.add(DataModel.fromJson(element));
    });
    context.read<CounterBloc>().add(increment(dataModelList: lst));
  });
}
