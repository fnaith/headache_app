import 'dart:math';
import 'package:flutter/material.dart';
import 'package:headache_app/page/StatisticsPage.dart';
import 'package:headache_app/persistence/dailyRecord/DailyRecordDb.dart';
import 'package:headache_app/persistence/dailyRecord/DailyRecord.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('統計分析'),
        centerTitle: true
      ),
      body: _AnalysisPage(),
    );
  }
}

class _AnalysisPage extends StatelessWidget {
  final DailyRecordDb _dailyRecordDb = DailyRecordDb();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('選擇日期範圍'),
              onPressed: () async {
                final range = await showDateRangePicker(
                  context: context,
                  locale: const Locale('zh', 'TW'),
                  firstDate: DateTime(1900, 1, 1),
                  lastDate: DateTime(2200, 12, 31));
                if (null != range) {
                  final int startDate = DailyRecord.getDate(range.start);
                  final int endDate = DailyRecord.getDate(range.end);
                  final int duration = daysBetween(range.start, range.end) + 1;
                  final List<DailyRecord> dailyRecords = (await _dailyRecordDb.findAllBetweenDate(startDate, endDate));
                  final int totalPainMinutes = dailyRecords.isEmpty ? 0 : dailyRecords.map((record) => record.headacheHours * 60 + record.headacheMinutes).reduce((a, b) => a + b);
                  final List<int> painScales = List.filled(4, 0);
                  final List<int> painTimings = List.filled(4, 0);
                  // debugPrint(startDate.toString());
                  // debugPrint(endDate.toString());
                  // debugPrint(dailyRecords.length.toString());
                  // debugPrint('totalPainMinutes: $totalPainMinutes');
                  int mc = 0;
                  int rls = 0;
                  for (var record in dailyRecords) {
                    int painScale = 0;
                    if (0 < record.morningPainScale) {
                      ++painTimings[0];
                      painScale = max(painScale, record.morningPainScale);
                    }
                    if (0 < record.afternoonPainScale) {
                      ++painTimings[1];
                      painScale = max(painScale, record.afternoonPainScale);
                    }
                    if (0 < record.nightPainScale) {
                      ++painTimings[2];
                      painScale = max(painScale, record.nightPainScale);
                    }
                    if (0 < record.sleepingPainScale) {
                      ++painTimings[3];
                      painScale = max(painScale, record.sleepingPainScale);
                    }
                    if (7 < painScale) {
                      painScale = 3;
                    } else if (3 < painScale) {
                      painScale = 2;
                    } else if (0 < painScale) {
                      painScale = 1;
                    } else {
                      painScale = 0;
                    }
                    ++painScales[painScale];
                    if (0 < painScale && record.haveMenstruation) {
                      ++mc;
                    }
                    if (record.haveRestlessLegSyndrome) {
                      ++rls;
                    }
                  }
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => StatisticsPage(
                      start: range.start, end: range.end, duration: duration, dailyRecordCount: dailyRecords.length,
                      totalPainMinutes: totalPainMinutes, painScales: painScales, painTimings: painTimings, mc: mc, rls: rls)));
                }
              },
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

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}
