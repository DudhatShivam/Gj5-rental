import 'package:gj5_rental/notification/notification_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotificationDatabase {
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDb();
    return _database;
  }

  _initDb() async {
    String path = await getDatabasesPath();
    String dbPath = join(path, "notification.db");
    var theDb = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) {
      db.execute(
          "CREATE TABLE NOTIFICATION(id INTEGER PRIMARY KEY,title TEXT,body TEXT,date TEXT,keyword TEXT,orderId TEXT)");
    });
    return theDb;
  }

  dbInsert(NotificationModel notificationModel) async {
    Database? db = await database;
    await db?.insert('NOTIFICATION', notificationModel.toJson());
  }

  dbSelect() async {
    Database? db = await database;
    List<NotificationModel> notificationList = [];
    final data = await db?.rawQuery("SELECT * FROM NOTIFICATION");
    if (data != null) {
      data.forEach((element) {
        notificationList.add(NotificationModel.fromJson(element));
      });
    }
    return notificationList;
  }
}
