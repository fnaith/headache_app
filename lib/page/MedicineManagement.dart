import 'package:flutter/material.dart';
import 'package:headache_app/persistence/medicine/MedicineDb.dart';
import 'package:headache_app/persistence/medicine/Medicine.dart';
import 'package:headache_app/component/LabeledCheckbox.dart';

class MedicineManagement extends StatefulWidget {
  @override
  _MedicineManagementState createState() => _MedicineManagementState();
}

class _MedicineManagementState extends State<MedicineManagement> {
  MedicineDb medicineDb = MedicineDb();

  List<Medicine> medicines = [];

  TextEditingController titleController = TextEditingController();
  bool isPainkiller = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('藥物管理'),
        ),
        body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text("Title :"),
                  Flexible(
                      child: TextField(
                          controller: titleController,
                          decoration: const InputDecoration(hintText: "請輸入藥名及劑量")
                      )
                  ),
                  LabeledCheckbox(
                      label: '是預防用藥或止痛藥？',
                      value: isPainkiller,
                      onChanged: (bool newValue) {
                        setState(() {
                          isPainkiller = newValue;
                        });
                      }
                  ),
                  ElevatedButton(
                      child: Text("新增"),
                      onPressed : () {
                        setState(() {
                          insertData();
                          FocusScope.of(context).unfocus();
                        });
                      }
                  ),
                  Flexible(
                      flex: 9,
                      child: ListView.builder(
                          itemCount: medicines.length,
                          itemBuilder: (BuildContext context, int position) {
                            return InkWell(
                                child: Card(
                                    color: Colors.white,
                                    elevation: 2.0,
                                    child: ListTile(
                                        title: Text(medicines[position].name + (medicines[position].isPainkiller ? ' [預防/止痛藥]' : '')),
                                        trailing: GestureDetector(
                                            child: Icon(Icons.delete, color: Colors.grey),
                                            onTap: () {
                                              deleteData(medicines[position].id!);
                                            }
                                        )
                                    )
                                )
                            );
                          }
                      )
                  )
                ]
            )
        )
    );
  }

  void insertData() async {
    String title = titleController.text;
    Medicine result = await medicineDb.save(Medicine(null, title, isPainkiller, false));
    //print('inserted row id: $result.id');
    titleController.text = '';
    isPainkiller = false;
    refreshDataList();
  }

  void getAllData() async {
    final medicines = await medicineDb.findAllNotDeletedOrderByNameAscIdAsc();
    setState(() {
      this.medicines = medicines;
    });
  }

  void deleteData(int itemId) async {
    await medicineDb.softDeleteById(itemId);
    refreshDataList();
  }
}