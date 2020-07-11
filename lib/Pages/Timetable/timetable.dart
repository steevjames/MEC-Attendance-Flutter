import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:mec_attendance/Widgets/fadeIn.dart';
import 'package:mec_attendance/Theme/theme.dart';
import './Widgets/singleDaySchedule.dart';

class TimeTable extends StatefulWidget {
  final List<dynamic> timeTable;
  final classname;

  TimeTable({this.timeTable, this.classname});

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var timeTable = widget.timeTable;
    var classname = widget.classname;

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
        backgroundColor: Color(0xFFeeeeee),
        appBar: GradientAppBar(
          gradient:
              LinearGradient(colors: [gradientAppbarStart, gradientAppbarEnd]),
          bottom: TabBar(
            labelStyle: TextStyle(fontFamily: fontName),
            indicatorWeight: 3,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: 'Mon',
              ),
              Tab(
                text: 'Tue',
              ),
              Tab(
                text: 'Wed',
              ),
              Tab(
                text: 'Thu',
              ),
              Tab(
                text: 'Fri',
              ),
            ],
          ),
          title: FadeIn(
            delay: .3,
            child: Text(
              classname + ' Timetable',
              style: TextStyle(fontFamily: fontName),
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          child: TabBarView(
            children: [
              Schedule(timetable: timeTable[0], day: 0),
              Schedule(timetable: timeTable[1], day: 1),
              Schedule(timetable: timeTable[2], day: 2),
              Schedule(timetable: timeTable[3], day: 3),
              Schedule(timetable: timeTable[4], day: 4),
            ],
          ),
        ),
      ),
    );
  }
}
