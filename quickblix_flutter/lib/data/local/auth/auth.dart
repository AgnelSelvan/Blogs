import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loop_calling/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthDB {
  void addUser(User user);
  void removeUser();
  User? get getUser;
}

class AuthDBImpl extends AuthDB {
  late SharedPreferences sharedPreferences;

  AuthDBImpl({required this.sharedPreferences});

  @override
  void addUser(User user) {
    sharedPreferences.setString("user_session", jsonEncode(user.toJson()));
  }

  @override
  void removeUser() {
    sharedPreferences.setString("user_session", "");
  }

  @override
  User? get getUser {
    final value = sharedPreferences.getString("user_session");
    // debugPrint("Data from Storage: $value");
    if (value == null) {
      return null;
    }
    try {
      final json = jsonDecode(value);

      return User.fromJson(json);
    } catch (e) {
      debugPrint("Error in decoding from Local Database $e");
      return null;
    }
  }
}
