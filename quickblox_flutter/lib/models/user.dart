import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';

class User {
  late QBUserJson user;
  late QBSessionJson session;

  User({required this.session, required this.user});

  Map<String, dynamic> toJson() {
    return {"user": user.toJson(), "session": session.toJson()};
  }

  User.fromJson(Map<String, dynamic> json) {
    user = QBUserJson.fromJson(json["user"]);
    session = QBSessionJson.fromJson(json["session"]);
  }
}

class QBSessionJson extends QBSession {
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "applicationId": applicationId,
      "token": token,
      "expirationDate": expirationDate,
    };
  }

  QBSessionJson.toMyClass(QBSession qbSession) {
    userId = qbSession.userId;
    applicationId = qbSession.applicationId;
    token = qbSession.token;
    expirationDate = qbSession.expirationDate;
  }

  QBSessionJson.fromJson(Map<String, dynamic> json) {
    userId = json["userId"];
    applicationId = json["applicationId"];
    token = json["token"];
    expirationDate = json["expirationDate"];
  }
}

class QBUserJson extends QBUser {
  late final String? state;
  late String? district;
  late String password;
  Map<String, dynamic> toJson() {
    return {
      "blobId": blobId,
      "customData": customData,
      "email": email,
      "externalId": externalId,
      "facebookId": facebookId,
      "fullName": fullName,
      "id": id,
      "login": login,
      "phone": phone,
      "tags": tags,
      "twitterId": twitterId,
      "website": website,
      "lastRequestAt": lastRequestAt,
      "password": password,
    };
  }

  QBUserJson.toMyClass(QBUser qbUser, {required this.password}) {
    blobId = qbUser.blobId;
    customData = qbUser.customData;
    email = qbUser.email;
    externalId = qbUser.externalId;
    facebookId = qbUser.facebookId;
    fullName = qbUser.fullName;
    id = qbUser.id;
    login = qbUser.login;
    phone = qbUser.phone;
    tags = qbUser.tags;
    twitterId = qbUser.twitterId;
    website = qbUser.website;
    lastRequestAt = qbUser.lastRequestAt;
    final jsonVal = jsonDecode(qbUser.customData ?? "{}");
    state = jsonVal["state"];
    district = jsonVal["district"];
  }

  QBUserJson.fromJson(Map<String, dynamic> json) {
    blobId = json["blobId"];
    password = json["password"].toString();
    customData = json["customData"];
    email = json["email"];
    externalId = json["externalId"];
    facebookId = json["facebookId"];
    fullName = json["fullName"];

    id = json["id"];
    login = json["login"];
    phone = json["phone"];
    if (json["tags"] != null) {
      debugPrint("Tags: ${json['tags']}");
      tags = [];
      final tg = json["tags"] as List;
      for (var item in tg) {
        tags?.add("$item");
      }
    } else {
      tags = [];
    }

    twitterId = json["twitterId"];
    website = json["website"];
    lastRequestAt = json["lastRequestAt"];
    if (json["customData"] != null) {
      final jsonVal = jsonDecode(json["customData"]);
      state = jsonVal["state"];
      district = jsonVal["district"];
    } else {
      state = null;
      district = null;
    }
  }
}
