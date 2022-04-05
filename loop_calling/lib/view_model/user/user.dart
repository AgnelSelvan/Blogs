import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loop_calling/core/error/failures.dart';
import 'package:loop_calling/core/network/info.dart';
import 'package:loop_calling/data/local/auth/auth.dart';
import 'package:loop_calling/models/user.dart';
import 'package:loop_calling/repository/qb_auth.dart';
import 'package:loop_calling/repository/qb_user.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userProvider = ChangeNotifierProvider(((ref) => UserProvider()));

class UserProvider extends ChangeNotifier {
  late QBUserAuthImpl qbUserAuthImpl;
  late QBUserCheckImpl qbUserCheckImpl;
  final mobileNoController = TextEditingController();
  final districtController = TextEditingController();
  final stateController = TextEditingController();
  final tagController = TextEditingController();

  UserProvider() {
    qbUserAuthImpl = QBUserAuthImpl(
      networkInfo: NetworkInfoImpl(
        InternetConnectionChecker(),
      ),
    );
    qbUserCheckImpl = QBUserCheckImpl();
  }

  User? _user;
  User? get user => _user;
  set user(User? user) {
    _user = user;
    mobileNoController.text = _user?.user.phone ?? "";
    stateController.text = _user?.user.state ?? "";
    districtController.text = _user?.user.district ?? "";
    tagsList = _user?.user.tags ?? [];
    notifyListeners();
  }

  Future<Failure?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final authDB = AuthDBImpl(sharedPreferences: prefs);
    user = authDB.getUser;
    debugPrint("User Login ${user?.user.login}");
    notifyListeners();
    if (user == null) {
      return UnknownFailure("Error in gettng data please login again!");
    }
    return null;
  }

  List<String> tagsList = [];
  addTag() {
    tagsList.add(tagController.text);
    tagController.clear();
    notifyListeners();
  }

  removeTag(String tag) {
    tagsList.remove(tag);
    notifyListeners();
  }

  Future<Failure?> updateUserData() async {
    if (user == null) {
      return UnknownFailure("Error in gettng data please login again!");
    }
    final successOrFailure = await qbUserAuthImpl.updateUser(
      mobileNoController.text,
      {"state": stateController.text, "district": districtController.text},
      tagsList,
      user?.user.login ?? "",
    );
    final val = successOrFailure.fold((l) => l, (r) => r);
    if (val is Failure) {
      return UnknownFailure("Error in updating user data : ${val.toString()}");
    } else if (val is QBUser) {
      user = User(
          session: user!.session,
          user: QBUserJson.toMyClass(val, password: user?.user.password ?? ""));
      final prefs = await SharedPreferences.getInstance();
      final authDB = AuthDBImpl(sharedPreferences: prefs);
      authDB.addUser(user!);
    }
    notifyListeners();
    return null;
  }

  List<QBUser?> _usersList = [];
  List<QBUser?> get usersList => _usersList;
  set usersList(List<QBUser?> data) {
    _usersList = data;
    filteredUsersList = data;
    notifyListeners();
  }

  List<QBUser?> _filteredUsersList = [];
  List<QBUser?> get filteredUsersList => _filteredUsersList;
  set filteredUsersList(List<QBUser?> data) {
    final dummyUserList = data.where((e) => e?.id == _user?.user.id).toList();
    if (dummyUserList.isNotEmpty) {
      data.remove(dummyUserList.first);
    }
    _filteredUsersList = data;

    notifyListeners();
  }

  void filterUser(String value) {
    filteredUsersList = _usersList
        .where((element) => element == null
            ? false
            : _user == null
                ? false
                : _user?.user.id != element.id)
        .where((element) => element == null
            ? false
            : (element.login?.toLowerCase().contains(value.toLowerCase()) ??
                false))
        .toList();
  }

  Future<Failure?> getAllUsers() async {
    final successOrFailure = await qbUserCheckImpl.getAllUsers();
    final val = successOrFailure.fold((l) => l, (r) => r);
    if (val is Failure) {
      return val;
    } else if (val is List<QBUser?>) {
      usersList = val;
    }
    return null;
  }

  Future<Failure?> currentUser() async {
    final succOrFail = await qbUserCheckImpl.getCurrentUser();
    final val = succOrFail.fold((l) => l, (r) => r);
    if (val is Failure) {
      return val;
    } else if (val is User) {
      _user = val;
    }
    notifyListeners();
    return null;
  }

  Future<Failure?> uploadImage(File imageFile) async {
    final succOrFail =
        await qbUserCheckImpl.uploadImage(imageFile, user?.user.login);
    final val = succOrFail.fold((l) => l, (r) => r);
    if (val is Failure) {
      return val;
    } else if (val is QBUser) {
      _user?.user =
          QBUserJson.toMyClass(val, password: user?.user.password ?? "");
    }
    return null;
  }

  Future<String?> get profilePic async {
    final blobID = _user?.user.blobId;
    if (blobID != null) {
      final succOrFail = await qbUserCheckImpl.getProfileImage(blobID);
      final val = succOrFail.fold((l) => l, (r) => r);
      if (val is String) {
        return val;
      }
    }
    return null;
  }
}
