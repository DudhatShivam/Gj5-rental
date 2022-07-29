class DataModel {
  String orderNo;
  String state;
  String customerName;
  String mobile1;
  String? mobile2;
  String bookPersonName;
  String? remark;
  String deliveryDate;
  String returnDate;

  DataModel.fromJson(Map<String, dynamic> json)
      : orderNo = json['name'],
        state = json['state'],
        customerName = json['customer_name'],
        mobile1 = json['mobile1'],
        mobile2 = json['mobile1'],
        bookPersonName = json['user_id']['name'],
        remark = json['remarks'],
        deliveryDate = json['delivery_date'],
        returnDate = json['return_date'];
}
