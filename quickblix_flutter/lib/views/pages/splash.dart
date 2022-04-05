import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_calling/repository/qb_chat.dart';
import 'package:loop_calling/view_model/app.dart';
import 'package:loop_calling/view_model/user/user.dart';
import 'package:loop_calling/views/pages/home.dart';
import 'package:loop_calling/views/pages/register.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  void performInit() async {
    late Widget screen;
    try {
      final isLoogedIn = await ref.read(appProvider).isLoggedIn;
      if (isLoogedIn) {
        await ref.read(userProvider).currentUser();
        final currentUser = ref.read(userProvider).user;
        QBChatCheckImpl qbChatCheckImpl = QBChatCheckImpl();
        qbChatCheckImpl.connect(
            currentUser!.user.id ?? 0, currentUser.user.password);
        screen = const HomeScreen();
      } else {
        screen = const AuthScreen(AuthType.login);
      }
    } catch (e) {
      debugPrint("Error $e");
      screen = const AuthScreen(AuthType.register);
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: ((context) => screen)));
  }

  @override
  void initState() {
    performInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(children: const [
            Text("Loop Calling"),
            CircularProgressIndicator()
          ]),
        ),
      ),
    );
  }
}
