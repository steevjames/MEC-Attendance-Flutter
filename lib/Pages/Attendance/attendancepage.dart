import 'package:flutter/material.dart';
import 'package:mec_attendance/Pages/Attendance/Widgets/customAppbar.dart';
import 'Widgets/createList.dart';
import 'package:beautifulsoup/beautifulsoup.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Timetable/timetable.dart';
import 'dart:convert';
import './convertdata.dart';
import 'package:mec_attendance/Theme/theme.dart';

class AttendancePage extends StatefulWidget {
  AttendancePage();

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  void initState() {
    getDetailsFromStorage();
    super.initState();
  }

  var rollno = 0;
  var classname = '';
  var studname = "Attendance";
  var timeTable = [];
  var noOfClassesList = [];
  var subjectAndLastUpdated;
  var noOfSubjects;

  // It will store attendance percentages.
  var studentattendance = [];
  // Wether to go back on back button press
  var goback = 0;

// This variable stores loading circle which is repaced by attendance info.
  var mainElement = <Widget>[
    SizedBox(
      height: 100.0,
    ),
    Center(
      child: SizedBox(
        height: 70.0,
        width: 70.0,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    )
  ];

  // Fetch Data from the Site
  getData() async {
    try {
      http.Response response = await http
          .get('http://attendance.mec.ac.in/view4stud.php?class=' + classname);
      var soup = Beautifulsoup(response.body.toString());
      // Converts fetched Data.
      convertData(soup);
      // Replaces loading with attendance list.
      getAttendanceFeed();
      print('--- Got Data from Website ---');
    } catch (_) {
      await Future.delayed(const Duration(seconds: 1), getData);
    }
  }

  getDetailsFromStorage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    classname = pref.getString('class');
    var rollno2 = pref.getString('rollno');
    rollno = int.parse(rollno2);

    var recoveredtimetable = pref.getString('timetable');
    if (recoveredtimetable != null) {
      timeTable = json.decode(recoveredtimetable);
    }
    // print(timeTable);
    print('--- Got Data from Storage ---');
    getData();
  }

// Controlling what happens when back button of appbar is pushed.
  onbackbutton() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('class');
    pref.remove('timetable');
    pref.remove('rollno');
    // print(pref.getString('class'));
    Navigator.pushReplacementNamed(context, '/choose');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Controls Back Button
        if (goback == 1)
          Navigator.pushReplacementNamed(
              context, '/choose'); // return true if the route to be popped
        else
          // Navigator.pushReplacementNamed(context, '/attendance');
          return true;
        return false;
      },
      child: MaterialApp(
        title: 'Attendance',
        theme: ThemeData(
          scaffoldBackgroundColor: pageBackgroundColor,
        ),
        home: Scaffold(
          appBar: customAppbar(
            classname: classname,
            onbackbutton: onbackbutton,
            studname: studname,
          ),

          // Floating button pushes timetable page if time table has been loaded.
          floatingActionButton: FloatingActionButton(
            tooltip: 'Timetable',
            onPressed: () {
              if (timeTable.length != 0)
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
          // The body of the page. The variable mainelement has the loading circle, which is replaced by list of attendance.
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      )
                    ] +
                    mainElement +
                    [SizedBox(height: 20.0)],
              ),
            ),
          ),
        ),
      ),
    );
  }

// This function switches the loading thing with the attendance.
  getAttendanceFeed() {
    setState(() {
      mainElement = <Widget>[];
      mainElement = returnListOfAttendanceInfo(studentattendance,
          subjectAndLastUpdated, noOfSubjects, noOfClassesList, context);
      if (studentattendance.length != 0) {
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

        goback = 0;
      } else {
        mainElement = <Widget>[
          Container(
              padding: EdgeInsets.all(20.0),
              alignment: Alignment.center,
              child: Text('Data With Given Details Have Not Been Entered.'))
        ];
        goback = 1;
      }
    });
  }

  // ------------------------------------------------------------------------------
  //
  //
  // THE FOLLOWING CODE CONVERTS THE DATA FETCHED FROM WEBSITE TO USUABLE DATA.
  // IT USES THE BEUTIFUL SOUP PACKAGE TO DETECT HTML TAGS.
  // TRY PRINTING VARIABLES AT ANY INSTANT TO SEE WHAT IS BEING CHANGED.
  //
  //
  //-------------------------------------------------------------------------
  // Turns Fetched page to Required Data.
  convertData(soup) {
    // tablelist stores HTML code of all the tables in the page as list of string.
    // tablelist[0] stores first table, that is, the one with all student names & attendance.
    // tablelist[1] stores the table with Subject name & Last updated.
    // tablelist[2] stores the last table, that is, the one with timetable.
    var tablelist = soup.find_all("table").map((e) => (e.outerHtml)).toList();
    studentattendance = getTableRow(tablelist[0], rollno + 1);
    if (studentattendance.length != 0) studentattendance.removeAt(0);
    noOfSubjects = studentattendance.length;
    subjectAndLastUpdated = [];
    for (int i = 0; i < noOfSubjects; i++) {
      subjectAndLastUpdated.add(getTableRow(tablelist[1], i));
    }
    if (subjectAndLastUpdated.length != 0) subjectAndLastUpdated.removeAt(0);

    // Get first row to calculate number of classes finished.
    var firstrow = getTableRow(tablelist[0], 0);
    if (firstrow.length != 0) firstrow.removeAt(0);
    if (firstrow.length != 0) firstrow.removeAt(0);
    for (int i = 0; i < firstrow.length; i++) {
      var classno = firstrow[i].split('(')[1].split(')')[0];
      var str = firstrow[i].substring(6);
      str = str.substring(0, str.length - 1);
      // noOfClassesList.add(int.parse(str));
      noOfClassesList.add(int.parse(classno));
    }
    // print(noOfClassesList);

    timeTable = [];

    //Getting Time Table
    for (int i = 0; i < 7; i++) {
      timeTable.add(getTimeTableRow(tablelist[2], i));
    }
    timeTable.removeAt(0);
    timeTable.removeAt(0);
    for (int i = 0; i < timeTable.length; i++) {
      for (int j = 3; j < timeTable[i].length; j++) {
        timeTable[i].removeAt(j);
      }
    }

    //Removes Spaces from Time Table
    for (int i = 0; i < timeTable.length; i++) {
      for (int j = 0; j < timeTable[i].length; j++) {
        // print(timeTable[i][j].trim());
        timeTable[i][j] = timeTable[i][j].trim() + ' ';
      }
      timeTable[i].removeAt(0);
      timeTable[i].removeLast();
    }
    //Removes blank Elements from Time Table
    for (int i = 0; i < timeTable.length; i++) {
      timeTable[i].removeWhere((value) => value == '');
    }

// Saves timetable to apps storage space to make available offline.
    savetimetable() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('timetable', json.encode(timeTable));
    }

    savetimetable();

    // print(studentattendance);
    // print(subjectAndLastUpdated);
  }
}
