import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:headache_app/persistence/medicine/MedicineDb.dart';
import 'package:headache_app/persistence/medicine/MedicineUsage.dart';
import 'package:headache_app/component/EffectivenessSelector.dart';

class MedicineUsageEditor extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const MedicineUsageEditor({
    Key? key,
    required this.value,
    required this.onChanged,
  }): super(key: key);

  @override
  _MedicineUsageEditorState createState() => _MedicineUsageEditorState(
    value: value,
    onChanged: onChanged
  );
}

class _MedicineUsageEditorState extends State<MedicineUsageEditor> {
  MedicineDb medicineDb = MedicineDb();

  List<MedicineUsage> medicineUsages = [];
  String value;
  final ValueChanged<String> onChanged;

  _MedicineUsageEditorState({
    required this.value,
    required this.onChanged,
  });

  @override
  void initState() {
    super.initState();
    refreshDataList();
  }

  refreshDataList() {
    setState(() {
      getAllData();
    });
  }

  void getAllData() async {
    final medicines = await medicineDb.findAllNotDeletedOrderByNameAscIdAsc();
    List<MedicineUsage> existedMedicineUsages = List<MedicineUsage>.from(json.decode(value).map((x) => MedicineUsage.fromMap(x)));
    final ids = existedMedicineUsages.map((medicineUsage) => medicineUsage.id).toSet();
    List<MedicineUsage> defaultMedicineUsages = medicines.where((medicine) => !ids.contains(medicine.id!))
      .map((medicine) => MedicineUsage(medicine.id!, medicine.name, medicine.isPainkiller,
        '', medicine.isPainkiller ? 0 : -1)).toList();
    setState(() {
      medicineUsages = existedMedicineUsages + defaultMedicineUsages;
    });
  }

  void saveData() {
    value = jsonEncode(medicineUsages.map((medicineUsage) => medicineUsage.toMap()).toList());
    onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: medicineUsages.length * 150, // TODO
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              shrinkWrap: true,
              itemCount: medicineUsages.length,
              itemBuilder: (BuildContext context, int position) {
                return Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: Column(
                    children: <Widget>[
                      Text(medicineUsages[position].name),
                      Row(
                        children: <Widget>[
                          const Text('請輸入數量：'),
                          Flexible(
                            child: TextFormField(
                              initialValue: medicineUsages[position].quantity,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.?\d{0,3})')),
                              ],
                              onChanged: (text) {
                                medicineUsages[position].quantity = text;
                                saveData();
                              }
                            )
                          )
                        ]
                      ),
                      if (medicineUsages[position].isPainkiller)
                        EffectivenessSelector(
                          label: '止痛藥有效嗎？',
                          value: medicineUsages[position].effectiveDegree,
                          onChanged: (int newValue) {
                            setState(() {
                              medicineUsages[position].effectiveDegree = newValue;
                              saveData();
                            });
                          }
                        )
                    ]
                  )
                );
              }
            )
          )
        ]
      )
    );
  }
}
