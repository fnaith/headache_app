import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:headache_app/persistence/dailyRecord/DailyRecordDb.dart';
import 'package:headache_app/persistence/dailyRecord/DailyRecord.dart';

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
      appBar: AppBar(
        title: const Text('備份還原'),
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
            child: const Text('匯出檔案'),
            onPressed: () async {
              final List<DailyRecord> dailyRecords = await _dailyRecordDb.findAll();
              final String json = jsonEncode(dailyRecords.map((dailyRecord) => dailyRecord.toMap()).toList());
              final file = await writeText(json);
              return Share.shareFiles([file.path], subject: 'Headache App Backup Export', text: 'Export Date : ${DateTime.now()}');
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

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/headache_app-backup.txt');
  }

  Future<File> writeText(String text) async {
    final file = await _localFile;
    return file.writeAsString(text);
  }
}
