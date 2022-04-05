import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_calling/core/utils/enum/chat_type.dart';
import 'package:loop_calling/core/utils/enum/input.dart';
import 'package:loop_calling/res/colors.dart';
import 'package:loop_calling/view_model/user/auth.dart';
import 'package:loop_calling/view_model/user/chat.dart';
import 'package:loop_calling/view_model/user/user.dart';
import 'package:loop_calling/views/pages/home/dialog.dart';
import 'package:loop_calling/views/pages/profile.dart';
import 'package:loop_calling/views/pages/register.dart';
import 'package:loop_calling/views/pages/search.dart';
import 'package:loop_calling/views/widgets/textfield.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<Widget> screenList = [const DialogScreen(), const ProfileScreen()];

  @override
  void initState() {
    tabController = TabController(length: screenList.length, vsync: this);
    
    super.initState();
  }

  showTFDialog(ChatType chatType) {
    return showDialog(
        context: context,
        builder: (context) {
          final controller = TextEditingController();
          return SimpleDialog(
            title: const Text("Enter Group Name"),
            contentPadding: const EdgeInsets.all(20),
            children: [
              const SizedBox(
                height: 5,
              ),
              RegisterTextField(
                hintText: "",
                labelText: chatType == ChatType.public
                    ? "Enter Public Group Name"
                    : "",
                inputType: InputType.normal,
                leadingIcon: Icons.public,
                controller: controller,
              ),
              const SizedBox(
                height: 30,
              ),
              RegisterButton(
                text: "Create",
                onPressed: () async {
                  await ref.read(chatProvider).createAPublicDialog(
                        ref.read(userProvider).user?.user.id ?? 0,
                        controller.text,
                        context,
                      );
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Loop Calling",
          style: TextStyle(color: AppColors.lightPrimaryColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const SearchScreen())));
              },
              child: const Icon(
                Icons.search,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showTFDialog(ChatType.public);
            },
            child: const Tooltip(
              message: "Create a Public Group",
              child: Icon(
                Icons.public,
                color: AppColors.secondaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () async {
                  final status =
                      await ref.watch(qbUserAuthProvider).handleLogout();
                  debugPrint("Status : $status");
                  if (status) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                const AuthScreen(AuthType.login))));
                  }
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.red[400],
                )),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 70),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.primaryColor,
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: AppColors.secondaryColor),
            ),
            child: TabBar(
                labelColor: AppColors.lightPrimaryColor,
                controller: tabController,
                tabs: const [
                  Tab(
                    text: "Chat",
                  ),
                  Tab(
                    text: "Profile",
                  ),
                ]),
          ),
        ),
      ),
      body: TabBarView(controller: tabController, children: screenList),
    );
  }
}
