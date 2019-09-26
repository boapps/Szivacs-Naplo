import 'dart:async';

import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import '../Datas/Account.dart';
import '../Datas/User.dart';
import '../GlobalDrawer.dart';
import '../Utils/AccountManager.dart';
import '../Utils/Saver.dart';
import '../globals.dart' as globals;
import '../main.dart';
import 'studentScreen.dart';

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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen(fromApp: true,)),
      );
    });

  }
  List<User> users;

  @override
  void initState() {

  super.initState();
    setState(() {
      performInitState();
    });
  }

  void performInitState() async {
    users = await AccountManager().getUsers();
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
            child: Text(S
                .of(context)
                .no),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(S
                .of(context)
                .ok),
            onPressed: () async {
              Navigator.of(context).pop();
              users[users.map((User u) => u.id).toList().indexOf(user.id)]
                  .color = selected;
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

  Future<void> _getListWidgets() async {
    if (users.isEmpty)
      Navigator.pushNamed(context, "/login");
    accountListWidgets = new List();
    for (Account a in globals.accounts) {
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
                        S
                            .of(context)
                            .color,
                      MaterialColorPicker(
                        selectedColor: selected,
                        onColorChange: (Color c) => selected = c,
                      ),
                        a.user
                    );
                  }, child: new Icon(Icons.color_lens, color: a.user.color,),),
                ),
                new FlatButton(onPressed: () async {
                  _removeUserDialog(a.user).then((nul) async {
                    print("asd2");
                    users = await AccountManager().getUsers();
                    print(users.length);
                    globals.accounts.removeWhere((Account a) => !users.map((User u) => u.id).contains(a.user.id));
                    await _getListWidgets();
                    setState(() {
                      print("asd3");
                      print(users.length);
                    });
                  });
                },
                    child: new Icon(Icons.close, color: Colors.red,),),
              ],
            ),
            title: new Text(a.user.name),
            leading: GestureDetector(
              child: Icon(Icons.person_outline),
              onTap: () async {
                await a.refreshStudentString(true);
                Navigator.push(context, new MaterialPageRoute(
                    builder: (BuildContext context) => new StudentScreen(
                      account: a,)));
              },
            ),
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
          title: new Text(S
              .of(context)
              .sure),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(S.of(context).delete_confirmation(user.name)),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(S
                  .of(context)
                  .no),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(S
                  .of(context)
                  .yes),
              onPressed: () async {
                await AccountManager().removeUser(user);
                print("asd1");
                setState(() async {
                  globals.accounts.removeWhere((Account a) => a.user.id == user.id);
                  Navigator.of(context).pop();
                  Navigator.pop(context); // close the drawer
                  Navigator.pushReplacementNamed(context, "/accounts");
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
              title: new Text(S
                  .of(context)
                  .accounts),
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
