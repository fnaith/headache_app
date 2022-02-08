import 'package:flutter/material.dart';
import 'package:headache_app/persistence/medicine/MedicineDb.dart';
import 'package:headache_app/persistence/medicine/Medicine.dart';
import 'package:headache_app/component/LabeledCheckbox.dart';

class MedicineManagement extends StatefulWidget {
  const MedicineManagement({Key? key}) : super(key: key);

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
      backgroundColor: const Color.fromARGB(255, 238, 230, 234),
      appBar: AppBar(
        title: const Text('藥物管理'),
        centerTitle: true
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
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
              child: const Text("新增"),
              onPressed : () {
                setState(() {
                  insertData();
                  FocusScope.of(context).unfocus();
                });
                const snackBar = SnackBar(
                    content: Text('新增成功')
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                          child: const Icon(Icons.delete, color: Colors.grey),
                          onTap: () {
                            showDeleteAlert(context, medicines[position].id!, medicines[position].name);
                          }
                        )
                      )
                    )
                  );
                }
              )
            ),
            ElevatedButton(
              child: const Text('返回首頁'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ]
        )
      )
    );
  }

  void insertData() async {
    String title = titleController.text;
    await medicineDb.save(Medicine(null, title, isPainkiller, false));
    titleController.text = '';
    isPainkiller = false;
    refreshDataList();
  }

  void getAllData() async {
    final medicines = await medicineDb.findAllNotDeletedOrderByNameAscIdAsc();
    setState(() {
      medicines.sort((a, b) => a.id!.compareTo(b.id!));
      this.medicines = medicines;
    });
  }

  Future<void> deleteData(int itemId) async {
    await medicineDb.softDeleteById(itemId);
    refreshDataList();
  }

  Future<void> showDeleteAlert(BuildContext context, int itemId, String itemName) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('確定要刪除 $itemName 嗎？'),
        content: const Text('刪除不會影響舊的記錄，但不再顯示於用藥記錄'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, '取消'),
            child: const Text('取消')
          ),
          TextButton(
            onPressed: () async {
              await deleteData(itemId);
              Navigator.pop(context, '確定刪除');
              const snackBar = SnackBar(
                  content: Text('刪除成功')
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: const Text('確定刪除')
          )
        ]
      )
    );
  }
}
