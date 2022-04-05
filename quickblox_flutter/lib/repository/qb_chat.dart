import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loop_calling/core/error/failures.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

abstract class QBChatCheck {
  Future<Failure?> connect(int userID, String password);
  Future<bool> get isConnected;
  Future<Failure?> disconnect();

  Future<Either<Failure, QBDialog>> privateChat(
    List<int> occupantsIds,
    String dialogName,
  );
  Future<QBDialog> groupChat(
    List<int> occupantsIds,
    String dialogName,
    String dialogPhoto,
  );
  Future<Either<Failure, QBDialog>> publicChat(
    List<int> occupantsIds,
    String dialogName,
  );

  Future<void> sendTextMessage(
    String text,
    String dialogID,
    int senderId,
    int recipientId,
  );
  Future<void> markMsgDelivered(
    String dialogID,
    int senderId,
    String msgID,
  );
  Future<List<QBMessage?>> getMessageHistory(
    String dialogID,
  );

  Future<Either<Failure, List<QBDialog?>>> getAllDialog();
}

class QBChatCheckImpl extends QBChatCheck {
  @override
  Future<Failure?> connect(int userID, String password) async {
    try {
      await QB.chat.connect(userID, password);
      debugPrint("User connected to Chat");
    } on PlatformException catch (e) {
      return UnknownFailure("$e");
    }
    return null;
  }

  @override
  Future<Failure?> disconnect() async {
    try {
      await QB.chat.disconnect();
    } on PlatformException catch (e) {
      return UnknownFailure("$e");
    }
    return null;
  }

  @override
  Future<QBDialog> groupChat(
      List<int> occupantsIds, String dialogName, String dialogPhoto) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, QBDialog>> privateChat(
      List<int> occupantsIds, String dialogName) async {
    try {
      QBDialog? createdDialog = await QB.chat.createDialog(
          occupantsIds, dialogName,
          dialogType: QBChatDialogTypes.CHAT);
      if (createdDialog != null) {
        return Right(createdDialog);
      }
      return Left(UnknownFailure("Error in creating Chat"));
    } on PlatformException catch (e) {
      debugPrint("Error in chatting $e");
      return Left(UnknownFailure("Error in creating Chat $e"));
    }
  }

  @override
  Future<Either<Failure, QBDialog>> publicChat(
      List<int> occupantsIds, String dialogName) async {
    int dialogType = QBChatDialogTypes.PUBLIC_CHAT;
    debugPrint("All $occupantsIds, $dialogName");
    try {
      final qbDialog = await QB.chat
          .createDialog(occupantsIds, dialogName, dialogType: dialogType);
      if (qbDialog == null) {
        return Left(UnknownFailure("Error in creating Public Chat"));
      }
      return Right(qbDialog);
    } on PlatformException catch (e) {
      return Left(UnknownFailure("$e"));
    }
  }

  @override
  Future<bool> get isConnected async {
    try {
      bool? connected = await QB.chat.isConnected();
      if (connected != null) {
        return connected;
      }
      return false;
    } on PlatformException catch (e) {
      debugPrint("Error $e");
      return false;
    }
  }

  @override
  Future<void> sendTextMessage(
      String text, String dialogID, int senderId, int recipientId) async {
    log("Text $text, DialogID: $dialogID");
    try {
      await QB.chat.sendMessage(
        dialogID,
        body: text,
        saveToHistory: true,
        markable: true,
      );
      log("Message Sent!");
    } catch (e) {
      log("Error in sending message $e");
    }
  }

  @override
  Future<List<QBMessage?>> getMessageHistory(String dialogID) async {
    QBSort sort = QBSort();
    sort.field = QBChatMessageSorts.DATE_SENT;
    sort.ascending = false;

    try {
      return await QB.chat.getDialogMessages(
        dialogID,
        sort: sort,
      );
    } on PlatformException catch (e) {
      debugPrint("Error in getting message history $e");
      return [];
    }
  }

  @override
  Future<void> markMsgDelivered(
    String dialogID,
    int senderId,
    String msgID,
  ) async {
    log("Message Delivered: $dialogID $senderId $msgID");
    QBMessage message = QBMessage();
    message.dialogId = dialogID;
    message.id = msgID;
    message.senderId = senderId;
    await QB.chat.markMessageDelivered(message);
  }

  @override
  Future<Either<Failure, List<QBDialog?>>> getAllDialog() async {
    QBSort sort = QBSort();
    sort.field = QBChatDialogSorts.LAST_MESSAGE_DATE_SENT;
    sort.ascending = true;

    int limit = 100;

    try {
      List<QBDialog?> dialogs = await QB.chat.getDialogs(
        sort: sort,
        limit: limit,
      );
      return Right(dialogs);
    } on PlatformException catch (e) {
      return Left(UnknownFailure("Error in getting Dialogs $e"));
    }
  }
}
