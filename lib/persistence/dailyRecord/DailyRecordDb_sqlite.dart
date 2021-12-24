import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:headache_app/persistence/dailyRecord/DailyRecord.dart';

class DailyRecordDb {
  static sql.Database? database;

  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE TABLE dailyRecords(
        date INTEGER NOT NULL,
        morningPainScale INTEGER NOT NULL,
        afternoonPainScale INTEGER NOT NULL,
        nightPainScale INTEGER NOT NULL,
        sleepingPainScale INTEGER NOT NULL,
        haveSeenADoctor INTEGER NOT NULL,
        disgusted INTEGER NOT NULL,
        vomited INTEGER NOT NULL,
        sensitiveToLight INTEGER NOT NULL,
        sensitiveToSound INTEGER NOT NULL,
        headacheLikeBeating INTEGER NOT NULL,
        headacheStartFromOneSide INTEGER NOT NULL,
        physicalActivityAggravateHeadache INTEGER NOT NULL,
        eyeFlashes INTEGER NOT NULL,
        partialBlindness INTEGER NOT NULL,
        headacheHours INTEGER NOT NULL,
        headacheMinutes INTEGER NOT NULL,
        medicineUsage TEXT NOT NULL,
        hasMenstruation INTEGER NOT NULL,
        hasRestlessLegSyndrome INTEGER NOT NULL
      )
      """);
  }

  static Future<sql.Database> initDatabase() async {
    return sql.openDatabase(
      path.join(await sql.getDatabasesPath(), 'headache-dailyRecords.db'), // TODO single db
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTable(database);
      },
    );
  }

  static Future<sql.Database> getDBConnect() async {
    if (database != null) {
      return database!;
    }
    return await initDatabase();
  }

  Future<DailyRecord> save(DailyRecord dailyRecord) async {
    final db = await getDBConnect();
    await db.insert('dailyRecords', dailyRecord.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return Future<DailyRecord>.value(dailyRecord);
  }

  Future<DailyRecord?> findOneByDate(int date) async {
    final db = await getDBConnect();
    final dailyRecords = (await db.query('dailyRecords', where: "date = ?", whereArgs: [date]))
        .map((record) => DailyRecord.fromMap(record))
        .toList();
    if (dailyRecords.isEmpty) {
      return Future<DailyRecord?>.value(null);
    }
    return Future<DailyRecord?>.value(dailyRecords[0]);
  }
}
