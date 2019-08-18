import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class Tt extends StatefulWidget {
  final List<dynamic> tt;
  final classname;

  const Tt({Key key, this.tt, this.classname}) : super(key: key);

  @override
  _TtState createState() => _TtState();
}

class _TtState extends State<Tt> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var timeTable = widget.tt;
    var classname = widget.classname;
    // print(timeTable);
    DateTime date = DateTime.now();
    // 1 is Monday and 7 is Sunday.
    var day = date.weekday;
    //We convert it to day to 0 as Monday
    day = day - 1;
    if (day > 4) day = 0;
    // print(day);
    return DefaultTabController(
      initialIndex: day,
      length: 5,
      child: Scaffold(
        backgroundColor: Color(0xFFdddddd),
        appBar: GradientAppBar(
          backgroundColorStart: Colors.cyan,
          backgroundColorEnd: Colors.indigo,
          bottom: TabBar(
            indicatorWeight: 5,
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
              schedule(timeTable[0], 0),
              schedule(timeTable[1], 1),
              schedule(timeTable[2], 2),
              schedule(timeTable[3], 3),
              schedule(timeTable[4], 4),
            ],
          ),
        ),
      ),
    );
  }
}

var cached = [0, 0, 0, 0, 0, 0, 0];

// Here Timetable is list of periods that day.
Widget schedule(timetable, day) {
  // print(timetable);
  var ttcopy = []..addAll(timetable);
  // var ttcopy = timetable;
  List<Widget> listofperiods = [];
  ttcopy.removeAt(0);

  for (int i = 0; i < ttcopy.length; i++) {
    ttcopy[i] = ttcopy[i].substring(ttcopy[i].indexOf(" ") + 1);
  }

  for (int i = 0; i < ttcopy.length; i++) {
    listofperiods.add(
      Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: Text((i + 1).toString() + '.  ' + ttcopy[i]),
      ),
    );
  }

  // print(ttcopy);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
          SizedBox(
            height: 50.0,
          ),
        ] +
        listofperiods,
  );
}
