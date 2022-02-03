import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'page/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '頭痛醫療日記',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: '頭痛醫療日記'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('zh', 'TW')
      ]
    );
  }
}
