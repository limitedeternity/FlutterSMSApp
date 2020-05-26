import 'package:flutter/material.dart';
import 'package:fluttersmsapp/app.dart';

void main() => runApp(new SmsApp());

class SmsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "FlutterSMSApp",
      theme: new ThemeData(
        primaryColor: Colors.teal,
        accentColor: Colors.tealAccent[700],
      ),
      debugShowCheckedModeBanner: false,
      home: new Application(),
    );
  }
}
