import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class AppConfig extends InheritedWidget {
  AppConfig({required Widget child}) : super(child: child) {
    try {
      QB.settings
          .init(appId, authKey, authSecret, accountKey)
          .then((value) async {
        try {
          await QB.settings.enableAutoReconnect(true);
        } on PlatformException {
          debugPrint("Error in Autoreconnect");
        }
      });
    } catch (e) {
      debugPrint("Error in QB Initialization... $e");
    }
  }

  String appId = "96014";
  String authKey = "r3q9-mzWuOttqMJ";
  String authSecret = "zYONNsukDEER4tm";
  String accountKey = "8vfjT7xSLXP3usCtaf8H";

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
