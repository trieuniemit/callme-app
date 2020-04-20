import 'package:app.callme/models/call_history.dart';
import 'package:sqflite/sqflite.dart';

import '../init_database.dart';

class HistoryTable {
  static String tableName = 'history_table';
  
  static Map<String, dynamic> fields = {
    'id': "INTEGER PRIMARY KEY",
    'user': "TEXT",
    'date_time': "INTERGER",
    'length': "INTERGER"
  };
  
  static String fieldsList() { 
    List<String> str = [];
    fields.forEach((k, v) {
      str.add(k + " " + v);
    });
    return str.join(",");
  }

  void addHistory(CallHistory row) async {
    final Database db = await AppDB().database;
    await db.insert(tableName, row.toMap());
  }

  Future<List<CallHistory>> getAll() async {
    final Database db = await AppDB().database;
    var res = await db.query(tableName, 
      orderBy: 'id ASC',
    );
    print('Get all: $res');
    return res.isNotEmpty ? res.map((c) => CallHistory.fromMap(c)).toList() : [];
  }

}