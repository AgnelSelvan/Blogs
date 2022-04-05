import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String text;

  const AppHeader({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 25,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.headline3,
        ),
      ],
    );
  }
}
