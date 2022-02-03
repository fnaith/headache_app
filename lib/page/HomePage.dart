import 'package:flutter/material.dart';
import 'package:headache_app/page/MedicineManagement.dart';
import 'package:headache_app/page/DailyRecordEditor.dart';
import 'package:headache_app/page/HelpPage.dart';
import 'package:headache_app/page/BackupAndRestorePage.dart';
import 'package:headache_app/page/AnalysisPage.dart';
import 'package:headache_app/persistence/dailyRecord/DailyRecord.dart';
import 'package:headache_app/persistence/dailyRecord/DailyRecordDb.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DailyRecordDb _dailyRecordDb = DailyRecordDb();
  final TextStyle noDataTextStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Colors.white
  );
  final TextStyle hasDataTextStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Color.fromARGB(255, 101, 115, 154)
  );
  final TextStyle toDayTextStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Colors.black
  );
  final Set<int> _existDates = {};
  DateTime? pressedDay;

  _HomePageState() {
    loadData();
  }

  void loadData() async {
    final List<DailyRecord> dailyRecords = await _dailyRecordDb.findAll();
    for (var dailyRecord in dailyRecords) {
      _existDates.add(dailyRecord.date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 230, 234),
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CalendarCarousel(
              locale: 'zh',
              maxSelectedDate: DateTime(2200, 12, 31),
              headerTextStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 255, 190, 201)
              ),
              daysHaveCircularBorder: true,
              dayButtonColor: const Color(0xFF97CBFF),
              prevMonthDayBorderColor: Colors.grey,
              nextMonthDayBorderColor: Colors.grey,
              weekdayTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 101, 115, 154)
              ),
              todayButtonColor: const Color.fromARGB(255, 198, 222, 252),
              todayBorderColor: Colors.white,
              thisMonthDayBorderColor: Colors.white,
              height: 480.0,
              isScrollable: false,
              markedDateShowIcon: true,
              onDayPressed: (date, event) {
                pressedDay = date;
                print(event);
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    DailyRecordEditor(dateTime: pressedDay!, onSave: (date) { _existDates.add(date); },
                        onSaveDone: () { setState(() {}); })));
              },
              customDayBuilder: (
                  bool isSelectable,
                  int index,
                  bool isSelectedDay,
                  bool isToday,
                  bool isPrevMonthDay,
                  TextStyle textStyle,
                  bool isNextMonthDay,
                  bool isThisMonthDay,
                  DateTime day,
                  ) {
                final date = DailyRecord.getDate(day);
                return Center(
                  child: Text(
                    day.day.toString(),
                    style: isToday ? toDayTextStyle : (_existDates.contains(date) ? hasDataTextStyle : noDataTextStyle)
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('藥物管理'),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const MedicineManagement()));
                  },
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  child: const Text('統計分析'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => const AnalysisPage()));
                  },
                )
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('備份還原'),
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context) =>
                        BackupAndRestorePage(onSave: (date) { _existDates.add(date); }, onSaveDone: () { setState(() {}); })));
                  },
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  child: const Text('幫助訊息'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpPage()));
                  },
                )
              ]
            )
          ]
        )
      )
    );
  }
}
