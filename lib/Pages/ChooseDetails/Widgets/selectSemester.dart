import 'package:flutter/material.dart';
import 'package:mec_attendance/Pages/ChooseDetails/Widgets/customRadio.dart';
import 'package:mec_attendance/Theme/theme.dart';

class SelectSemester extends StatelessWidget {
  final int radioValue;
  final Function onRadio2Change;
  SelectSemester({this.radioValue, this.onRadio2Change});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.2, color: maincolor),
      ),
      margin: EdgeInsets.all(5.0),
      alignment: Alignment.center,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomRadio(
                value: 1,
                groupValue: radioValue,
                handleChange: onRadio2Change,
              ),
              Text('1'),
              CustomRadio(
                value: 2,
                groupValue: radioValue,
                handleChange: onRadio2Change,
              ),
              Text('2'),
              CustomRadio(
                value: 3,
                groupValue: radioValue,
                handleChange: onRadio2Change,
              ),
              Text('3'),
              CustomRadio(
                value: 4,
                groupValue: radioValue,
                handleChange: onRadio2Change,
              ),
              Text('4'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomRadio(
                value: 5,
                groupValue: radioValue,
                handleChange: onRadio2Change,
              ),
              Text('5'),
              CustomRadio(
                value: 6,
                groupValue: radioValue,
                handleChange: onRadio2Change,
              ),
              Text('6'),
              CustomRadio(
                value: 7,
                groupValue: radioValue,
                handleChange: onRadio2Change,
              ),
              Text('7'),
              CustomRadio(
                value: 8,
                groupValue: radioValue,
                handleChange: onRadio2Change,
              ),
              Text('8'),
            ],
          ),
        ],
      ),
    );
  }
}
