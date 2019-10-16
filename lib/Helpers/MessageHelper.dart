import 'dart:async';
import 'dart:convert' show utf8, json;

import 'package:e_szivacs/Helpers/RequestHelper.dart';

import '../Datas/Message.dart';
import '../Datas/User.dart';
import '../Helpers/DBHelper.dart';

class MessageHelper {
  Future<List<Message>> getMessages(User user) async {
    List<Message> messages = new List();
    try {
      String code = await RequestHelper().getBearerToken(user);
      String messageSting = await RequestHelper().getMessages(code, user.schoolCode);
      var messagesJson = json.decode(messageSting);
      DBHelper().addMessagesJson(messagesJson, user);

      for (var messageElement in messagesJson) {
        if (messageElement["uzenet"] != null) {
          Message message = Message.fromJson(messageElement);
          messages.add(message);
        }
      }
      messages.sort((Message a, Message b) => b.date.compareTo(a.date));
    } catch (e) {
      print(e);
    }

    return messages;
  }

  Future<List<Message>> getMessagesOffline(User user) async {
    List<Message> messages = new List();
    try {
      List messagesJson = await DBHelper().getMessagesJson(user);

      for (var messageElement in messagesJson) {
        if (messageElement["uzenet"] != null) {
          Message message = Message.fromJson(messageElement);
          messages.add(message);
        }
      }
      messages.sort((Message a, Message b) => b.date.compareTo(a.date));
    } catch (e) {
      print(e);
    }

    return messages;
  }

  Future<Message> getMessageById(User user, int id) async {
    Message message;
    try {
      String code = await RequestHelper().getBearerToken(user);
      String messageSting = await RequestHelper().getMessageById(id, code, user.schoolCode);
      var messagesJson = json.decode(messageSting);
      DBHelper().addMessageByIdJson(id, messagesJson, user);

      message = Message.fromJson(messagesJson);
    } catch (e) {
      print(e);
    }

    return message;
  }

  Future<Message> getMessageByIdOffline(User user, int id) async {
    Message message;
    try {
      Map<String, dynamic> messagesJson = await DBHelper().getMessageByIdJson(id, user);
      message = Message.fromJson(messagesJson);
    } catch (e) {
      print(e);
    }

    return message;
  }
}
