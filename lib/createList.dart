import 'package:flutter/material.dart';

returnsList(studentattendance, subjectAndLastUpdated, length, noOfClassesList,
    context) {
  // print(subjectAndLastUpdated);
  var widgetList = <Widget>[];

  for (int i = 0; i < length - 1; i++) {
    var attendance;
    attendance = double.parse(studentattendance[i + 1]);
    var totalNoOfClasses = noOfClassesList[i];
    var attented = attendance * totalNoOfClasses;
    var canCut = 0.0;
    var canCutText = '';
    if (attendance == 75.00) {
      canCutText = 'Perfectly Balanced as all things should be !';
    } else if (attendance > 75) {
      canCut = (4 * attented - 3 * totalNoOfClasses) / 3;
      canCutText = 'Can Cut ' + canCut.round().toString() + ' Classes';
    } else {
      canCut = 3 * totalNoOfClasses - 4 * attented;
      canCutText = 'Have to Attend ' + canCut.round().toString() + ' Classes';
    }
    widgetList.add(
      Container(
          padding: EdgeInsets.fromLTRB(0, 10, 3, 10),
          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            // gradient: LinearGradient(
            //     begin: Alignment.topRight,
            //     end: Alignment.bottomLeft,
            //     stops: [0.1, 0.9],
            //     colors: [Colors.indigo, Colors.cyan]),
          ),
          child: Row(
            children: <Widget>[
              RawMaterialButton(
                onPressed: () {},
                child: Text(
                  studentattendance[i + 1] + '%',
                  style: TextStyle(fontSize: 17),
                ),
                shape: new CircleBorder(),
                elevation: 3.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(25.0),
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        subjectAndLastUpdated[i][0].toString().substring(5),
                        // textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Color(0xFF555555), fontSize: 18.0),
                      ),
                      Container(
                        color: Colors.green,
                        height: 1.2,
                        width: 500,
                        margin: EdgeInsets.all(5.0),
                      ),

                      //Have to Attend / Cut
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          // color: Color(0xFF2680C1),
                          borderRadius: BorderRadius.circular(50.0),
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              stops: [0.1, 0.9],
                              colors: [Color(0xFF5599dd), Color(0xFF4466BB)]),
                        ),
                        child: Text(
                          canCutText,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),

                      //Last Updated
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(width: .5, color: Color(0xFF555555)),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          'Last Updated : ' + subjectAndLastUpdated[i][1],
                          style: TextStyle(color: Color(0xFF777777)),
                        ),
                      ),
                      // Text('No. of Classes :' + noOfClassesList[i].toString()),
                      Text(''),
                    ]),
              ),
            ],
          )),
    );
  }
  return widgetList;
}
