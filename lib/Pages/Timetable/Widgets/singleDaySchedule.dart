import 'package:flutter/material.dart';
import 'package:mec_attendance/Widgets/fadeIn.dart';
import 'package:mec_attendance/Theme/theme.dart';

class Schedule extends StatelessWidget {
  final timetable;
  final int day;
  Schedule({this.timetable, this.day});
  // Here Timetable is list of periods that day.
  @override
  Widget build(BuildContext context) {
    // print(timetable);
    var ttcopy = []..addAll(timetable);
    ttcopy.removeAt(0);

// Checks for course code in name & removes it, Makes it title case
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
              SizedBox(
                height: 25.0,
              ),
            ] +
            // listofperiods +
            List.generate(
              ttcopy.length,
              (i) => FadeIn(
                delay: i / 6.0 + .2,
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 15, 2),
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xffaaaaaa),
                          blurRadius: 3.0,
                          spreadRadius: -1.0,
                        )
                      ],
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
                                  stops: [
                                    0.1,
                                    0.9
                                  ],
                                  colors: [
                                    gradientTimetableCircleStart,
                                    gradientTimetableCircleEnd
                                  ]),
                            ),
                            child: Center(
                                child: Text((i + 1).toString(),
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: fontName,
                                        color: Colors.white)))),
                        //Time Table Value
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 5.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Text(
                              ttcopy[i],
                              style: TextStyle(
                                  fontSize: 14.5,
                                  fontFamily: fontName,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF555555)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ) +
            [
              SizedBox(
                height: 40.0,
              )
            ],
      ),
    );
  }
}
