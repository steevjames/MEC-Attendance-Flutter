import 'package:flutter/material.dart';
import 'package:mec_attendance/Pages/ChooseDetailsPage/chooseDetails.dart';
import 'package:mec_attendance/Pages/Attendance/attendancepage.dart';
import 'package:mec_attendance/Pages/Splashscreen/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (BuildContext context) => Splashscreen(),
        '/choose': (BuildContext context) => ChooseDetails(),
        '/attendance': (BuildContext context) => AttendancePage(),
      },
    );
  }
}
