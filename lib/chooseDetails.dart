import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text('MEC Attendance'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
          alignment: Alignment.center,
          child: ListView(
            padding: const EdgeInsets.all(25.0),
            children: <Widget>[
              Image.asset(
                'assets/mec.png',
                height: 150.0,
                width: 150.0,
              ),
              Container(
                margin: const EdgeInsets.all(3.0),
                alignment: Alignment.center,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(5.0)),
                      Text('Choose Class :'),
                      _selectClass(),
                      Text('Choose Semester : '),
                      _selectSemester(),
                      TextFormField(
                        validator: (String value) {
                          final n = num.tryParse(value);
                          if (n == null || n<0) {
                            return 'Input is not a valid Roll Number';
                          }
                          _rollno=n;
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
                      Padding(padding: EdgeInsets.all(15.0)),
                      RaisedButton(
                        child: Text('Submit'),
                        onPressed: () {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }
                          print('\n\nClass Number: ' +
                              _radioValue.toString() +
                              '\nSemester : ' +
                              _radioValue2.toString() +
                              '\nRoll No : ' +
                              _rollno.toString() +
                              '\n\n');
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
      // decoration: BoxDecoration(color: Colors.red),
      alignment: Alignment.center,
      width: double.infinity,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
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
      // decoration: BoxDecoration(color: Colors.red),
      alignment: Alignment.center,
      width: double.infinity,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
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
}
