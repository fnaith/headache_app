import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:headache_app/persistence/medicine/Medicine.dart';

class MedicineDb {
  static sql.Database? database;

  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE TABLE medicines(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL,
        isPainkiller INTEGER NOT NULL,
        deleted INTEGER NOT NULL
      )
      """);
  }

  static Future<sql.Database> initDatabase() async {
    return sql.openDatabase(
      path.join(await sql.getDatabasesPath(), 'headache-medicines.db'), // TODO single db
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

  Future<Medicine> save(Medicine medicine) async {
    final db = await getDBConnect();
    medicine = Medicine.copy(medicine);
    medicine.id = await db.insert('medicines', medicine.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return Future<Medicine>.value(medicine);
  }

  Future<List<Medicine>> findAllNotDeletedOrderByNameAscIdAsc() async {
    final db = await getDBConnect();
    final medicines = (await db.query('medicines', where: "deleted = ?", whereArgs: [0], orderBy: 'name ASC, id ASC'))
        .map((record) => Medicine.fromMap(record))
        .toList();
    return Future<List<Medicine>>.value(medicines);
  }

  Future<int> softDeleteById(int id) async {
    final db = await getDBConnect();
    return await db.update('medicines', {'deleted': 1}, where: "id = ?", whereArgs: [id]);
  }
}
