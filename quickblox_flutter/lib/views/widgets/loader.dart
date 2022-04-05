import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);
  final double? width, height;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: width ?? 20,
            height: height ?? 20,
            child: const CircularProgressIndicator()));
  }
}
