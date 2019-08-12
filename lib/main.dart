import 'package:flutter/material.dart';
import 'package:mec_attendance/chooseDetails.dart';
import './attendancepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/chooseDetails': (BuildContext context) => ChooseDetails(),
        '/': (BuildContext context) => MyHomePage(), // For testing
      },
    );
  }
}
