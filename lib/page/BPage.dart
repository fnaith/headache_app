import 'package:flutter/material.dart';

class BPage extends StatelessWidget {
  const BPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我是 B 頁'),
        centerTitle: true
      ),
      body: _BPage(),
    );
  }
}

class _BPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('返回首頁'),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    );
  }
}
