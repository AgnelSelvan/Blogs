import 'package:flutter/material.dart';
import 'package:loop_calling/res/colors.dart';

class SocialLoginButton extends StatelessWidget {
  final IconData iconData;
  const SocialLoginButton({
    Key? key,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0.4,
              blurRadius: 4,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Icon(
          iconData,
          color: AppColors.lightPrimaryColor,
        ));
  }
}
