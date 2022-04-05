import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_calling/core/utils/utils.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';

import '../../repository/qb_chat.dart';

final dialogProvider = ChangeNotifierProvider(((ref) => DialogProvider()));

class DialogProvider extends ChangeNotifier {
  QBChatCheckImpl qbChatCheckImpl = QBChatCheckImpl();

  List<QBDialog?> _allDialogs = [];
  List<QBDialog?> get allDialogs => _allDialogs;
  set allDialogs(List<QBDialog?> allDialogs) {
    debugPrint("All Dialog: ${allDialogs.length}");
    _allDialogs = allDialogs;
    notifyListeners();
  }

  getAllDialogs(BuildContext? context) async {
    final succOrFailure = await qbChatCheckImpl.getAllDialog();
    succOrFailure.fold(
        (l) => context == null
            ? l
            : Utiliy.showErrorSnackbar(context, message: "$l"),
        (r) => allDialogs = r);
  }
}
