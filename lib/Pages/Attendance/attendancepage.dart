import 'package:flutter/material.dart';
import 'package:mec_attendance/Pages/Attendance/Widgets/customAppbar.dart';
import 'package:mec_attendance/Pages/Attendance/Widgets/getData.dart';
import 'Widgets/createList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mec_attendance/Pages/Timetable/timetable.dart';
import 'package:mec_attendance/Theme/theme.dart';
import 'dart:convert';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String classname = "";
  String studname = "Attendance";
  List timeTable;
  List studentattendance;
  List subjectAndLastUpdated;
  int noOfSubjects;
  List noOfClassesList;
  // Wether to go back on back button press
  bool goback = true;

  // Content to be displayed on page
  List<Widget> pageContent = [
    Center(
      child: Container(
        margin: EdgeInsets.only(top: 110),
        height: 60.0,
        width: 60.0,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: new AlwaysStoppedAnimation<Color>(
            Colors.blue,
          ),
        ),
      ),
    )
  ];

  // This function switches the title & back function after data recieved.
  updateAppbar() {
    setState(() {
      if (studentattendance != null && studentattendance.length != 0) {
        // Convert Student Name To Title Case
        try {
          studentattendance[0] = studentattendance[0]
              .toLowerCase()
              .split(' ')
              .map((s) => s[0].toUpperCase() + s.substring(1))
              .join(' ');
        } catch (_) {}

        // Change name to student name in Appbar.
        studname = studentattendance[0];

        goback = false;
      } else {
        goback = true;
      }
    });
  }

  fetchData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    classname = pref.getString('class');
    var recoveredtimetable = pref.getString('timetable');
    if (recoveredtimetable != null) {
      timeTable = json.decode(recoveredtimetable);
    }

    // Scrape data from website
    var data = await FetchData().getData();

    setState(() {
      classname = data['classname'];
      timeTable = data['timeTable'];
      studentattendance = data['studentattendance'];
      subjectAndLastUpdated = data['subjectAndLastUpdated'];
      noOfSubjects = data['noOfSubjects'];
      noOfClassesList = data['noOfClassesList'];

      // Update in page body
      if (noOfSubjects == 0) {
        pageContent = [
          Container(
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.only(top: 100),
            alignment: Alignment.center,
            child: Text('Data With Given Details Have Not Been Entered.'),
          )
        ];
        goback = true;
      }
      // Displays fetched data
      else
        pageContent = returnListOfAttendanceInfo(studentattendance,
            subjectAndLastUpdated, noOfSubjects, noOfClassesList, context);
    });
    goback = false;

    updateAppbar();
  }

// Controlling what happens when back button of appbar is pushed.
  onbackbutton() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('class');
    pref.remove('timetable');
    pref.remove('rollno');
    Navigator.pushReplacementNamed(context, '/choose');
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Controls Back Button
        if (goback)
          Navigator.pushReplacementNamed(context, '/choose');
        else
          return true; // return true if the route to be popped
        return false;
      },
      child: Scaffold(
        backgroundColor: pageBackgroundColor,
        appBar: customAppbar(
          classname: classname,
          onbackbutton: onbackbutton,
          studname: studname,
          context: context,
        ),
        // Floating button pushes timetable page if time table has been loaded.
        floatingActionButton: FloatingActionButton(
          tooltip: 'Timetable',
          onPressed: () {
            print(timeTable);
            if (timeTable != null && timeTable.length != 0)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimeTable(
                    timeTable: timeTable,
                    classname: classname,
                  ),
                ),
              );
          },
          child: Icon(Icons.table_chart),
          backgroundColor: floatingButtonColor,
        ),
        body: Container(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    )
                  ] +
                  pageContent +
                  [
                    SizedBox(height: 20.0),
                  ],
            ),
          ),
        ),
      ),
    );
  }
}
