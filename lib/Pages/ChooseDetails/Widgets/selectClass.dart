import 'package:flutter/material.dart';
import 'package:mec_attendance/Pages/ChooseDetails/Widgets/customRadio.dart';
import 'package:mec_attendance/Theme/theme.dart';

class SelectClass extends StatelessWidget {
  final int radioValue;
  final Function onRadio1Change;
  SelectClass({this.radioValue, this.onRadio1Change});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.2, color: maincolor),
      ),
      margin: EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomRadio(
                value: 0,
                groupValue: radioValue,
                handleChange: onRadio1Change,
              ),
              Text('CSA'),
              CustomRadio(
                value: 1,
                groupValue: radioValue,
                handleChange: onRadio1Change,
              ),
              Text('CSB'),
              CustomRadio(
                value: 2,
                groupValue: radioValue,
                handleChange: onRadio1Change,
              ),
              Text('EEE'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomRadio(
                value: 3,
                groupValue: radioValue,
                handleChange: onRadio1Change,
              ),
              Text('ECA'),
              CustomRadio(
                value: 4,
                groupValue: radioValue,
                handleChange: onRadio1Change,
              ),
              Text('ECB'),
              CustomRadio(
                value: 5,
                groupValue: radioValue,
                handleChange: onRadio1Change,
              ),
              Text('EB'),
            ],
          ),
        ],
      ),
    );
  }
}
