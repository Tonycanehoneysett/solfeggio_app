import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Wellness',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Audio Wellness'),
        ),
        body: Center(
 body: Center(
  child: Image.asset(
    'assets/icon/app_icon.png',
    fit: BoxFit.cover,
    width: double.infinity,
    height: double.infinity,
  ),
),
    );
  }
}
