import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChooseDetailsState();
  }
}

class _ChooseDetailsState extends State<ChooseDetails> {
  // final TextEditingController _inputControl = TextEditingController();
  int _radioValue = 0;
  int _radioValue2 = 1;
  int _rollno = 0;

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
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('MEC Attendance(Early Stage)'),
      //   centerTitle: true,
      //   backgroundColor: Colors.blue,
      // ),
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
                        height: 150.0,
                        // width: 200.0,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text('Choose Class :'),
                      _selectClass(),
                      Text('Choose Semester : '),
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
                          // onChanged: (String val) {
                          //   _rollno = int.parse(val);
                          // },
                          // controller: _inputControl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            // labelText: 'Roll No',
                            hintText: 'Roll No.',
                            icon: Icon(Icons.event),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        child: Text('SUBMIT', style: TextStyle(color: Colors.white),),
                        onPressed: () {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }

                          var cls = makeClassString();

                          // Saves Details when called.
                          saveDetails() async {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString('class', cls);
                            pref.setString('rollno', _rollno.toString());
                            // print('Final Class Name :' + cls);
                            Navigator.pushNamed(context, '/attendance');
                          }

                          saveDetails();
                        },
                      )
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
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.blue),
        borderRadius: BorderRadius.circular(20.0),
      ),
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
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.blue),
        borderRadius: BorderRadius.circular(20.0),
      ),
      alignment: Alignment.center,
      width: double.infinity,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
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
