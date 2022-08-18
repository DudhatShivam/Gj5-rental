import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../account_model/account_model.dart';

class AccountDatabase {
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDb();
    return _database;
  }

  _initDb() async {
    String path = await getDatabasesPath();
    String dbPath = join(path, "account.db");
    var theDb = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) {
      db.execute(
          "CREATE TABLE ACCOUNT(id INTEGER PRIMARY KEY,serverUrl TEXT,dbName TEXT,userName TEXT,name TEXT,password TEXT,branchName TEXT)");
    });
    return theDb;
  }

  dbInsert(AccountModel accountModel) async {
    Database? db = await database;
    await db
        ?.insert('ACCOUNT', accountModel.toJson());
    }

  dbSelect() async {
    Database? db = await database;
    List<AccountModel> accountList = [];
    final data = await db?.rawQuery("SELECT * FROM ACCOUNT");
    if (data != null) {
      data.forEach((element) {
        accountList.add(AccountModel.fromJson(element));
      });
    }
    return accountList;
  }

  dbDelete(var id) async {
    Database? db = await database;
    await db?.rawQuery('DELETE FROM ACCOUNT WHERE id=$id');
  }
}
