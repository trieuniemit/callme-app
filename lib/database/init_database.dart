import 'package:app.callme/database/tables/history_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDB {
  static final AppDB _singleton = AppDB._internal();
  Database _database;

  factory AppDB() {
    return _singleton;
  }

  AppDB._internal();

  Future<Database> get database async {
    if (_database != null)
    return _database;
    //if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'callme_database.db');
    //print('DB: path $dbPath');

    var database = await openDatabase(dbPath, version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE ${HistoryTable.tableName}(${HistoryTable.fieldsList()})",
        );
      }
    );

    return database;
  }
}
