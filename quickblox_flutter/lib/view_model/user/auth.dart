import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loop_calling/core/error/failures.dart';
import 'package:loop_calling/core/network/info.dart';
import 'package:loop_calling/data/local/auth/auth.dart';
import 'package:loop_calling/models/user.dart';
import 'package:loop_calling/repository/qb_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final qbUserAuthProvider =
    ChangeNotifierProvider(((ref) => QBUserAuthProvider()));

class QBUserAuthProvider extends ChangeNotifier {
  late QBUserAuthImpl qbUserAuthImpl;
  User? user;
  QBUserAuthProvider() {
    qbUserAuthImpl = QBUserAuthImpl(
      networkInfo: NetworkInfoImpl(
        InternetConnectionChecker(),
      ),
    );
  }

  Future<Failure?> handleRegister(String username, String password) async {
    final succOrFailure = await qbUserAuthImpl.register(username, password);
    final val = succOrFailure.fold((l) => l, (r) => r);
    if (val is Failure) {
      return val;
    } else if (val is User) {
      final prefs = await SharedPreferences.getInstance();
      final authDB = AuthDBImpl(sharedPreferences: prefs);
      authDB.addUser(val);
      user = val;
    }
    return null;
  }

  Future<Failure?> handleLogin(String username, String password) async {
    final succOrFailure = await qbUserAuthImpl.login(username, password);
    final val = succOrFailure.fold((l) => l, (r) => r);
    if (val is Failure) {
      return val;
    } else if (val is User) {
      final prefs = await SharedPreferences.getInstance();
      final authDB = AuthDBImpl(sharedPreferences: prefs);
      authDB.addUser(val);
      user = val;
    }
    return null;
  }

  Future<bool> handleLogout() async {
    return await qbUserAuthImpl.logout();
  }
}
