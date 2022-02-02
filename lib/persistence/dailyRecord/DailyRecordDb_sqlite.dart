import 'package:sqflite/sqflite.dart' as sql;
import 'package:headache_app/persistence/Database_sqlite.dart';
import 'package:headache_app/persistence/dailyRecord/DailyRecord.dart';

class DailyRecordDb {
  Future<DailyRecord> save(DailyRecord dailyRecord) async {
    final db = await Database_sqlite.getDBConnect();
    await db.insert('dailyRecords', dailyRecord.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return Future<DailyRecord>.value(dailyRecord);
  }

  Future<DailyRecord?> findOneByDate(int date) async {
    final db = await Database_sqlite.getDBConnect();
    final dailyRecords = (await db.query('dailyRecords', where: "date = ?", whereArgs: [date]))
        .map((record) => DailyRecord.fromMap(record))
        .toList();
    if (dailyRecords.isEmpty) {
      return Future<DailyRecord?>.value(null);
    }
    return Future<DailyRecord?>.value(dailyRecords[0]);
  }

  Future<List<DailyRecord>> findAll() async {
    final db = await Database_sqlite.getDBConnect();
    final dailyRecords = (await db.query('dailyRecords'))
        .map((record) => DailyRecord.fromMap(record))
        .toList();
    return Future<List<DailyRecord>>.value(dailyRecords);
  }
}
