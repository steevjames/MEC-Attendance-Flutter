import 'package:flutter/material.dart';
import 'package:mec_attendance/Pages/ChooseDetails/Widgets/selectClass.dart';
import 'package:mec_attendance/Pages/ChooseDetails/Widgets/selectSemester.dart';
import 'package:mec_attendance/Pages/ChooseDetails/Widgets/classToString.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mec_attendance/Widgets/fadeIn.dart';
import 'package:mec_attendance/Theme/theme.dart';

class ChooseDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChooseDetailsState();
  }
}

class _ChooseDetailsState extends State<ChooseDetails> {
  @override
  void initState() {
    getDetailsFromStorage();
    super.initState();
  }

  int _radioValue = 0;
  int _radioValue2 = 1;
  int _rollno = 0;
  int cached = 0;

  var oldSem;
  var oldBranch;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onRadio1Change(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  void onRadio2Change(int value) {
    setState(() {
      _radioValue2 = value;
    });
  }

  getDetailsFromStorage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    oldSem = pref.getInt('oldSem');
    oldBranch = pref.getInt('oldBranch');

    try {
      if (oldSem <= 5 && oldSem >= 0 && oldBranch >= 1 && oldBranch <= 8)
        setState(() {
          _radioValue = oldSem % 6;
          _radioValue2 = oldBranch % 9;
        });
    } catch (_) {}

    cached = 1;
    print('Stored Details Obtained');
  }

  onSubmit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    String cls = classToString(_radioValue, _radioValue2);

    // Saves Details - it is used to load attendance page each time.
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('class', cls);
    pref.setString('rollno', _rollno.toString());
    pref.remove('timetable');

    // Setting the selection to show when this page is again visited.
    pref.setInt('oldSem', _radioValue);
    pref.setInt('oldBranch', _radioValue2);

    Navigator.pushReplacementNamed(context, '/attendance');
  }

  @override
  Widget build(BuildContext context) {
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
                    FadeIn(
                      delay: .3,
                      child: Image.asset(
                        'assets/mec.png',
                        height: 130.0,
                        color: maincolor,
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20.0,
                          ),
                          FadeIn(
                            delay: .8,
                            child: Text(
                              'Choose Class :',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          FadeIn(
                            delay: .8,
                            child: SelectClass(
                              radioValue: _radioValue,
                              onRadio1Change: onRadio1Change,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          FadeIn(
                            delay: 1.3,
                            child: Text(
                              'Choose Semester : ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          FadeIn(
                            delay: 1.3,
                            child: SelectSemester(
                              radioValue: _radioValue2,
                              onRadio2Change: onRadio2Change,
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          FadeIn(
                            delay: 1.8,
                            child: Container(
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
                          ),
                        ],
                      ),
                    ),
                    FadeIn(
                      delay: 2.1,
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        color: maincolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                        ),
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          onSubmit();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
