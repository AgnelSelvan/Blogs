import 'package:flutter/material.dart';

class AppColors {
  static Color lightPrimaryColor = primarySwatch.shade100;
  static const Color primaryColor = Color.fromARGB(255, 17, 17, 161);
  static const Color secondaryColor = Color.fromARGB(255, 10, 10, 37);
  final color = Colors.blue;
  static MaterialColor primarySwatch = MaterialColor(
    primaryColor.value,
    <int, Color>{
      50: const Color.fromARGB(255, 182, 182, 255),
      100: const Color.fromARGB(255, 84, 84, 231),
      200: const Color.fromARGB(255, 50, 50, 207),
      300: const Color.fromARGB(255, 29, 29, 189),
      400: const Color.fromARGB(255, 24, 24, 173),
      500: Color(primaryColor.value),
      600: const Color.fromARGB(255, 8, 8, 134),
      700: const Color.fromARGB(255, 4, 4, 116),
      800: const Color.fromARGB(255, 1, 1, 94),
      900: const Color.fromARGB(255, 0, 0, 49),
    },
  );
}
