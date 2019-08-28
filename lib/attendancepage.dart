import 'package:flutter/material.dart';
import './createList.dart';
import 'package:beautifulsoup/beautifulsoup.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './timetable.dart';
import 'dart:convert';


class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var cached = 0;
  var rollno = 0;
  var classname = '';
  var studname = "Attendance";
  var timeTable = [];
  var noOfClassesList = [];

  var mainElement = <Widget>[
    SizedBox(
      height: 100.0,
    ),
    Center(
        child: SizedBox(
            height: 70.0, width: 70.0, child: CircularProgressIndicator()))
  ];
  var studentattendance = [];
  var goback = 0;

  @override
  Widget build(BuildContext context) {
    // 1st Argument : Table, 2nd Argument : Required Row
    getTableRow(tablelist, row) {
      var tablelistdoc = Beautifulsoup(tablelist);
      var tablerows2 =
          tablelistdoc.find_all("tr").map((e) => (e.outerHtml)).toList();
      var tablerows = '';
      if (tablerows2.length > row)
        tablerows = tablerows2[row];
      else
        tablerows = '';
      var tabledoc = Beautifulsoup(tablerows).get_text();
      var tabledoclist = tabledoc.split('\n');
      for (int i = 0; i < tabledoclist.length; i++)
        tabledoclist[i] = tabledoclist[i].trim();

      tabledoclist.removeWhere((value) => value == '');
      return tabledoclist;
    }

    getTimeTableRow(tablelist, row) {
      var tablelistdoc = Beautifulsoup(tablelist);
      var tablerows2 =
          tablelistdoc.find_all("tr").map((e) => (e.outerHtml)).toList();
      var tablerows = '';
      if (tablerows2.length > row)
        tablerows = tablerows2[row];
      else
        tablerows = '';
      var tabledoc = Beautifulsoup(tablerows).get_text();
      var tabledoclist = tabledoc.split('\n');
      // for (int i = 0; i < tabledoclist.length; i++)
      //   tabledoclist[i] = tabledoclist[i].trim();

      // tabledoclist.removeWhere((value) => value == '');
      return tabledoclist;
    }

//Turn Fetched page to Required Data
    convertData(soup) {
      var tablelist = soup.find_all("table").map((e) => (e.outerHtml)).toList();
      studentattendance = getTableRow(tablelist[0], rollno + 1);
      // print(studentattendance);
      if (studentattendance.length != 0) studentattendance.removeAt(0);
      var noOfSubjects = studentattendance.length;
      var subjectAndLastUpdated = [];
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

      timeTable=[];

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

      // if (timeTable.length != 0) timeTable.removeAt(0);
      // print(timeTable);

      savetimetable() async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('timetable', json.encode(timeTable));
      }
      savetimetable();

      setState(() {
        mainElement = <Widget>[];
        mainElement = returnsList(studentattendance, subjectAndLastUpdated,
            noOfSubjects, noOfClassesList, context);
        if (studentattendance.length != 0) {
          // Convert Name To Title Case
          studentattendance[0] = studentattendance[0]
              .toLowerCase()
              .split(' ')
              .map((s) => s[0].toUpperCase() + s.substring(1))
              .join(' ');
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

      // print(studentattendance);
      // print(subjectAndLastUpdated);
    }

    // Fetch Data from the Site
    getData() async {
      http.Response response = await http
          .get('http://attendance.mec.ac.in/view4stud.php?class=' + classname);
      var soup = Beautifulsoup(response.body.toString());
      convertData(soup);
      print('Web Data ...');
    }

    getDetailsFromStorage() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      classname = pref.getString('class');
      var rollno2 = pref.getString('rollno');
      rollno = int.parse(rollno2);

      var recoveredtimetable = pref.getString('timetable');
      if(recoveredtimetable!=null) {
        timeTable= json.decode(recoveredtimetable);
      }
      print(timeTable);
      print('Storage Data...');
      getData();
    }

    if (cached == 0) {
      cached = 1;
      getDetailsFromStorage();
    }

    onbackbutton() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove('class');
      pref.remove('timetable');
      pref.remove('rollno');
      // print(pref.getString('class'));
      Navigator.pushReplacementNamed(context, '/choose');
    }

    return WillPopScope(
      onWillPop: () async {
        // await showDialog or Show add banners or whatever
        // then
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
          scaffoldBackgroundColor: Color(0xFFe7e7e7),
        ),
        home: Scaffold(
          appBar: GradientAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: onbackbutton,
            ),
            centerTitle: true,
            title: Text(
              studname,
              style: TextStyle(fontSize: 19.0),
            ),
            backgroundColorStart: Colors.cyan,
            backgroundColorEnd: Colors.indigo,
          ),
          // backgroundColor: Color(0xFFe7e7e7),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (timeTable.length != 0)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Tt(
                      tt: timeTable,
                      classname: classname,
                    ),
                  ),
                );
            },
            child: Icon(Icons.table_chart),
            backgroundColor: Color(0xFF2680C1),
          ),
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
}
