import 'package:flutter/material.dart';
import 'package:mec_attendance/NotificationHandler/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mec_attendance/Theme/theme.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  getDetailsFromStorage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var classname = pref.getString('class');
    var rollno2 = pref.getString('rollno');
    if (classname == null || rollno2 == null)
      Navigator.pushReplacementNamed(context, '/choose');
    else
      Navigator.pushReplacementNamed(context, '/attendance');
  }

  @override
  void initState() {
    setUpNotifications();
    Future.delayed(const Duration(milliseconds: 500), () {
      getDetailsFromStorage();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.9],
            colors: [splashGradientStart, splashGradientEnd],
          ),
        ),
        child: Center(
          child: Image(
            image: AssetImage('assets/mec.png'),
            width: 225,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
