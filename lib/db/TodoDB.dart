import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class TodoTB {
  static int _id = 0;
  static List<Map<String, dynamic>> _records = [];
  static _getId() {
    return _id++;
  }
  static Future<int> createItem(String title, String? descrption) async {
    final id = _getId();
    final data = {'id': id, 'title': title, 'description': descrption};
    _records.add(data);
    return Future<int>.value(id);
  }
  static Future<List<Map<String, dynamic>>> getItems() async {
    return Future<List<Map<String, dynamic>>>.value(_records);
  }
/*
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    Databse _db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    Database tmp = await databaseFactoryFfi.openDatabase(dbFile.path, options: options);
    await _db.rawQuery("ATTACH DATABASE ? as tmpDb", [dbFile.path]);
    await _db.rawQuery("CREATE TABLE TABLENAME AS SELECT * FROM tmpDb.TABLENAME");
    return _db;

    /*return sql.openDatabase(
      'todo.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );*/
  }

  // Create new item (journal)
  static Future<int> createItem(String title, String? descrption) async {
    final db = await TodoTB.db();

    final data = {'title': title, 'description': descrption};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await TodoTB.db();
    return db.query('items', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await TodoTB.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String title, String? descrption) async {
    final db = await TodoTB.db();

    final data = {
      'title': title,
      'description': descrption,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await TodoTB.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }*/
}
