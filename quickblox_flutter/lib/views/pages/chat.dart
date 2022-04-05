import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_calling/core/utils/enum/chat_type.dart';
import 'package:loop_calling/core/utils/utils.dart';
import 'package:loop_calling/models/message.dart';
import 'package:loop_calling/models/user.dart';
import 'package:loop_calling/repository/qb_chat.dart';
import 'package:loop_calling/res/colors.dart';
import 'package:loop_calling/view_model/user/chat.dart';
import 'package:loop_calling/view_model/user/dialogs.dart';
import 'package:loop_calling/view_model/user/user.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final QBUserJson? recepiantUser;
  final ChatType chatType;
  final String? qbDialogID;

  const ChatScreen(
      {this.recepiantUser, required this.chatType, this.qbDialogID});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final messageController = TextEditingController();
  QBChatCheckImpl qbChatCheckImpl = QBChatCheckImpl();

  late User currentUser;

  Future<void> performInit() async {
    ref.read(chatProvider).opacity = 0;
    ref.read(chatProvider).messagesList.clear();
    if (widget.recepiantUser != null) {
      ref.read(chatProvider).createADialog(
          currentUser.user.id ?? 0, widget.recepiantUser!.id ?? 0, context);
    }
    if (widget.qbDialogID != null) {
      await ref.read(chatProvider).getMessageHistory(widget.qbDialogID ?? "");
    }
//     ref.read(chatProvider).scrollDown();
  }

  @override
  void initState() {
    currentUser = ref.read(userProvider).user!;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration.zero, () {
        performInit();
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _buildMessage(Message message, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        color: isMe
            ? AppColors.primarySwatch[50]
            : const Color.fromARGB(255, 238, 238, 255),
        borderRadius: isMe
            ? const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : const BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.message.body ?? "",
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            Utiliy.getDateFromInt(message.message.dateSent),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 10.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
      ],
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.photo),
            iconSize: 25.0,
            color: AppColors.lightPrimaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: messageController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            iconSize: 25.0,
            color: AppColors.lightPrimaryColor,
            onPressed: () async {
              debugPrint("Sender ${currentUser.user.login}");
              if (widget.recepiantUser != null) {
                await ref.read(chatProvider).sendMessage(
                      messageController.text,
                      currentUser.user.id ?? 0,
                      widget.recepiantUser?.id ?? 0,
                    );
                ref.read(dialogProvider).getAllDialogs(context);
              } else {
                await ref.read(chatProvider).sendMessage(
                      messageController.text,
                      currentUser.user.id ?? 0,
                      widget.recepiantUser?.id ?? 0,
                    );
              }

              messageController.clear();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    log("UI Built");
//     ref.read(chatProvider).scrollDown();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightPrimaryColor,
        title: Text(
          widget.recepiantUser?.login ?? "",
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.replay_outlined),
            iconSize: 24.0,
            color: Colors.white,
            onPressed: () {
              ref.read(chatProvider).scrollDown();
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            iconSize: 24.0,
            color: Colors.white,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.video_call),
            iconSize: 24.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Opacity(
                  opacity: ref.watch(chatProvider).opacity,
                  child: ListView.builder(
                    controller: ref.watch(chatProvider).scrollController,
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    //   shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 15.0),
                    itemCount: ref.watch(chatProvider).messagesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Message message =
                          ref.watch(chatProvider).messagesList[index];
                      final bool isMe =
                          message.message.senderId == currentUser.user.id;
                      return _buildMessage(message, isMe);
                    },
                  ),
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
