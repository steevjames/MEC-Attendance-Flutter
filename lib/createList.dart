import 'package:flutter/material.dart';

returnsList(studentattendance, subjectAndLastUpdated, length, context) {
  var widgetList = <Widget>[];
  for (int i = 0; i < length - 1; i++) {
    widgetList.add(
      Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(children: <Widget>[
          Text(
            subjectAndLastUpdated[i][0].toString().substring(5),
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
          Expanded(
            child: Text(
              ':    ' + studentattendance[i + 1] + ' %',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              textAlign: TextAlign.right,
            ),
          ),
        ]),
      ),
    );
  }
  return widgetList;
}
