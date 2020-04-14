import 'dart:async';

//import OneSignal
import 'package:onesignal_flutter/onesignal_flutter.dart';



Future<void> setUpNotifications() async {
  var notifs=[];
  String _debugLabelString = "";

  // bool _enableConsentButton = false;
  // if (!mounted) return;

  var settings = {
    OSiOSSettings.autoPrompt: false,
    OSiOSSettings.promptBeforeOpeningPushUrl: true
  };

  OneSignal.shared
      .setNotificationReceivedHandler((OSNotification notification) {
    _debugLabelString =
        "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
        notifs.add(_debugLabelString);
        print('\n\n--------------------\n'+notifs.toString()+'\n\n\n-----------\n\n\n');
  });

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    _debugLabelString =
        "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
  });

  OneSignal.shared.setInAppMessageClickedHandler((OSInAppMessageAction action) {
    _debugLabelString =
        "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}";
  });

  // NOTE: Replace with your own app ID from https://www.onesignal.com
  await OneSignal.shared
      .init("39dbd0e1-985e-4af9-98ad-764bc9caa73f", iOSSettings: settings);

  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
}
