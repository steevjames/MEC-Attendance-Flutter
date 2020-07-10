import 'package:flutter/material.dart';
import 'package:mec_attendance/Theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

customAppbar({classname, onbackbutton, studname}) {
  _launchURL(url) async {
    if (await canLaunch(url) && url != '') {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  return GradientAppBar(
    actions: <Widget>[
      PopupMenuButton(
        onSelected: (val) {
          if (val == 1)
            _launchURL(
                'mailto:steevjames11@gmail.com?subject=[MEC Attendance Bug/Suggestion Submission]');
          else if (val == 2)
            _launchURL(
                'http://attendance.mec.ac.in/view4stud.php?class=' + classname);
          else if (val == 3)
            _launchURL(
                'https://play.google.com/store/apps/details?id=com.mec.attendance');
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          PopupMenuItem(
            value: 1,
            child: Text(
              'Report Bugs',
              style: TextStyle(fontFamily: fontName, fontSize: 14),
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Text(
              'View on Site',
              style: TextStyle(fontFamily: fontName, fontSize: 14),
            ),
          ),
          PopupMenuItem(
            value: 3,
            child: Text(
              'Rate',
              style: TextStyle(fontFamily: fontName, fontSize: 14),
            ),
          ),
        ],
      )
    ],
    // Back button on appbar
    leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: onbackbutton,
    ),
    centerTitle: true,
    // Title of page
    title: Text(
      studname,
      style: TextStyle(fontSize: 19.0, fontFamily: fontName),
    ),
    gradient: LinearGradient(colors: [gradientAppbarStart, gradientAppbarEnd]),
  );
}
