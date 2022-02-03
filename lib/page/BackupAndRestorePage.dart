import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';
import 'package:headache_app/persistence/dailyRecord/DailyRecordDb.dart';
import 'package:headache_app/persistence/dailyRecord/DailyRecord.dart';
import 'package:headache_app/persistence/medicine/MedicineUsage.dart';

class BackupAndRestorePage extends StatelessWidget {
  final ValueChanged<int> onSave;
  final VoidCallback onSaveDone;

  const BackupAndRestorePage({
    Key? key,
    required this.onSave,
    required this.onSaveDone
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 230, 234),
      appBar: AppBar(
        title: const Text('備份還原'),
        centerTitle: true
      ),
      body: _BackupAndRestorePage(onSave, onSaveDone),
    );
  }
}

class _BackupAndRestorePage extends StatelessWidget {
  final DailyRecordDb _dailyRecordDb = DailyRecordDb();
  final ValueChanged<int> onSave;
  final VoidCallback onSaveDone;

  _BackupAndRestorePage(this.onSave, this.onSaveDone);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            child: const Text('匯入檔案'),
            onPressed: () async {
              await FilePicker.platform.clearTemporaryFiles();
              final FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['txt'],
                withData: true,
                withReadStream: true
              );
              if (null != result) {
                final PlatformFile file = result.files.first;
                if (null != file.bytes) {
                  final String json = utf8.decode(file.bytes!);
                  final mapList = jsonDecode(json) as List<dynamic>;
                  // log('>>>${(await _dailyRecordDb.findAll()).length}');
                  for (var i = 0 ; i < mapList.length; ++i) {
                    final dynamic map = mapList[i];
                    final isNewDailyRecord = null == await _dailyRecordDb.findOneByDate(map['date']);
                    if (isNewDailyRecord) {
                      await _dailyRecordDb.save(DailyRecord.fromMap(map));
                      onSave(map['date']);
                    }
                  }
                  onSaveDone();
                  // log('>>>${(await _dailyRecordDb.findAll()).length}');
                }
              }
            },
          ),
          ElevatedButton(
            child: const Text('匯出備份'),
            onPressed: () async {
              final List<DailyRecord> dailyRecords = await _dailyRecordDb.findAll();
              final String json = jsonEncode(dailyRecords.map((dailyRecord) => dailyRecord.toMap()).toList());
              final file = await writeBackup(json);
              Share.shareFiles([file.path], subject: '頭痛 App 匯出備份', text: '匯出日期 : ${DateTime.now()}');
            },
          ),
          ElevatedButton(
            child: const Text('匯出月報'),
            onPressed: () async {
              final DateTime? date = await showDatePicker(
                context: context,
                locale: const Locale('zh', 'TW'),
                firstDate: DateTime(1900, 1, 1),
                lastDate: DateTime(2200, 12, 31),
                initialDate: DateTime.now(),
                helpText: "選擇月份",
                initialDatePickerMode: DatePickerMode.year);
              if (null != date) {
                final int startDate = DailyRecord.calculateDate(date.year, date.month, 1);
                final int endDate = DailyRecord.calculateDate(date.year, date.month, 31);
                final List<DailyRecord> dailyRecords = await _dailyRecordDb.findAllBetweenDate(startDate, endDate);
                final String csv = generateReport(startDate, dailyRecords);
                final file = await writeReport(date.year, date.month, csv);
                Share.shareFiles([file.path], subject: '頭痛 App 匯出月報', text: '匯出日期 : ${DateTime.now()}');
              }
            },
          ),
          ElevatedButton(
            child: const Text('返回首頁'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      )
    );
  }

  String generateReport(int startDate, List<DailyRecord> dailyRecords) {
    final List<String> fields = [
      '早上頭痛程度(0-10)', '下午頭痛程度(0-10)', '晚上頭痛程度(0-10)', '睡眠頭痛程度(0-10)',
      '當日頭痛時數', '頭痛備註',

      '是否噁心', '是否嘔吐', '是否頭暈',
      '對光線敏感', '對聲音敏感', '對氣味敏感',

      '頭痛像脈搏跳動', '由單側開始', '痛點會亂跑', '身體活動會加重頭痛',
      '眼前出現閃光', '部分視野看不見',

      '由氣溫變化引起', '由風吹引起', '由肌肉緊繃引起',
      '日常活動備註', '壓力程度',

      '有月經', '有不寧腿',
      '體溫(°C)', '舒張壓(mmHg)', '收縮壓(mmHg)',

      '充分睡眠', '充分飲水', '三餐正常',
      '有運動', '有喝咖啡', '有喝酒', '有抽菸',
    ];
    final List<String> header = List.filled(32, "");
    for (var i = 0; i < 31; ++i) {
      header[i + 1] = (i + 1).toString();
    }
    final List<List<String>> rows = [];
    for (var i = 0; i < fields.length; ++i) {
      final List<String> row = List.filled(32, "");
      row[0] = fields[i];
      rows.add(row);
    }
    final List<List<String>> medicineRows = [];

    final Map<int, MedicineUsage> medicines = {};
    final Set<int> painkillerIds = {};
    for (DailyRecord dailyRecord in dailyRecords) {
      final medicineUsages = List<MedicineUsage>.from(json.decode(dailyRecord.medicineUsage).map((x) => MedicineUsage.fromMap(x)));
      for (var medicineUsage in medicineUsages) {
        medicines[medicineUsage.id] = medicineUsage;
        if (medicineUsage.isPainkiller) {
          painkillerIds.add(medicineUsage.id);
        }
      }
    }
    final List<int> orderedMedicineIds = medicines.keys.toList();
    orderedMedicineIds.sort((a, b) => a.compareTo(b));
    final Map<int, int> medicineIdToIndex = {};
    for (var medicineId in orderedMedicineIds) {
      medicineIdToIndex[medicineId] = medicineRows.length;
      final List<String> usageList = List.filled(32, "");
      final MedicineUsage medicineUsage = medicines[medicineId]!;
      usageList[0] = (medicineUsage.isPainkiller ? '藥物 - ' : '止痛劑') + medicineUsage.name;
      medicineRows.add(usageList);
      if (painkillerIds.contains(medicineId)) {
        final List<String> usefulList = List.filled(32, "");
        usefulList[0] = usageList[0] + '有效程度(0-3)';
        medicineRows.add(usefulList);
      }
    }

    for (DailyRecord dailyRecord in dailyRecords) {
      final int index = dailyRecord.date - startDate + 1;

      rows[0][index] = dailyRecord.morningPainScale.toString();
      rows[1][index] = dailyRecord.afternoonPainScale.toString();
      rows[2][index] = dailyRecord.nightPainScale.toString();
      rows[3][index] = dailyRecord.sleepingPainScale.toString();
      rows[4][index] = '${dailyRecord.headacheHours.toString().padLeft(2, '0')}:${dailyRecord.headacheMinutes.toString().padLeft(2, '0')}';
      rows[5][index] = dailyRecord.headacheRemark;

      rows[6][index] = dailyRecord.disgusted ? 'v' : '';
      rows[7][index] = dailyRecord.vomited ? 'v' : '';
      rows[8][index] = dailyRecord.dizzy ? 'v' : '';
      rows[9][index] = dailyRecord.sensitiveToLight ? 'v' : '';
      rows[10][index] = dailyRecord.sensitiveToSound ? 'v' : '';
      rows[11][index] = dailyRecord.sensitiveToSmell ? 'v' : '';

      rows[12][index] = dailyRecord.headacheLikeBeating ? 'v' : '';
      rows[13][index] = dailyRecord.headacheStartFromOneSide ? 'v' : '';
      rows[14][index] = dailyRecord.painPointRunningAround ? 'v' : '';
      rows[15][index] = dailyRecord.physicalActivityAggravateHeadache ? 'v' : '';
      rows[16][index] = dailyRecord.eyeFlashes ? 'v' : '';
      rows[17][index] = dailyRecord.partialBlindness ? 'v' : '';

      rows[18][index] = dailyRecord.causeByTemperatureChange ? 'v' : '';
      rows[19][index] = dailyRecord.causeByWindBlow ? 'v' : '';
      rows[20][index] = dailyRecord.causeByMuscleTightness ? 'v' : '';

      final medicineUsages = List<MedicineUsage>.from(json.decode(dailyRecord.medicineUsage).map((x) => MedicineUsage.fromMap(x)));
      for (var medicineUsage in medicineUsages) {
        if (medicineUsage.quantity.isNotEmpty) {
          final int medicineRowIndex = medicineIdToIndex[medicineUsage.id]!;
          medicineRows[medicineRowIndex][index] = medicineUsage.quantity;
          if (medicineUsage.isPainkiller) {
            medicineRows[medicineRowIndex + 1][index] = medicineUsage.effectiveDegree.toString();
          }
        }
      }

      rows[21][index] = dailyRecord.dailyActivityRemark;
      rows[22][index] = dailyRecord.causeByMuscleTightness ? 'v' : '';

      rows[23][index] = dailyRecord.haveMenstruation ? 'v' : '';
      rows[24][index] = dailyRecord.haveRestlessLegSyndrome ? 'v' : '';
      rows[25][index] = dailyRecord.bodyTemperature.isEmpty ? '' : dailyRecord.bodyTemperature;
      rows[26][index] = dailyRecord.diastolicBloodPressure.isEmpty ? '' : dailyRecord.diastolicBloodPressure;
      rows[27][index] = dailyRecord.systolicBloodPressure.isEmpty ? '' : dailyRecord.systolicBloodPressure;

      rows[28][index] = dailyRecord.haveEnoughSleep ? 'v' : '';
      rows[29][index] = dailyRecord.haveEnoughWater ? 'v' : '';
      rows[30][index] = dailyRecord.haveEnoughMeal ? 'v' : '';
      rows[31][index] = dailyRecord.haveExercise ? 'v' : '';
      rows[32][index] = dailyRecord.haveCoffee ? 'v' : '';
      rows[33][index] = dailyRecord.haveAlcohol ? 'v' : '';
      rows[34][index] = dailyRecord.haveSmoke ? 'v' : '';
    }

    final List<List<String>> data = [];
    data.add(header);
    for (var i = 0; i < 19; ++i) {
      data.add(rows[i]);
    }
    data.addAll(medicineRows);
    for (var i = 19; i < rows.length; ++i) {
      data.add(rows[i]);
    }

    return const ListToCsvConverter().convert(data);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> writeBackup(String text) async {
    final path = await _localPath;
    final file = File('$path/headache_app-backup.txt');
    return file.writeAsString(text);
  }

  Future<File> writeReport(int year, int month, String text) async {
    final path = await _localPath;
    final file = File('$path/headache_app-report-$year-${month.toString().padLeft(2, '0')}.csv');
    return file.writeAsString(text);
  }
}
