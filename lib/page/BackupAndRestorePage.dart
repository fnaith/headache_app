import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:headache_app/persistence/dailyRecord/DailyRecordDb.dart';
import 'package:headache_app/persistence/dailyRecord/DailyRecord.dart';

class BackupAndRestorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('備份還原'),
      ),
      body: _BackupAndRestorePage(),
    );
  }
}

class _BackupAndRestorePage extends StatelessWidget {
  DailyRecordDb _dailyRecordDb = DailyRecordDb();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            child: const Text('匯入檔案'),
            onPressed: () async {
              final FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['txt'],
                withData: true,
                withReadStream: true
              );
              if (null != result) {
                final PlatformFile file = result.files.first;
                if (null != file.bytes) {
                  final json = const Utf8Decoder().convert(file.bytes!);
                  log('${file.name}');
                  log('${file.size}');
                  log(":"+json);
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
              return Share.shareFiles([file.path], text: 'Headache App Backup Export');
            },
          ),
          ElevatedButton(
            child: const Text('返回首頁'),
            onPressed: () {
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
