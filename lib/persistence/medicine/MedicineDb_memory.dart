import 'package:headache_app/persistence/medicine/Medicine.dart';

class MedicineDb {
  final Map<int, Map<String, dynamic>> _records = {};
  int _id = 0;
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
  Future<Medicine> softDeleteById(int id) {
    final medicine = Medicine.fromMap(_records[id]!);
    medicine.deleted = true;
    return _update(medicine);
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
