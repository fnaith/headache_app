import 'package:flutter/material.dart';
import 'package:headache_app/persistence/medicine/MedicineDb.dart';
import 'package:headache_app/persistence/medicine/Medicine.dart';

class MedicineManagement extends StatefulWidget {
  @override
  _MedicineManagementState createState() => _MedicineManagementState();
}

class _MedicineManagementState extends State<MedicineManagement> {
  MedicineDb medicineDb = MedicineDb();

  List<Medicine> noteListmain = [];

  TextEditingController titleController = TextEditingController();

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
                  Flexible(
                      flex: 4,
                      child: Container(
                          child: Column(
                              children: <Widget>[
                                Text("Title :"),
                                Flexible(
                                    child: TextField(
                                        controller: titleController
                                    )
                                ),
                                RaisedButton(
                                    child: Text("Add"),
                                    onPressed : () {
                                      setState(() {
                                        insertData();
                                        FocusScope.of(context).unfocus();
                                      });
                                    }
                                )
                              ]
                          )
                      )
                  ),
                  Flexible(
                      flex: 9,
                      child: ListView.builder(
                          itemCount: noteListmain.length,
                          itemBuilder: (BuildContext context, int position) {
                            return InkWell(
                                child: Card(
                                    color: Colors.white,
                                    elevation: 2.0,
                                    child: ListTile(
                                        leading: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            child: Icon(Icons.assessment)
                                        ),
                                        title: Text(this.noteListmain[position].name),
                                        trailing: GestureDetector(
                                            child: Icon(Icons.delete, color: Colors.grey),
                                            onTap: () {
                                              deleteData(this.noteListmain[position].id!);
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
    Medicine result = await medicineDb.save(Medicine(null, title, false, false));
    //print('inserted row id: $result.id');
    titleController.text = '';
    refreshDataList();
  }

  void getAllData() async {
    final noteMapList = await medicineDb.findAllNotDeletedOrderByNameAscIdAsc();
    setState(() {
      noteListmain = noteMapList;
    });
  }

  void deleteData(int itemId) async {
    await medicineDb.softDeleteById(itemId);
    refreshDataList();
  }
}
