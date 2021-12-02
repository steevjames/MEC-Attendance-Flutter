import 'package:flutter/material.dart';
import 'package:mec_attendance/Theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

dialogWithContent({@required context}) {
  showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "This app was developed using Flutter by Steev James of CSA 2021 batch. The app gets data from the college attendance website to and shows processed data to the user. Currently looking for someone to maintain the app. To contact the developer, use the link below",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                      child: Text("Contact"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      color: Color(0xFF2c7ec4),
                      visualDensity: VisualDensity.compact,
                      textColor: Colors.white,
                      onPressed: () {
                        launch("https://wa.me/919539415481");
                      }),
                  SizedBox(width: 20),
                  RaisedButton(
                      child: Text("Source code"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      color: Color(0xFF2c7ec4),
                      visualDensity: VisualDensity.compact,
                      textColor: Colors.white,
                      onPressed: () {
                        launch(
                            "https://github.com/steevjames/MEC-Attendance-Flutter");
                      })
                ],
              )
            ],
          ),
        );
      });
}

customAppbar({classname, onbackbutton, studname, context}) {
  _launchURL(url) async {
    // if (await canLaunch(url) && url != '') {
    await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  return GradientAppBar(
    actions: <Widget>[
      PopupMenuButton(
        onSelected: (val) {
          // if (val == 1)
          //   _launchURL(
          //       'mailto:steevjames11@gmail.com?subject=[MEC Attendance Bug/Suggestion Submission]');
          // else
          if (val == 2)
            _launchURL(
                'http://attendance.mec.ac.in/view4stud.php?class=' + classname);
          else if (val == 3)
            _launchURL(
                'https://play.google.com/store/apps/details?id=com.mec.attendance');
          else if (val == 4) dialogWithContent(context: context);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          PopupMenuItem(
            value: 2,
            child: Text(
              'View on Site',
              style: TextStyle(fontFamily: fontName, fontSize: 14),
            ),
          ),
          PopupMenuItem(
            value: 4,
            child: Text(
              'About ',
              style: TextStyle(fontFamily: fontName, fontSize: 14),
            ),
          ),
          PopupMenuItem(
            value: 3,
            child: Text(
              'Find on Google Play',
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
