import 'dart:async';
import 'package:trymethods/database/database.dart';
import 'package:trymethods/model/Log.dart';

class LogAccess {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createLog(Log log) async {
    final db = await dbProvider.database;
    var result = db.insert(logTABLE, log.toDatabaseJson());
    return result;
  }

  Future<List<Log>> getLogs({List<String> columns}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    result = await db.query(logTABLE, columns: columns);
    List<Log> logs = result.isNotEmpty
        ? result.map((item) => Log.fromDatabaseJson(item)).toList()
        : [];

    return logs;
  }

  Future<List<Log>> getLogsByDate({Duration time}) async {
    final db = await dbProvider.database;
    final date = DateTime.now();
    int now = date.millisecondsSinceEpoch;
    int day = date.add(time).millisecondsSinceEpoch;
    List<Map<String, dynamic>> result;
    String query = "date BETWEEN $day and $now";
    if (day - now == -31536000000) {
      query = "date=date";
    }
    result = await db.query(logTABLE, where: query);
    List<Log> logs = result.isNotEmpty
        ? result.map((item) => Log.fromDatabaseJson(item)).toList()
        : [];

    //debugPrint(logs.length.toString());
    return logs;
  }

  Future<int> updateLog(Log log) async {
    final db = await dbProvider.database;

    var result = await db.update(logTABLE, log.toDatabaseJson(),
        where: "id = ?", whereArgs: [log.id]);

    return result;
  }

  Future<int> deleteLog(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(logTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  Future<int> deleteLogByDate(Duration dur) async {
    final db = await dbProvider.database;
    int now = DateTime.now().add(dur).millisecondsSinceEpoch;
    var result =
        await db.delete(logTABLE, where: 'date <= ?', whereArgs: [now]);

    return result;
  }

  Future deleteAllLogs() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      logTABLE,
    );

    return result;
  }
}
