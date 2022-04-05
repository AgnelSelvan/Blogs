import 'package:flutter/material.dart';

class Utiliy {
  static showSnackbar(BuildContext context,
      {required String message, Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
      ),
      backgroundColor: color,
    ));
  }

  static showErrorSnackbar(BuildContext context, {required String message}) {
    showSnackbar(context, message: message, color: Colors.red[400]);
  }

  static showSuccessSnackbar(BuildContext context, {required String message}) {
    showSnackbar(context, message: message, color: Colors.green[400]);
  }

  static String getDateFromInt(int? date) {
    if (date == null) {
      return "";
    }
    final dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return "${dateTime.day}-${dateTime.month}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
  }
}
