import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:loop_calling/core/error/failures.dart';
import 'package:loop_calling/data/local/auth/auth.dart';
import 'package:loop_calling/models/user.dart';
import 'package:quickblox_sdk/models/qb_file.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/users/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class QBUserCheck {
  Future<Either<Failure, List<QBUser?>>> getAllUsers();
  Future<Either<Failure, List<QBUser?>>> getUsersByTags(List<String> tags);

  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, QBUser>> uploadImage(File imageFile, String login);
  Future<Either<Failure, String>> getProfileImage(int blobId);
}

class QBUserCheckImpl extends QBUserCheck {
  @override
  Future<Either<Failure, List<QBUser?>>> getAllUsers() async {
    try {
      QBSort sort = QBSort();
      sort.field = QBUsersSortFields.LOGIN;
      sort.type = QBUsersSortTypes.STRING;
      sort.ascending = false;

      List<QBUser?> userList = await QB.users.getUsers(sort: sort);
      return Right(userList);
    } catch (e) {
      return Left(UnknownFailure("Error in getting Users $e"));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final authDB = AuthDBImpl(sharedPreferences: prefs);
    return authDB.getUser == null
        ? Left(UnknownFailure("Please Login again"))
        : Right(authDB.getUser!);
  }

  @override
  Future<Either<Failure, QBUser>> uploadImage(
      File imageFile, String? login) async {
    if (login == null) {
      return Left(UnknownFailure("User login failed please login again"));
    }
    try {
      QBFile? file = await QB.content.upload(imageFile.path);
      if (file != null) {
        final blobId = file.id;
        QBUser? updatedUser =
            await QB.users.updateUser(login: login, blobId: blobId);
        if (updatedUser == null) {
          return Left(UnknownFailure("Error in getting user data"));
        }
        return Right(updatedUser);
      }
      return Left(UnknownFailure("Error in getting image file"));
    } on PlatformException {
      return Left(UnknownFailure("Error in uploading image"));
    }
  }

  @override
  Future<Either<Failure, String>> getProfileImage(int blobId) async {
    try {
      final file = await QB.content.getInfo(blobId);
      if (file != null) {
        final uid = file.uid;
        if (uid != null) {
          final fileUrl = await QB.content.getPrivateURL(uid);
          if (fileUrl == null) {
            return Left(UnknownFailure("Error in getting Profile URL"));
          }
          return Right(fileUrl);
        }
        return Left(UnknownFailure("Error in File ID"));
      }
      return Left(UnknownFailure("Error in BlobID"));
    } on PlatformException catch (e) {
      return Left(UnknownFailure("$e"));
    }
  }

  @override
  Future<Either<Failure, List<QBUser?>>> getUsersByTags(
    List<String> tags,
  ) async {
    try {
      List<QBUser?> userList = await QB.users.getUsersByTag(
        tags,
      );
      return Right(userList);
    } catch (e) {
      return Left(UnknownFailure("Error in getting Users $e"));
    }
  }
}
