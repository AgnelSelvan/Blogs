import 'package:flutter/material.dart';
import 'package:loop_calling/views/pages/register.dart';
import 'package:loop_calling/views/widgets/app_header.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    Key? key,
    required this.type,
    required this.header,
  }) : super(key: key);
  final String header;
  final AuthType type;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         AppHeader(text: type == AuthType.login ? "Login": "Register"),
        const SizedBox(
          height: 10,
        ),
        Text(
          header,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
