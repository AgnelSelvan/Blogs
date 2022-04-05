import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_calling/core/utils/utils.dart';
import 'package:loop_calling/models/message.dart';
import 'package:loop_calling/repository/qb_chat.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_message.dart';

final chatProvider = ChangeNotifierProvider(((ref) => ChatProvider()));

class ChatProvider extends ChangeNotifier {
  QBChatCheckImpl qbChatCheckImpl = QBChatCheckImpl();

  List<Message> _messagesList = [];
  List<Message> get messagesList => _messagesList;
  bool visible = false;
  double opacity = 0;

  void addmessagesToList(Message message) {
    _messagesList.add(message);
    _messagesList = _messagesList.reversed.toList();
    log("${_messagesList.length}");

    Future.delayed(Duration.zero, () {
      log("Scrolling Down Called...");
      // scrollDown();
    });
    notifyListeners();
  }

  set messagesList(List<Message>? datas) {
    if (datas != null) {
      _messagesList = datas.reversed.toList();
    }
    log("${datas?.length}");
    Future.delayed(Duration.zero, () {
      log("Scrolling Down Called...");
      scrollDown();
    });
    notifyListeners();
  }

  QBDialog? _qbDialog;
  QBDialog? get qbDialog => _qbDialog;
  void setQBDialog(QBDialog? qbDialog) async {
    _qbDialog = qbDialog;
    if (qbDialog != null) {
      getMessageHistory(qbDialog.id ?? "");
    }
    notifyListeners();
  }

  void createADialog(
      int currentUserId, int receiverId, BuildContext context) async {
    log("$currentUserId Receiver ID: $receiverId");
    final succOrFail = await qbChatCheckImpl
        .privateChat([currentUserId, receiverId], "Anonymous");

    succOrFail.fold((l) => Utiliy.showErrorSnackbar(context, message: "$l"),
        (r) => setQBDialog(r));
  }

  Future<void> createAPublicDialog(
      int currentUserId, String dialogName, BuildContext context) async {
    final succOrFail =
        await qbChatCheckImpl.publicChat([currentUserId], dialogName);
    succOrFail.fold(
        (l) => Utiliy.showErrorSnackbar(context, message: "$l"), (r) => r);
  }

  Future<void> sendMessage(String text, int sender, int receiver) async {
    debugPrint("Sent Message: $text");
    QBMessage qbMessage = QBMessage();
    qbMessage.senderId = sender;
    qbMessage.recipientId = receiver;
    qbMessage.body = text;
    qbMessage.dateSent = DateTime.now().microsecondsSinceEpoch;
    addmessagesToList(
      Message(
        unread: true,
        message: qbMessage,
      ),
    );
    debugPrint("Added Message: ${qbMessage.body}");
    await qbChatCheckImpl.sendTextMessage(
      text,
      qbDialog?.id ?? "0",
      sender,
      receiver,
    );
  }

  void addMsgFromStream(QBMessage qbMessage, String dialogID) {
    if (_qbDialog?.id == dialogID || _qbDialog == null) {
      debugPrint("Got from Stream $qbMessage");
      final m = Message(unread: true, message: qbMessage);
      final val = _messagesList
          .where(
              (element) => (element.message.id ?? "0") == (m.message.id ?? "0"))
          .toList();
      if (val.isEmpty) {
        addmessagesToList(m);
      }
    }
  }

  final ScrollController scrollController = ScrollController();

  void scrollDown() {
    try {
      visible = false;
      opacity = 0;
      notifyListeners();
      log("Scrolling Down ${scrollController.position.maxScrollExtent}");
      scrollController.jumpTo(
        scrollController.position.maxScrollExtent,
        //   duration: const Duration(seconds: 2),
        //   curve: Curves.fastOutSlowIn,
      );
      log("Scrolling Down... $visible");
      notifyListeners();
      Future.delayed(const Duration(milliseconds: 500), () {
        visible = true;
        opacity = 1;
        notifyListeners();
      });
    } catch (e) {
      log("Scrolling Down... Error $e");
    }
  }

  Future<void> getMessageHistory(String dialogID) async {
    messagesList.clear();
    final mList = await qbChatCheckImpl.getMessageHistory(dialogID);
    messagesList =
        mList.reversed.map((e) => Message(unread: true, message: e!)).toList();
    notifyListeners();
  }
}
