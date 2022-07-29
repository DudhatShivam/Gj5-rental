class NotificationModel {
  String? title;
  String? body;
  String? date;
  String? keyword;
  String? orderId;

  NotificationModel(
      {this.title, this.body, this.date, this.keyword, this.orderId});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    date = json['date'];
    keyword = json['keyword'];
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        'date': date,
        'keyword': keyword,
        'orderId': orderId
      };
}
