import 'package:flutter/material.dart';
import './createList.dart';
import 'package:beautifulsoup/beautifulsoup.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var rollno = 56;
  var classname = 'C5A';
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
      var tablerows =
          tablelistdoc.find_all("tr").map((e) => (e.outerHtml)).toList()[row];
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
      studentattendance.removeAt(0);
      var noOfSubjects = studentattendance.length;
      var subjectAndLastUpdated = [];
      for (int i = 0; i < noOfSubjects; i++) {
        subjectAndLastUpdated.add(getTableRow(tablelist[1], i));
      }
      subjectAndLastUpdated.removeAt(0);

      setState(() {
        mainElement = <Widget>[];
        mainElement = returnsList(studentattendance, subjectAndLastUpdated,
            noOfSubjects - 1, context);
        studname = studentattendance[0];
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
    }

    getData();

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
            children: <Widget>[SizedBox(height: 10.0,)]+mainElement,
          ),
        ));
  }
}
