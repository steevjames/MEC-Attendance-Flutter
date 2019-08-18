import 'package:flutter/material.dart';
import 'package:mec_attendance/chooseDetails.dart';
import './attendancepage.dart';
import './redirection.dart';
// import './timetable.dart';

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
        '/': (BuildContext context) => Redirect(),
        '/choose': (BuildContext context) => ChooseDetails(),
        '/attendance': (BuildContext context) => MyHomePage(),
      },
    );
  }
}
