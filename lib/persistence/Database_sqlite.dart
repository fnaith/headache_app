import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class Database_sqlite {
  static sql.Database? database;

  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE TABLE dailyRecords(
        date INTEGER PRIMARY KEY NOT NULL,
        morningPainScale INTEGER NOT NULL,
        afternoonPainScale INTEGER NOT NULL,
        nightPainScale INTEGER NOT NULL,
        sleepingPainScale INTEGER NOT NULL,
        headacheHours INTEGER NOT NULL,
        headacheMinutes INTEGER NOT NULL,
        headacheRemark TEXT NOT NULL,
        disgusted INTEGER NOT NULL,
        vomited INTEGER NOT NULL,
        dizzy INTEGER NOT NULL,
        sensitiveToLight INTEGER NOT NULL,
        sensitiveToSound INTEGER NOT NULL,
        sensitiveToSmell INTEGER NOT NULL,
        headacheLikeBeating INTEGER NOT NULL,
        headacheStartFromOneSide INTEGER NOT NULL,
        painPointRunningAround INTEGER NOT NULL,
        physicalActivityAggravateHeadache INTEGER NOT NULL,
        eyeFlashes INTEGER NOT NULL,
        partialBlindness INTEGER NOT NULL,
        causeByTemperatureChange INTEGER NOT NULL,
        causeByWindBlow INTEGER NOT NULL,
        causeByMuscleTightness INTEGER NOT NULL,
        medicineUsage TEXT NOT NULL,
        dailyStressScale INTEGER NOT NULL,
        haveMenstruation INTEGER NOT NULL,
        haveRestlessLegSyndrome INTEGER NOT NULL,
        bodyTemperature TEXT NOT NULL,
        diastolicBloodPressure TEXT NOT NULL,
        systolicBloodPressure TEXT NOT NULL,
        haveEnoughSleep INTEGER NOT NULL,
        haveEnoughWater INTEGER NOT NULL,
        haveEnoughMeal INTEGER NOT NULL,
        haveExercise INTEGER NOT NULL,
        haveCoffee INTEGER NOT NULL,
        haveAlcohol INTEGER NOT NULL,
        haveSmoke INTEGER NOT NULL,
        dailyActivityRemark TEXT NOT NULL
      );
      """);
    await database.execute("""CREATE TABLE medicines(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL,
        isPainkiller INTEGER NOT NULL,
        deleted INTEGER NOT NULL
      );
      """);
    await database.execute("""INSERT INTO medicines(
        id, name, isPainkiller, deleted
      ) VALUES
      (0, '舒腦 Suzin 5 mg', 0, 0),
      (1, '英明格 Imigran 50 mg', 1, 0),
      (2, '中藥', 0, 0),
      (3, '心康樂 Cardolol 40 mg', 0, 0);
      """);
  }

  static Future<sql.Database> initDatabase() async {
    return sql.openDatabase(
      path.join(await sql.getDatabasesPath(), 'headache_app.db'),
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
}
