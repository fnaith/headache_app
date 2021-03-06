import 'package:headache_app/persistence/medicine/Medicine.dart';

class MedicineDb {
  int _id = 4;

  final Map<int, Map<String, dynamic>> _records = {
    0: Medicine(0, '舒腦 Suzin 5 mg', false, false).toMap(),
    1: Medicine(1, '英明格 Imigran 50 mg', true, false).toMap(),
    2: Medicine(2, '中藥', false, false).toMap(),
    3: Medicine(3, '心康樂 Cardolol 40 mg', false, false).toMap()
  };

  _getId() {
    return _id++;
  }

  Future<Medicine> save(Medicine medicine) async {
    if (null == medicine.id) {
      return _insert(medicine);
    } else {
      return _update(medicine);
    }
  }

  Future<List<Medicine>> findAllNotDeletedOrderByNameAscIdAsc() async {
    final medicines = _records.values
        .map((record) => Medicine.fromMap(record))
        .where((medicine) => !medicine.deleted)
        .toList();
    medicines.sort((a, b) {
      final cmp = a.name.compareTo(b.name);
      if (cmp != 0) {
        return cmp;
      }
      return a.id!.compareTo(b.id!);
    });
    return Future<List<Medicine>>.value(medicines);
  }

  Future<int> softDeleteById(int id) {
    final medicine = Medicine.fromMap(_records[id]!);
    medicine.deleted = true;
    _update(medicine);
    return Future<int>.value(id);
  }

  Future<Medicine> _insert(Medicine medicine) {
    medicine = Medicine.copy(medicine);
    medicine.id = _getId();
    _records[medicine.id!] = medicine.toMap();
    return Future<Medicine>.value(medicine);
  }

  Future<Medicine> _update(Medicine medicine) {
    medicine = Medicine.copy(medicine);
    _records[medicine.id!] = medicine.toMap();
    return Future<Medicine>.value(medicine);
  }
}
