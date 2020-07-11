String classToString(_radioValue, _radioValue2) {
  String cls = '';

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
