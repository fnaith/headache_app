import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  final DateTime start;
  final DateTime end;
  final int duration;
  final int dailyRecordCount;
  final int totalPainMinutes;
  final List<int> painScales;
  final List<int> painTimings;
  final int mc;
  final int rls;

  const StatisticsPage({
    Key? key,
    required this.start,
    required this.end,
    required this.duration,
    required this.dailyRecordCount,
    required this.totalPainMinutes,
    required this.painScales,
    required this.painTimings,
    required this.mc,
    required this.rls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('統計分析'),
        centerTitle: true
      ),
      body: _StatisticsPage(start, end, duration, dailyRecordCount,
          totalPainMinutes, painScales, painTimings, mc, rls),
    );
  }
}

class _StatisticsPage extends StatelessWidget {
  final DateTime start;
  final DateTime end;
  final int duration;
  final int dailyRecordCount;
  final int totalPainMinutes;
  final List<int> painScales;
  final List<int> painTimings;
  final int mc;
  final int rls;

  _StatisticsPage(this.start, this.end, this.duration, this.dailyRecordCount,
      this.totalPainMinutes, this.painScales, this.painTimings, this.mc, this.rls);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(alignment: Alignment.centerLeft, child: Text('時間區間從${start.year}/${start.month}/${start.day}至${end.year}/${end.month}/${end.day}')),
            Align(alignment: Alignment.centerLeft, child: Text('共 ${duration} 天，共 $dailyRecordCount 筆資料')),
            Align(alignment: Alignment.centerLeft, child: Text('總共疼痛時間 ${(totalPainMinutes / 60.0).toStringAsFixed(1)} 小時')),
            Align(alignment: Alignment.centerLeft, child: Text('平均一天疼痛 ${(totalPainMinutes / 60.0 / duration).toStringAsFixed(2)} 小時')),
            Align(alignment: Alignment.centerLeft, child: Text('大痛 : ${painScales[3]} 天')),
            Align(alignment: Alignment.centerLeft, child: Text('中痛 : ${painScales[2]} 天')),
            Align(alignment: Alignment.centerLeft, child: Text('小痛 : ${painScales[1]} 天')),
            Align(alignment: Alignment.centerLeft, child: Text('大+中+小痛 : ${painScales[3] + painScales[2] + painScales[1]} 天')),
            Align(alignment: Alignment.centerLeft, child: Text('大+中痛 : ${painScales[3] + painScales[2]} 天')),
            Align(alignment: Alignment.centerLeft, child: Text('大痛 : ${painScales[0]} 天')),
            Align(alignment: Alignment.centerLeft, child: Text('受到月經影響的頭痛 : $mc 天')),
            Align(alignment: Alignment.centerLeft, child: Text('不寧腿 : $rls 天', textAlign: TextAlign.left)),
            ElevatedButton(
              child: const Text('返回上頁'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ]
        )
      )
    );
  }
}
