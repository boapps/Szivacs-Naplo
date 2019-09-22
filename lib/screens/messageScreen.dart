import 'dart:async';

import 'package:e_szivacs/Datas/Message.dart';
import 'package:e_szivacs/Dialog/MessageDialog.dart';
import 'package:e_szivacs/Helpers/RequestHelper.dart';
import 'package:flutter/material.dart';

import '../GlobalDrawer.dart';
import '../Utils/StringFormatter.dart';
import '../generated/i18n.dart';
import '../globals.dart' as globals;

void main() {
  runApp(new MaterialApp(home: new MessageScreen()));
}

class MessageScreen extends StatefulWidget {
  @override
  MessageScreenState createState() => new MessageScreenState();
}

class MessageScreenState extends State<MessageScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<Message> get messages => globals.selectedAccount.messages;

  bool hasOfflineLoaded = true;
  bool hasLoaded = true;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () {
          globals.screen = 0;
          Navigator.pushReplacementNamed(context, "/main");
        },
        child: Scaffold(
            drawer: GDrawer(),
            appBar: new AppBar(
              title: new Text(S.of(context).messages),
              actions: <Widget>[],
            ),
            body: new Container(
                child: hasOfflineLoaded
                    ? new Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: new RefreshIndicator(
                      child: new ListView.builder(
                        itemBuilder: _itemBuilder,
                        itemCount: messages.length,
                      ),
                      onRefresh: _onRefresh),
                )
                    : new Center(child: new CircularProgressIndicator()))));
  }

  Future<Null> _onRefresh() async {
    setState(() {
      hasLoaded = false;
    });

    Completer<Null> completer = new Completer<Null>();

    await globals.selectedAccount.refreshStudentString(false);

    hasLoaded = true;

    if (mounted) setState(() => completer.complete());
    return completer.future;
  }

  Widget _itemBuilder(BuildContext context, int index) {
    Widget sep = new Container();

    return new Column(
      children: <Widget>[
        sep,
        new Divider(
          height: index != 0 ? 2.0 : 0.0,
        ),
        new ListTile(
          //leading: new Container(),
          title: new Text(messages[index].subject, style: TextStyle(fontWeight: !messages[index].seen ? FontWeight.bold : FontWeight.normal),),
          subtitle: new Text(messages[index].senderName, style: TextStyle(fontWeight: !messages[index].seen ? FontWeight.bold : FontWeight.normal),),
          trailing: new Column(
            children: <Widget>[
              new Text(dateToHuman(messages[index].date), style: TextStyle(fontWeight: !messages[index].seen ? FontWeight.bold : FontWeight.normal),),
              new Text(dateToWeekDay(messages[index].date), style: TextStyle(fontWeight: !messages[index].seen ? FontWeight.bold : FontWeight.normal),),
            ],
          ),
          onTap: () {
            if (!messages[index].seen) {
              setState(() {
                messages[index].seen = true;
                RequestHelper().seeMessage(
                    messages[index].id, globals.selectedAccount.user);
              });
            }
            return showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return new MessageDialog(messages[index]);
              },
            ) ??
                false;
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    MessageScreenState().deactivate();
  }
}
