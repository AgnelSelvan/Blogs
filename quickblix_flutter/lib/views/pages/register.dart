import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_calling/core/error/failures.dart';
import 'package:loop_calling/core/utils/enum/input.dart';
import 'package:loop_calling/core/utils/input_validator.dart';
import 'package:loop_calling/core/utils/utils.dart';
import 'package:loop_calling/res/colors.dart';
import 'package:loop_calling/view_model/user/auth.dart';
import 'package:loop_calling/views/pages/home.dart';
import 'package:loop_calling/views/pages/profile.dart';
import 'package:loop_calling/views/widgets/register_header.dart';
import 'package:loop_calling/views/widgets/social_button.dart';
import 'package:loop_calling/views/widgets/textfield.dart';

enum AuthType { login, register }

class AuthScreen extends ConsumerStatefulWidget {
  final AuthType type;
  const AuthScreen(this.type, {Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> with InputValidator {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final formGlobalKey = GlobalKey<FormState>();

  DateTime? selectedDateTime;

  void onRegisterTap() async {
    if (formGlobalKey.currentState?.validate() ?? false) {
      formGlobalKey.currentState!.save();
      late Failure? failure;
      if (widget.type == AuthType.register) {
        failure = await ref
            .watch(qbUserAuthProvider)
            .handleRegister(usernameController.text, passwordController.text);
      } else {
        failure = await ref
            .watch(qbUserAuthProvider)
            .handleLogin(usernameController.text, passwordController.text);
      }
      if (failure == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const HomeScreen())));
      } else {
        Utiliy.showErrorSnackbar(context, message: failure.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: personalForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Form personalForm(BuildContext context) {
    return Form(
      key: formGlobalKey,
      child: personalUserInputFields(context),
    );
  }

  Column personalUserInputFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthHeader(
          type: widget.type,
          header: "Personal Info",
        ),
        const SizedBox(
          height: 20,
        ),
        RegisterTextField(
          labelText: "Enter Username",
          hintText: "Raj ",
          leadingIcon: Icons.account_circle_rounded,
          controller: usernameController,
          textInputType: TextInputType.name,
          validator: validateFullName,
          inputType: InputType.username,
        ),
        const SizedBox(
          height: 20,
        ),
        RegisterTextField(
          labelText: "Enter Password",
          obsecureText: true,
          hintText: "",
          controller: passwordController,
          leadingIcon: Icons.lock,
          inputType: InputType.password,
          validator: validatePassword,
        ),
        const SizedBox(
          height: 30,
        ),
        RegisterButton(
          onPressed: onRegisterTap,
          text: "Proceed",
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => AuthScreen(
                          widget.type == AuthType.login
                              ? AuthType.register
                              : AuthType.login))));
            },
            child: Text(
              "Already have an account? ${widget.type == AuthType.register ? 'Login' : 'Register'}",
              style:
                  TextStyle(color: AppColors.lightPrimaryColor, fontSize: 12),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            "OR",
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SocialLoginButton(
              iconData: Icons.facebook,
            ),
            SizedBox(
              width: 20,
            ),
            SocialLoginButton(iconData: Icons.web),
          ],
        ),
      ],
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton(
      {Key? key,
      this.onPressed,
      required this.text,
      this.btnColor,
      this.childColor})
      : super(key: key);

  final VoidCallback? onPressed;
  final String text;
  final Color? btnColor;
  final Color? childColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 0.4,
          blurRadius: 4,
          offset: const Offset(1, 1),
        ),
      ]),
      width: double.infinity,
      height: 50,
      child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              btnColor ?? Colors.white,
            ),
            foregroundColor: MaterialStateProperty.all(
              childColor ?? Colors.grey[600],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
              )
            ],
          )),
    );
  }
}

typedef StringCallback = Function(String? params);
typedef ValidatorCallback = String? Function(String? params);
