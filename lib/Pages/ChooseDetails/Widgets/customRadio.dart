import 'package:flutter/material.dart';

class CustomRadio extends StatelessWidget {
  final int value;
  final int groupValue;
  final Function handleChange;
  CustomRadio({this.value, this.groupValue, this.handleChange});
  @override
  Widget build(BuildContext context) {
    return Radio(
      value: value,
      groupValue: groupValue,
      onChanged: handleChange,
    );
  }
}
