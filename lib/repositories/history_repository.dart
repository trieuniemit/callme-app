import 'package:app.callme/database/tables/history_table.dart';
import 'package:app.callme/models/call_history.dart';

class HistoryRepository {
  final HistoryTable _db = HistoryTable();
  
  Future<List<CallHistory>> getHistory({int offset = 0, int limit = 20}) async {
    return await _db.getList(offset, limit);
  }

  void insertHistory(CallHistory history) {
    _db.addHistory(history);
  }
}