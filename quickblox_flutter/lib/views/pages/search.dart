import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_calling/core/utils/enum/chat_type.dart';
import 'package:loop_calling/core/utils/utils.dart';
import 'package:loop_calling/models/user.dart';
import 'package:loop_calling/view_model/user/user.dart';
import 'package:loop_calling/views/pages/chat.dart';
import 'package:loop_calling/views/pages/profile.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _filter = TextEditingController();

  performInit() async {
    final failure = await ref.read(userProvider).getAllUsers();
    if (failure != null) {
      Utiliy.showErrorSnackbar(context,
          message: "Error in getting users: $failure");
    }
  }

  @override
  void initState() {
    performInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: TextField(
          controller: _filter,
          autofocus: true,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: 'Search...'),
          onChanged: (val) {
            ref.watch(userProvider).filterUser(val);
          },
        ),
        leading: IconButton(
          icon: Icon(
            Icons.cancel,
            color: Colors.red[400],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: ref
              .watch(userProvider)
              .filteredUsersList
              .map((e) => ListTile(
                    onTap: () async {
                      final failure =
                          await ref.read(userProvider).currentUser();
                      if (failure != null) {
                        Utiliy.showErrorSnackbar(context, message: "$e");
                        return;
                      }
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => ChatScreen(
                                recepiantUser: QBUserJson.toMyClass(
                                  e!,
                                  password: "",
                                ),
                                chatType: ChatType.private,
                                qbDialogID: null,
                              )),
                        ),
                      );
                    },
                    title: Text(e?.login ?? ""),
                    subtitle: Row(
                      children:
                          (e?.tags ?? []).map((e) => TagContainer(e)).toList(),
                    ),
                    leading: Icon(
                      Icons.account_circle,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
