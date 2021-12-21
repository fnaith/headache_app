class Medicine {
  int? id;
  String name = "";
  bool isPainkiller = false;
  bool deleted = false;

  Medicine(this.id, this.name, this.isPainkiller, this.deleted);
  Medicine.copy(Medicine other) : this(other.id, other.name, other.isPainkiller, other.deleted);
  Medicine.fromMap(Map<String, dynamic> map) : this(map['id'], map['name'], map['isPainkiller'], map['deleted']);

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'isPainkiller': isPainkiller, 'deleted': deleted};
  }
}
