import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:async';

class Redirect extends StatefulWidget {
  Redirect();

  @override
  _RedirectState createState() => _RedirectState();
}

class _RedirectState extends State<Redirect> {
  getDetailsFromStorage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var classname = pref.getString('class');
    var rollno2 = pref.getString('rollno');
    if (classname == null || rollno2 == null)
      Navigator.pushReplacementNamed(context, '/choose');
    else
      Navigator.pushReplacementNamed(context, '/attendance');
  }

  Widget build(BuildContext context) {
    getDetailsFromStorage();

    return Center();
  }
}

// class HomePage extends StatelessWidget {
//   Future<bool> _onWillPop() {
//     //Do action Here
//     print('hey');
//     return 1 ?? false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Text("Home Page"),
//     );
//   }
// }
