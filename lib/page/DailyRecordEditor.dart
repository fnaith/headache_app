import 'package:flutter/material.dart';
import 'package:headache_app/persistence/dailyRecord/DailyRecordDb.dart';
import 'package:headache_app/persistence/dailyRecord/DailyRecord.dart';

class DailyRecordEditor extends StatefulWidget {
  DateTime dateTime;

  DailyRecordEditor(this.dateTime);

  @override
  _DailyRecordEditorState createState() => _DailyRecordEditorState(dateTime);
}

class _DailyRecordEditorState extends State<DailyRecordEditor> {
  DailyRecordDb _dailyRecordDb = DailyRecordDb();
  DateTime _dateTime;
  DailyRecord? _dailyRecord = null;
  bool _customTileExpanded = false;

  _DailyRecordEditorState(this._dateTime);

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
              children: <Widget>[
                const ExpansionTile(
                  title: Text('ExpansionTile 1'),
                  subtitle: Text('Trailing expansion arrow icon'),
                  children: <Widget>[
                    ListTile(title: Text('This is tile number 1')),
                  ],
                ),
                ExpansionTile(
                  title: const Text('ExpansionTile 2'),
                  subtitle: const Text('Custom expansion arrow icon'),
                  trailing: Icon(
                    _customTileExpanded
                        ? Icons.arrow_drop_down_circle
                        : Icons.arrow_drop_down,
                  ),
                  children: const <Widget>[
                    ListTile(title: Text('This is tile number 2')),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded = expanded);
                  },
                ),
                const ExpansionTile(
                  title: Text('ExpansionTile 3'),
                  subtitle: Text('Leading expansion arrow icon'),
                  controlAffinity: ListTileControlAffinity.leading,
                  children: <Widget>[
                    ListTile(title: Text('This is tile number 3')),
                  ],
                ),
              ],
            )
        )
    );
  }

  void getAllData() async {
    final date = DailyRecord.getDate(_dateTime);
    DailyRecord? dailyRecord = await _dailyRecordDb.findOneByDate(date);
    dailyRecord ??= DailyRecord(date);
    setState(() {
      _dailyRecord = dailyRecord;
    });
  }
}
