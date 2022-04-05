import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loop_calling/core/error/failures.dart';
import 'package:loop_calling/core/network/info.dart';
import 'package:loop_calling/data/local/auth/auth.dart';
import 'package:loop_calling/models/user.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class QBUserAuth {
  Future<Either<Failure, User>> register(String username, String password);
  Future<Either<Failure, User>> login(String username, String password);
  Future<bool> logout();
  Future<Either<Failure, QBUser>> updateUser(
    String mobileNo,
    Map<String, dynamic> customDataJson,
    List<String> tagsList,
    String login,
  );
}

class QBUserAuthImpl extends QBUserAuth {
  late NetworkInfo networkInfo;
  QBUserAuthImpl({required this.networkInfo});

  @override
  Future<Either<Failure, User>> register(
      String username, String password) async {
    if ((await networkInfo.isConnected) ?? false) {
      try {
        final user = await QB.users.createUser(username, password);
        if (user == null) {
          return Left(UnknownFailure("Register return empty user"));
        }
        return login(username, password);
      } on PlatformException catch (e) {
        return Left(UnknownFailure("Error in creating the user, ${e.code}"));
      } catch (e) {
        return Left(UnknownFailure("Error in creating the user $e"));
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      QBLoginResult result = await QB.auth.login(username, password);
      QBUser? qbUser = result.qbUser;
      QBSession? qbSession = result.qbSession;
      if (qbUser == null || qbSession == null) {
        return Left(UnknownFailure("Error in getting user and session"));
      }
      return Right(User(
          session: QBSessionJson.toMyClass(qbSession),
          user: QBUserJson.toMyClass(qbUser, password: password)));
    } catch (e) {
      return Left(UnknownFailure("Error $e"));
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await QB.auth.logout();
      final prefs = await SharedPreferences.getInstance();
      final authDB = AuthDBImpl(sharedPreferences: prefs);
      authDB.removeUser();
      return true;
    } catch (e) {
      debugPrint("Error in Logout $e");

      return false;
    }
  }

  @override
  Future<Either<Failure, QBUser>> updateUser(
    String mobileNo,
    Map<String, dynamic> customDataJson,
    List<String> tagsList,
    String login,
  ) async {
    try {
      String customData = jsonEncode(customDataJson);
      debugPrint("Login: $login");
      QBUser? user = await QB.users.updateUser(
        login: login,
        customData: customData,
        phone: mobileNo,
        tagList: tagsList.join(", "),
      );
      debugPrint("Login: $user");
      if (user == null) {
        return Left(UnknownFailure("Error in updating the user record!"));
      }
      return Right(user);
    } on PlatformException catch (e) {
      debugPrint("Unknown Error : $e");
      return Left(UnknownFailure("Error in updating the user record! $e"));
    }
  }
}
