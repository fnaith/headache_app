import 'package:flutter/material.dart';
import 'package:headache_app/page/MedicineManagement.dart';
import 'package:headache_app/page/DailyRecordEditor.dart';
import 'package:headache_app/page/BPage.dart';
import 'package:headache_app/page/BackupAndRestorePage.dart';
import 'package:headache_app/persistence/medicine/MedicineDb.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? pressedDay;
  MedicineDb medicineDb = MedicineDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 228, 228),
      appBar: AppBar(
        title: Text(widget.title),
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
                color: Colors.orange
              ),
              daysHaveCircularBorder: true,
              dayButtonColor: const Color(0xFF97CBFF),
              weekdayTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black
              ),
              daysTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white
              ),
              weekendTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white
              ),
              inactiveDaysTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey
              ),
              inactiveWeekendTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey
              ),
              todayTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black
              ),
              todayButtonColor: const Color.fromARGB(255, 198, 222, 252),
              todayBorderColor: Colors.white,
              thisMonthDayBorderColor: Colors.white,
              height: 480.0,
              isScrollable: false,
              markedDateShowIcon: true,
              onDayPressed: (date, event) {
                pressedDay = date;
                Navigator.push(context, MaterialPageRoute(builder: (context) => DailyRecordEditor(pressedDay!)));
              },
              onCalendarChanged: (date) {
                //log(date.toString());
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
                if (day.day == 15) {
                  return Center(
                    child: Text(
                      day.day.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 28, 148, 247)
                      )
                    ),
                  );
                } else {
                  return null;
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('藥物管理'),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => MedicineManagement()));
                  },
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  child: const Text('統計分析'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BPage()));
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
                        context, MaterialPageRoute(builder: (context) => BackupAndRestorePage()));
                  },
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  child: const Text('幫助訊息'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BPage()));
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
