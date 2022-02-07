import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('幫助訊息'),
        centerTitle: true
      ),
      body: _HelpPage(),
    );
  }
}

class _HelpPage extends StatelessWidget {
  final String version = 'Beta 1.0.0';
  final String releaseDate = '2022/02/03';
  final String email = 'weichih.fr.lai@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(alignment: Alignment.centerLeft, child: Text('程式版本 : $version')),
          Align(alignment: Alignment.centerLeft, child: Text('發行日期 : $releaseDate')),
          ElevatedButton(
            child: const Text('複製信箱'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: email));
              const snackBar = SnackBar(
                  content: Text('複製成功')
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          ElevatedButton(
            child: const Text('寄信聯絡'),
            onPressed: () {
              Share.share('From\n${getDeviceInfo()}請留下您的訊息 : ', subject: '頭痛 App 寄信聯絡');
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
    );
  }

  String getDeviceInfo() {
    return '程式版本 : $version\n發行日期 : $releaseDate\n作業系統${Platform.operatingSystemVersion}\n';
  }
}
