import 'package:sqflite/sqflite.dart' as sql;
import 'package:headache_app/persistence/Database_sqlite.dart';
import 'package:headache_app/persistence/medicine/Medicine.dart';

class MedicineDb {
  Future<Medicine> save(Medicine medicine) async {
    final db = await Database_sqlite.getDBConnect();
    medicine = Medicine.copy(medicine);
    medicine.id = await db.insert('medicines', medicine.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return Future<Medicine>.value(medicine);
  }

  Future<List<Medicine>> findAllNotDeletedOrderByNameAscIdAsc() async {
    final db = await Database_sqlite.getDBConnect();
    final medicines = (await db.query('medicines', where: "deleted = ?", whereArgs: [0], orderBy: 'name ASC, id ASC'))
        .map((record) => Medicine.fromMap(record))
        .toList();
    return Future<List<Medicine>>.value(medicines);
  }

  Future<int> softDeleteById(int id) async {
    final db = await Database_sqlite.getDBConnect();
    return await db.update('medicines', {'deleted': 1}, where: "id = ?", whereArgs: [id]);
  }
}
