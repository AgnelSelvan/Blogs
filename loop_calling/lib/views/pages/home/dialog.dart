import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_calling/view_model/user/dialogs.dart';
import 'package:loop_calling/view_model/user/user.dart';
import 'package:quickblox_sdk/chat/constants.dart';

class DialogScreen extends ConsumerStatefulWidget {
  const DialogScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DialogScreen> createState() => _DialogScreenState();
}

class _DialogScreenState extends ConsumerState<DialogScreen> {
  @override
  void initState() {
    ref.read(dialogProvider).getAllDialogs(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.read(dialogProvider).getAllDialogs(context);
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: ref
              .watch(dialogProvider)
              .allDialogs
              .map((e) => ListTile(
                    onTap: () {
                      if (e?.type != null) {
                        if (e?.type == QBChatDialogTypes.CHAT) {
                          debugPrint("Private Chat: ${e?.id}");
                          final currentUser = ref.read(userProvider).user!;
                          final receiptantsIDS = e?.occupantsIds ?? [];
                          // receiptantsIDS.remove(currentUser.user.id);
                          debugPrint(
                              "receiptantsIDS: $receiptantsIDS ${currentUser.user.id}");
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ChatScreen(
                          //             recepiantUser: ,
                          //             chatType: ChatType.private,
                          //             qbDialogID: e?.id ?? "")));
                        } else if (e?.type == QBChatDialogTypes.PUBLIC_CHAT) {
                          debugPrint("Public Chat");
                        } else if (e?.type == QBChatDialogTypes.GROUP_CHAT) {
                          debugPrint("Group Chat");
                        }
                      }
                    },
                    title: Text(e?.name ?? ""),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
