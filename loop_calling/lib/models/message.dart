import 'package:quickblox_sdk/models/qb_message.dart';

class Message {
  final bool unread;
  final QBMessage message;

  Message({
    required this.unread,
    required this.message,
  });
}
