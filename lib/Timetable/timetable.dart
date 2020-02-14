import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class TimeTable extends StatefulWidget {
  final List<dynamic> tt;
  final classname;
  final gradientAppbarStart;
  final gradientAppbarEnd;
  final gradientCircleStart;
  final gradientCircleEnd;

  const TimeTable(
      {Key key,
      this.tt,
      this.classname,
      this.gradientAppbarStart,
      this.gradientAppbarEnd,
      this.gradientCircleStart,
      this.gradientCircleEnd})
      : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var timeTable = widget.tt;
    var classname = widget.classname;
    var gradientAppbarStart = widget.gradientAppbarStart;
    var gradientAppbarEnd = widget.gradientAppbarEnd;
    var gradientCircleStart = widget.gradientCircleStart;
    var gradientCircleEnd = widget.gradientCircleEnd;
    // print(timeTable);
    DateTime date = DateTime.now();
    // 1 is Monday and 7 is Sunday.
    var day = date.weekday;
    //We convert it to day to 0 as Monday and so on
    day = day - 1;
    if (day > 4) day = 0;
    return DefaultTabController(
      initialIndex: day,
      length: 5,
      child: Scaffold(
        backgroundColor: Color(0xFFdddddd),
        appBar: GradientAppBar(
          backgroundColorStart: gradientAppbarStart,
          backgroundColorEnd: gradientAppbarEnd,
          bottom: TabBar(
            indicatorWeight: 2,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: 'MON',
              ),
              Tab(
                text: 'TUE',
              ),
              Tab(
                text: 'WED',
              ),
              Tab(
                text: 'THU',
              ),
              Tab(
                text: 'FRI',
              ),
            ],
          ),
          title: Text(classname + ' Time Table'),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
              // gradient: LinearGradient(
              //     begin: Alignment.topRight,
              //     end: Alignment.topLeft,
              //     stops: [0.1, 0.9],
              //     colors: [Colors.indigo[400], Colors.cyan[400]]),
              ),
          child: TabBarView(
            children: [
              schedule(timeTable[0], 0, gradientCircleStart, gradientCircleEnd),
              schedule(timeTable[1], 1, gradientCircleStart, gradientCircleEnd),
              schedule(timeTable[2], 2, gradientCircleStart, gradientCircleEnd),
              schedule(timeTable[3], 3, gradientCircleStart, gradientCircleEnd),
              schedule(timeTable[4], 4, gradientCircleStart, gradientCircleEnd),
            ],
          ),
        ),
      ),
    );
  }
}

var cached = [0, 0, 0, 0, 0, 0, 0];

// Here Timetable is list of periods that day.
Widget schedule(timetable, day, gradientAppbarStart, gradientAppbarEnd) {
  // print(timetable);
  var ttcopy = []..addAll(timetable);
  // var ttcopy = timetable;
  List<Widget> listofperiods = [];
  ttcopy.removeAt(0);

  for (int i = 0; i < ttcopy.length; i++) {
    if (ttcopy[i].split(' ')[0].contains('0') ||
        ttcopy[i].split(' ')[0].contains('1') ||
        ttcopy[i].split(' ')[0].contains('2') ||
        ttcopy[i].split(' ')[0].contains('3') ||
        ttcopy[i].split(' ')[0].contains('4'))
      ttcopy[i] = ttcopy[i].substring(ttcopy[i].indexOf(" ") + 1);

    try {
      ttcopy[i] = ttcopy[i]
          .trim()
          .toLowerCase()
          .split(' ')
          .map((s) => s[0].toUpperCase() + s.substring(1))
          .join(' ');
    } catch (_) {}
  }

  for (int i = 0; i < ttcopy.length; i++) {
    listofperiods.add(
      Container(
          margin: EdgeInsets.fromLTRB(10, 0, 15, 2),
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100),
                bottomLeft: Radius.circular(100),
                topRight: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Period Number
                Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF19AAD5),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          stops: [0.1, 0.9],
                          colors: [gradientAppbarStart, gradientAppbarEnd]),
                    ),
                    child: Center(
                        child: Text((i + 1).toString(),
                            style:
                                TextStyle(fontSize: 17, color: Colors.white)))),
                //Time Table Value
                Expanded(
                  child: Container(
                    // margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      ttcopy[i],
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF555555)),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  // print(ttcopy);
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
          ] +
          listofperiods +
          [
            SizedBox(
              height: 40.0,
            )
          ],
    ),
  );
}
