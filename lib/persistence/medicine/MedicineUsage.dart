class MedicineUsage {
  int id;
  String name;
  bool isPainkiller;
  String quantity;
  int effectiveDegree;

  MedicineUsage(this.id, this.name, this.isPainkiller, this.quantity, this.effectiveDegree);
  MedicineUsage.fromMap(Map<String, dynamic> map) : this(map['id'], map['name'], map['isPainkiller'],
      map['quantity'], map['effectiveDegree']);

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'isPainkiller': isPainkiller, 'quantity': quantity, 'effectiveDegree': effectiveDegree};
  }
}
