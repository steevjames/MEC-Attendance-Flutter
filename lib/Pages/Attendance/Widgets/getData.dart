import 'package:beautifulsoup/beautifulsoup.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'convertdata.dart';

class FetchData {
  var rollno = 0;
  var classname = '';
  var studname = "Attendance";
  var timeTable = [];
  var noOfClassesList = [];
  var subjectAndLastUpdated;
  var noOfSubjects;
  var studentattendance = [];

// Fetch Data from the Site
  getData() async {
    print("Trying to get Data");

    // Data from storage
    SharedPreferences pref = await SharedPreferences.getInstance();
    var classname = pref.getString('class');
    var rollno2 = pref.getString('rollno');
    rollno = int.parse(rollno2);
    // print(timeTable);
    print('--- Got Data from Storage ---');

    var response = await fetchDataFromNet(classname);
    var soup = Beautifulsoup(response.body.toString());
    // Converts fetched Data.
    convertData(soup);
    // Replaces loading with attendance list.
    print('--- Got Data from Website ---');

    return {
      "rollno": rollno,
      "classname": classname,
      "timeTable": timeTable,
      "noOfClassesList": noOfClassesList,
      "subjectAndLastUpdated": subjectAndLastUpdated,
      "noOfSubjects": noOfSubjects,
      "studentattendance": studentattendance
    };
  }

  // Fetches data from net.
  fetchDataFromNet(classname) async {
    try {
      http.Response response = await http
          .get('http://attendance.mec.ac.in/view4stud.php?class=' + classname);

      return response;
    } catch (_) {
      return await Future.delayed(const Duration(seconds: 2), () {
        return fetchDataFromNet(classname);
      });
    }
  }

// ------------------------------------------------------------------------------
//
// THE FOLLOWING CODE CONVERTS THE DATA FETCHED FROM WEBSITE TO USUABLE DATA.
// IT USES THE BEUTIFUL SOUP PACKAGE TO DETECT HTML TAGS.
// TRY PRINTING VARIABLES AT ANY INSTANT TO SEE WHAT IS BEING CHANGED.
//
//------------------------------------------------------------------------------
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
