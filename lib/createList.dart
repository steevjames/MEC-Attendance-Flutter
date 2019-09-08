import 'package:flutter/material.dart';

returnsList(studentattendance, subjectAndLastUpdated, length, noOfClassesList,
    context) {
  // print(noOfClassesList);
  var widgetList = <Widget>[];

  for (int i = 0; i < length - 1; i++) {
    var attendance;
    if (double.tryParse(studentattendance[i + 1]) != null)
      attendance = double.parse(studentattendance[i + 1]);
    else
      attendance = 0.0;
    var totalNoOfClasses = noOfClassesList[i];
    var attented = (attendance * totalNoOfClasses) / 100;
    var canCut = 0.0;
    var canCutText = '';
    if (attendance == 75.0) {
      canCutText = 'Perfectly Balanced As All Things Should Be !';
    } else if (attendance > 75.0) {
      canCut = (4 * attented - 3 * totalNoOfClasses) / 3;
      canCutText = 'Can Cut ' + canCut.floor().toString() + ' Classes';
    } else if (attendance == 0.0 && totalNoOfClasses == 0) {
      canCutText = '-------';
    } else {
      canCut = 3 * totalNoOfClasses - 4 * attented;
      // print(canCut);
      canCutText = 'Have to Attend ' + canCut.round().toString() + ' Classes';
    }
    var attn = '';
    if (attendance == 0.0)
      attn = '- -';
    else
      attn = attendance.toString() + '%';
    // Getting Subject Name
    var subname = subjectAndLastUpdated[i][0].toString();
    var subarray = subname.split(' ');
    subarray.removeAt(0);
    subname = subarray.join(' ');
    // print(subname);

    Widget _popupElement(t1, t2) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                0.1,
                0.9
              ],
              colors: [
                (attendance >= 75 || (attendance == 0 && totalNoOfClasses==0))
                    ? Color(0xFF19AAD5)
                    : Color(0xFFaa0000),
                (attendance >= 75 || (attendance == 0 && totalNoOfClasses==0))
                    ? Color(0xFF3255AC)
                    : Color(0xFF330000),
              ]),
        ),
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              t1,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              t2,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      );
    }

    widgetList.add(
      InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                title: Text(
                  subname,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, shadows: [
                    BoxShadow(
                      color: Color(0x88000000),
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                    )
                  ]),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          width: 75.0,
                          height: 75.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF555555),
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                              )
                            ],
                          ),
                          child: Center(
                              child: Text(
                            attn.toString(),
                            style: TextStyle(fontSize: 17, shadows: [
                              BoxShadow(
                                color: Color(0x88000000),
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                              )
                            ]),
                          )),
                        ),
                      ),
                      _popupElement('Classes Attended',
                          ': ' + attented.toStringAsFixed(0)),
                      _popupElement('Total No. of Classes',
                          ': ' + totalNoOfClasses.toString()),
                      _popupElement(
                          'Last Updated', ': ' + subjectAndLastUpdated[i][1]),
                      SizedBox(height: 10),
                      Center(
                          child: Text(
                        canCutText,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                            shadows: [
                              BoxShadow(
                                color: Color(0x88000000),
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                              )
                            ]),
                      )),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      "Close",
                      style: TextStyle(
                          // color: Colors.black54,
                          fontSize: 12,
                          shadows: [
                            BoxShadow(
                              color: Color(0x885555ff),
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                            )
                          ]),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 10, 5, 5),
            margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              // gradient: LinearGradient(
              //     begin: Alignment.topRight,
              //     end: Alignment.bottomLeft,
              //     stops: [0.1, 0.9],
              //     colors: [Colors.indigo, Colors.cyan]),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            subname,
                            style: TextStyle(
                                color: Color(0xFF555555), fontSize: 17.0),
                          ),
                        ),
                        Container(
                          color: Colors.green,
                          height: 1.2,
                          width: 500,
                          margin: EdgeInsets.only(
                              left: 10, right: 5, top: 5, bottom: 5),
                        ),

                        //Have to Attend / Cut
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              // margin: EdgeInsets.only(left: 10.0),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              decoration: BoxDecoration(
                                // color: Color(0xFF2680C1),
                                borderRadius: BorderRadius.circular(50.0),
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    stops: [
                                      0.1,
                                      0.9
                                    ],
                                    colors: [
                                      (attendance >= 75 || (attendance == 0 && totalNoOfClasses==0))
                                          ? Color(0xFF19AAD5) //Blue Left
                                          : Color(0xFFaa0000), // Red
                                      (attendance >= 75 || (attendance == 0 && totalNoOfClasses==0))
                                          ? Color(0xFF3255AC) // Blue Right
                                          : Color(0xFF330000),
                                    ]),
                              ),
                              child: Text(
                                canCutText,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 3,
                        ),

                        //Last Updated
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          child: Text(
                            'Last Updated : ' + subjectAndLastUpdated[i][1],
                            style: TextStyle(
                              color: Color(0xFF777777),
                              fontSize: 12,
                            ),
                            // textAlign: TextAlign.center,
                          ),
                        ),
                      ]),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  width: 75.0,
                  height: 75.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF555555),
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                      )
                    ],
                  ),
                  child: Center(
                      child: Text(
                    attn.toString(),
                    style: TextStyle(fontSize: 17, shadows: [
                      BoxShadow(
                        color: Color(0x88000000),
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                      )
                    ]),
                  )),
                ),
              ],
            )),
      ),
    );
  }
  return widgetList;
}
