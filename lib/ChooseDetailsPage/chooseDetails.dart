import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var maincolor=Colors.blue;

class ChooseDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChooseDetailsState();
  }
}

class _ChooseDetailsState extends State<ChooseDetails> {
  int _radioValue = 0;
  int _radioValue2 = 1;
  int _rollno = 0;
  int cached = 0;


  var oldSem;
  var oldBranch;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  void _handleRadioValueChange2(int value) {
    setState(() {
      _radioValue2 = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    getDetailsFromStorage() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      oldSem = pref.getInt('oldSem');
      oldBranch = pref.getInt('oldBranch');

      try {
        if(oldSem<=5 && oldSem >=0 && oldBranch>=1 && oldBranch <=8)
        setState(() {
          _radioValue = oldSem % 6;
          _radioValue2 = oldBranch % 9;
        });
      } catch (_) {}

      cached = 1;
      print('Stored Details Obtained');
    }

    if (cached == 0) getDetailsFromStorage();

    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: ListView(
            padding: const EdgeInsets.all(25.0),
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(3.0),
                alignment: Alignment.center,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/mec.png',
                        height: 130.0,
                        color: maincolor,
                        // width: 200.0,
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              'Choose Class :',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            _selectClass(),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              'Choose Semester : ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            _selectSemester(),
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              width: 220.0,
                              child: TextFormField(
                                maxLength: 2,
                                validator: (String value) {
                                  final n = num.tryParse(value);
                                  if (n == null || n < 0) {
                                    return 'Input is not a valid Roll Number';
                                  }
                                  _rollno = n;
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Roll No.',
                                  icon: Icon(Icons.event),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      RaisedButton(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        color: maincolor,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15.0)),
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }
                          var cls = makeClassString();

                          // Saves Details - it is used to load attendance page each time.
                          saveDetails() async {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString('class', cls);
                            pref.setString('rollno', _rollno.toString());
                            pref.remove('timetable');

                            // Setting the selection to show when this page is again visited.
                            pref.setInt('oldSem', _radioValue);
                            pref.setInt('oldBranch', _radioValue2);
                            Navigator.pushReplacementNamed(
                                context, '/attendance');
                          }

                          saveDetails();
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget _selectClass() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.5, color: maincolor),
        // borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: 0,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              Text('CSA'),
              Radio(
                value: 1,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              Text('CSB'),
              Radio(
                value: 2,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              Text('EEE'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: 3,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              Text('ECA'),
              Radio(
                value: 4,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              Text('ECB'),
              Radio(
                value: 5,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              Text('EB'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _selectSemester() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.5, color: maincolor),
        // borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.all(5.0),
      alignment: Alignment.center,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: 1,
                groupValue: _radioValue2,
                onChanged: _handleRadioValueChange2,
              ),
              Text('1'),
              Radio(
                value: 2,
                groupValue: _radioValue2,
                onChanged: _handleRadioValueChange2,
              ),
              Text('2'),
              Radio(
                value: 3,
                groupValue: _radioValue2,
                onChanged: _handleRadioValueChange2,
              ),
              Text('3'),
              Radio(
                value: 4,
                groupValue: _radioValue2,
                onChanged: _handleRadioValueChange2,
              ),
              Text('4'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: 5,
                groupValue: _radioValue2,
                onChanged: _handleRadioValueChange2,
              ),
              Text('5'),
              Radio(
                value: 6,
                groupValue: _radioValue2,
                onChanged: _handleRadioValueChange2,
              ),
              Text('6'),
              Radio(
                value: 7,
                groupValue: _radioValue2,
                onChanged: _handleRadioValueChange2,
              ),
              Text('7'),
              Radio(
                value: 8,
                groupValue: _radioValue2,
                onChanged: _handleRadioValueChange2,
              ),
              Text('8'),
            ],
          ),
        ],
      ),
    );
  }

  makeClassString() {
    var cls = '';

    if (_radioValue.toString() == '0' || _radioValue.toString() == '1') {
      cls = cls + 'C';
      cls = cls + _radioValue2.toString();
      if (_radioValue.toString() == '0')
        cls = cls + 'A';
      else
        cls = cls + 'B';
    }
    if (_radioValue.toString() == '3' || _radioValue.toString() == '4') {
      cls = cls + 'E';
      cls = cls + _radioValue2.toString();
      if (_radioValue.toString() == '3')
        cls = cls + 'A';
      else
        cls = cls + 'B';
    }

    if (_radioValue.toString() == '2') {
      cls = 'EE' + _radioValue2.toString();
    }

    if (_radioValue.toString() == '5') {
      cls = 'B' + _radioValue2.toString();
    }
    return cls;
  }
}
