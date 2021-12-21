import /*'package:headache_app/persistence/medicine/MedicineDb_sqlite.dart'
if (dart.library.html)*/ 'package:headache_app/persistence/medicine/MedicineDb_memory.dart' as Impl;

class MedicineDb extends Impl.MedicineDb {
  static final MedicineDb _instance = MedicineDb._privateConstructor();

  MedicineDb._privateConstructor();

  factory MedicineDb() {
    return _instance;
  }
}
