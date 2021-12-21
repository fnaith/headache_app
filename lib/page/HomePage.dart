import 'package:flutter/material.dart';
import 'package:headache_app/page/MedicineManagement.dart';
import 'package:headache_app/page/DailyRecordEditor.dart';
import 'package:headache_app/page/BPage.dart';
import 'package:headache_app/persistence/medicine/MedicineDb.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  DateTime? pressedDay;
  MedicineDb medicineDb = MedicineDb();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
              CalendarCarousel(
                daysHaveCircularBorder: null,
                weekendTextStyle: TextStyle(
                  color: Colors.black,
                ),
                thisMonthDayBorderColor: Colors.grey,
                height: 420.0,
                showIconBehindDayText: true,
                customGridViewPhysics: NeverScrollableScrollPhysics(),
                markedDateShowIcon: true,
                markedDateIconMaxShown: 1,
                todayTextStyle: TextStyle(
                  color: Colors.white,
                ),
                markedDateIconBuilder: (Event event) {
                  return event.icon ?? Icon(Icons.help_outline);
                },
                locale: 'zh',
                todayButtonColor: Colors.blue,
                onDayPressed: (date, event) {
                  pressedDay = date;
                  print('${date}');
                  /*medicineDb.save(Medicine(null, '${date}', false));
                medicineDb.findAllOrderByName().then((items) {
                  print('${items}');
                });*/
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DailyRecordEditor(pressedDay!)));
                },
              ),
              RaisedButton(
                child: Text('藥物管理'),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => MedicineManagement()));
                },
              ),
              RaisedButton(
                child: Text('跳到 B 頁'),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => BPage()));
                },
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        )
    );
  }
}
