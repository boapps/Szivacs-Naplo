import 'package:e_szivacs/Datas/Message.dart';
import 'package:e_szivacs/Helpers/MessageHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';

import '../generated/i18n.dart';
import '../globals.dart' as globals;

class MessageDialog extends StatefulWidget {
  const MessageDialog(this.message);
  final Message message;

  @override
  MessageDialogState createState() => new MessageDialogState();
}

class MessageDialogState extends State<MessageDialog> {
  Message currentMessage;

  @override
  void initState() {
    super.initState();
    currentMessage = widget.message;
    MessageHelper().getMessageByIdOffline(globals.selectedAccount.user, currentMessage.id).then((Message message){
      if (message != null) {
        setState(() {
          currentMessage = message;
        });
      }
      MessageHelper().getMessageById(globals.selectedAccount.user, currentMessage.id).then((Message message){
        if (message != null) {
          setState(() {
            currentMessage = message;
          });
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return new SimpleDialog(
        title: new Text(currentMessage.subject),
        titlePadding: EdgeInsets.all(15),
        contentPadding: const EdgeInsets.all(15.0),
        children: <Widget>[
          Container(
            child: Text(S.of(context).receivers + currentMessage.receivers.join(", "), style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          Container(
            child: new Html( data: HtmlUnescape().convert(currentMessage.text)),
          ),
          Container(
            child: Text(currentMessage.senderName, textAlign: TextAlign.end, style: TextStyle(fontSize: 16),),
          ),
        ]
    );
  }
}