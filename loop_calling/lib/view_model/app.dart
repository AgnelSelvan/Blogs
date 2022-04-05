import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_calling/data/local/auth/auth.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appProvider = ChangeNotifierProvider(((ref) => AppProvider()));

class AppProvider extends ChangeNotifier {
  Future<bool> get isLoggedIn async {
    QBSession? session = await QB.auth.getSession();
    if (session != null) {
      debugPrint("Session: $session");
      return true;
    }
    final prefs = await SharedPreferences.getInstance();
    final authDB = AuthDBImpl(sharedPreferences: prefs);
    final user = authDB.getUser;
    debugPrint("User Password ${user?.user.password}");
    if (user == null) {
      return false;
    }
    return true;
  }
}
