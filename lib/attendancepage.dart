import 'package:flutter/material.dart';
import './createList.dart';
import 'package:beautifulsoup/beautifulsoup.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './timetable.dart';

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
  Function floatingButtonAction = () {};

  var mainElement = <Widget>[
    SizedBox(height: 100.0,),
    Center(
        child: SizedBox(
            height: 70.0, width: 70.0, child: CircularProgressIndicator()))
  ];
  var studentattendance = [];

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

//Removes Spaces
      for (int i = 0; i < timeTable.length; i++) {
        for (int j = 0; j < timeTable[i].length; j++) {
          timeTable[i][j] = timeTable[i][j].trim();
        }
      }
//Removes blank Elements
      for (int i = 0; i < timeTable.length; i++) {
        timeTable[i].removeWhere((value) => value == '');
      }

      // if (timeTable.length != 0) timeTable.removeAt(0);
      // print(timeTable);

      setState(() {
        mainElement = <Widget>[];
        mainElement = returnsList(
            studentattendance, subjectAndLastUpdated, noOfSubjects, context);
        if (studentattendance.length != 0)
          studname = studentattendance[0];
        else
          mainElement = <Widget>[
            Container(
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: Text('Student with current details caanot be found'))
          ];

        //Remapping Floating Button
        floatingButtonAction = () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Tt(
                tt: timeTable,
                classname: classname,
              ),
            ),
          );
        };
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
      pref.remove('rollno');
      // print(pref.getString('class'));
      Navigator.pushReplacementNamed(context, '/choose');
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: onbackbutton,
        ),
        centerTitle: true,
        title: Text(
          studname,
          style: TextStyle(fontSize: 19.0),
        ),
      ),
      backgroundColor: Color(0xFFe7e7e7),
      floatingActionButton: FloatingActionButton(
        onPressed: floatingButtonAction,
        child: Icon(Icons.ac_unit),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
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
    );
  }
}