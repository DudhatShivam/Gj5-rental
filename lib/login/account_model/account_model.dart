class AccountModel {
  int? id;
  String? serverUrl;
  String? dbName;
  String? name;
  String? userName;
  String? password;
  String? branchName;

  AccountModel(
      {this.id,
      this.serverUrl,
      this.dbName,
      this.userName,
      this.name,
      this.password,
      this.branchName});

  AccountModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serverUrl = json['serverUrl'];
    dbName = json['dbName'];
    name = json['name'];
    userName = json['userName'];
    password = json['password'];
    branchName = json['branchName'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'serverUrl': serverUrl,
        'dbName': dbName,
        'userName': userName,
        'name': name,
        'password': password,
        'branchName': branchName
      };
}
