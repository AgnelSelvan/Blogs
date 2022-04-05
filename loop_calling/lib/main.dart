import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_calling/core/config/app.dart';
import 'package:loop_calling/repository/qb_chat.dart';
import 'package:loop_calling/res/colors.dart';
import 'package:loop_calling/view_model/user/chat.dart';
import 'package:loop_calling/view_model/user/user.dart';
import 'package:loop_calling/views/pages/splash.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: AppConfig(
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  QBChatCheckImpl qbChatCheckImpl = QBChatCheckImpl();
  late UserProvider _userProvider;
  StreamSubscription? _deliveredMessageSubscription;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  notificationSetup() {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void onSelectNotification(String? value) {
    debugPrint("On notification click: $notificationSetup");
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? "Title"),
        content: Text(body ?? "Content"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SplashScreen(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  int uniqueID = 0;
  Future<void> performInit() async {
    notificationSetup();
    try {
      _deliveredMessageSubscription = await QB.chat.subscribeChatEvent(
        QBChatEvents.RECEIVED_NEW_MESSAGE,
        (data) async {
          LinkedHashMap<dynamic, dynamic> messageStatusHashMap = data;
          Map<dynamic, dynamic> messageStatusMap =
              Map<dynamic, dynamic>.from(messageStatusHashMap);
          Map<dynamic, dynamic> payloadMap =
              Map<String, Object>.from(messageStatusHashMap["payload"]);

          debugPrint("Streaming $payloadMap");
          debugPrint("Streaming messageStatusMap $messageStatusMap");
          final messageId = payloadMap["id"];
          final dateSent = payloadMap["dateSent"];
          final senderId = payloadMap["senderId"];
          final dialogID = payloadMap["dialogId"];
          final body = payloadMap["body"];
          debugPrint("$messageId, $senderId, $dialogID");

          final currentUser = ref.read(userProvider).user;
          if (currentUser != null) {
            QBMessage qbMessage = QBMessage();
            qbMessage.id = messageId;
            qbMessage.body = body;
            qbMessage.dateSent = dateSent;
            qbMessage.senderId = senderId;
            qbMessage.recipientId = currentUser.user.id;
            ref.read(chatProvider).addMsgFromStream(qbMessage, dialogID);

            final AndroidNotificationDetails androidPlatformChannelSpecifics =
                AndroidNotificationDetails(
              '$uniqueID',
              'new_message_channel',
              channelDescription: 'Will gets poped when getting a new message',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker',
            );
            final NotificationDetails platformChannelSpecifics =
                NotificationDetails(android: androidPlatformChannelSpecifics);
            await flutterLocalNotificationsPlugin.show(
                uniqueID, "New Message", body, platformChannelSpecifics,
                payload: 'item x');
            uniqueID++;

            await qbChatCheckImpl.markMsgDelivered(
                dialogID, currentUser.user.id ?? 0, messageId);
          }
        },
      );
    } on PlatformException catch (e) {
      debugPrint("Error in getting $e");
      // Some error occurred, look at the exception message for more details
    }
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    performInit();
    _userProvider = ref.read(userProvider);
    _userProvider.currentUser();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _deliveredMessageSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        try {
          qbChatCheckImpl.connect(_userProvider.user?.user.id ?? 0,
              _userProvider.user?.user.password ?? "");
        } on PlatformException {
          debugPrint("Connecting Error...");
        }
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        try {
          qbChatCheckImpl.disconnect();
        } on PlatformException {}
        break;
      case AppLifecycleState.inactive:
        qbChatCheckImpl.disconnect();
        break;
      case AppLifecycleState.detached:
        qbChatCheckImpl.disconnect();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Looping Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        primarySwatch: AppColors.primarySwatch,
        textTheme: TextTheme(
          headline3: const TextStyle(
            color: AppColors.secondaryColor,
            fontSize: 40,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
          labelMedium:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500]!),
          bodyText1: TextStyle(
            color: Colors.grey[400]!,
            fontSize: 16,
          ),
          bodyText2: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.grey[700]!,
            fontSize: 20,
          ),
          subtitle2: TextStyle(
            color: Colors.grey[500],
            letterSpacing: 0.5,
            fontSize: 14,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
