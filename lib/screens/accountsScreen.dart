import 'dart:async';
import 'package:flutter/material.dart';
import '../Datas/User.dart';
import '../GlobalDrawer.dart';
import '../globals.dart' as globals;
import '../Utils/AccountManager.dart';
import '../Utils/Saver.dart';
import '../Datas/Account.dart';
import '../Helpers/LocaleHelper.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

void main() {
  runApp(new MaterialApp(home: new AccountsScreen()));
}

class AccountsScreen extends StatefulWidget {
  @override
  AccountsScreenState createState() => new AccountsScreenState();

}

class AccountsScreenState extends State<AccountsScreen> {

  Color selected;

  void addPressed() {
    setState(() {
      Navigator.pushNamed(context, "/login");
    });

  }
  List<User> users;
  void _getUserList() async {
    users = await AccountManager().getUsers();
  }

  @override
  void initState() {

  super.initState();
    setState(() {
      performInitState();
    });
  }

  void performInitState() async {
    await _getUserList();
    _getListWidgets();
  }

  void _openDialog(String title, Widget content, User user) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        contentPadding: const EdgeInsets.all(6.0),
        title: Text(title),
        content: content,
        actions: [
          FlatButton(
            child: Text(AppLocalizations.of(context).no),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(AppLocalizations.of(context).ok),
            onPressed: () async {
              Navigator.of(context).pop();
              users[users.indexOf(user)].color = selected;
              await saveUsers(users);
              setState(() {
                globals.users = users;
                if (globals.selectedUser.id == user.id)
                  globals.selectedUser.color = selected;
                for (Account account in globals.accounts)
                  if (account.user.id == user.id)
                    account.user.color = selected;
                _getListWidgets();
              });

            },
          ),
        ],
      ),
    );
  }

  void _getListWidgets() async {
    if (users.isEmpty)
      Navigator.pushNamed(context, "/login");
    accountListWidgets = new List();
    for (User u in users) {
      setState(() {
        accountListWidgets.add(
          new ListTile(
            trailing: new Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Container(
                  child: new FlatButton(onPressed: (){
                    _openDialog(
                      "Color picker",
                      MaterialColorPicker(
                        selectedColor: selected,
                        onColorChange: (Color c) => selected = c,
                      ),
                      u
                    );
                  }, child: new Icon(Icons.color_lens, color: u.color, ),),
                ),
                new FlatButton(onPressed: () async {
                  await _removeUserDialog(u);
                  setState(() {
                    _getUserList();
                    _getListWidgets();
                  });
                },
                    child: new Icon(Icons.close, color: Colors.red,),),
              ],
            ),
            title: new Text(u.name),
            leading: new Icon(Icons.person_outline),
          ),
        );
        accountListWidgets.add(new Divider(height: 1.0,),);
      });
    }

    setState(() {
      accountListWidgets.add(new FlatButton(onPressed: addPressed,
          child: new Icon(Icons.add, color: Theme.of(context).accentColor,)));
    });

  }

  Future<Null> _removeUserDialog(User user) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(AppLocalizations.of(context).sure),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(AppLocalizations.of(context).delete_confirmation(user.name)),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(AppLocalizations.of(context).no),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(AppLocalizations.of(context).yes),
              onPressed: () {
                AccountManager().removeUser(user);
                setState(() {
                  _getUserList();
                  _getListWidgets();
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> accountListWidgets;

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
              title: new Text(AppLocalizations.of(context).accounts),
              actions: <Widget>[
              ],
            ),
            body: new Container(
              child: new Center(
                child: new Container(
                  child: accountListWidgets != null ? new ListView(
                    children:  accountListWidgets ,
                  ) : new CircularProgressIndicator()
                ),
              ),
            ),
        ),
    );
  }
}
