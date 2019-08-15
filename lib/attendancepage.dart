import 'package:flutter/material.dart';
import './createList.dart';
import 'package:beautifulsoup/beautifulsoup.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  var mainElement = <Widget>[
    Image.asset('assets/load.gif'),
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

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            studname,
            style: TextStyle(fontSize: 19.0),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  )
                ] +
                mainElement,
          ),
        ));
  }
}
