import 'package:flutter/material.dart';
import 'globals.dart';
import 'Datas/Account.dart';
import 'Datas/User.dart';
import 'Helpers/LocaleHelper.dart';
import 'package:package_info/package_info.dart';

BuildContext ctx;

class GDrawer extends StatefulWidget {

  GDrawerState myState;

  @override
  GDrawerState createState() {
    myState = new GDrawerState();
    return myState;
  }
}

class GDrawerState extends State<GDrawer> {
  @override
  void initState() {
    super.initState();
  }

  void _onSelect(User user) async {
    setState(() {
      selectedUser = user;
      selectedAccount = accounts.firstWhere(
              (Account account) => account.user.id == user.id);
    });
    switch (screen) {
      case 0:
        Navigator.pop(context); // close the drawer
        Navigator.pushReplacementNamed(context, "/main");
        break;
      case 1:
        Navigator.pop(context); // close the drawer
        Navigator.pushReplacementNamed(context, "/evaluations");
        break;
      case 2:
        Navigator.pop(context); // close the drawer
        Navigator.pushReplacementNamed(context, "/timetable");
        break;
      case 3:
        Navigator.pop(context); // close the drawer
        Navigator.pushReplacementNamed(context, "/notes");
        break;
      case 5:
        Navigator.pop(context); // close the drawer
        Navigator.pushReplacementNamed(context, "/absents");
        break;
      case 6:
        Navigator.pop(context); // close the drawer
        Navigator.pushReplacementNamed(context, "/statistics");
        break;
      case 8:
        Navigator.pop(context); // close the drawer
        Navigator.pushReplacementNamed(context, "/homework");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Drawer(
      child: new Container(
        color: isDark ? Color.fromARGB(255, 25, 25, 25) : Colors.white70,
      child: new ListView(
        children: <Widget>[
          isLogo ? new Container(
            child: new DrawerHeader(
              child: new Column(
                children: <Widget>[
                  Image.asset(
                    "assets/icon.png",
                    height: 120.0,
                    width: 120.0,
                  ),
                  new Row(
                    children: <Widget>[
                      new Container(
                        child: new Text(
                          AppLocalizations.of(context).title,
                          style: TextStyle(fontSize: 19.0),
                        ),
                        padding: new EdgeInsets.fromLTRB(16.0, 0.0, 5.0, 0.0),
                      ),
                      new Container(
                        child: new Text(
                          version,
                          style:
                          TextStyle(fontSize: 19.0, color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Container(
                        child: new Text(
                          AppLocalizations.of(context).made_by,
                          style: TextStyle(
                            fontSize: 19.0,
                          ),
                        ),
                        padding: new EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 4.0),
                      ),
                      new Container(
                        child: new Text(
                          AppLocalizations.of(context).boa,
                          style:
                          TextStyle(fontSize: 19.0, color: Colors.blueAccent),
                        ),
                        padding: new EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 4.0),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              padding: EdgeInsets.all(2.0),
            ),
            height: 190.0,
          ) : new Container(height: 5,),
          selectedUser != null && multiAccount ? new Container(
            child: new DrawerHeader(
              child: new PopupMenuButton<User>(
                child: new Container(
                  child: new Row(
                    children: <Widget>[
                      new Container(child: new Icon(
                        Icons.account_circle, color: selectedUser.color,
                        size: 40,), margin: EdgeInsets.only(right: 5),),
                      new Text(selectedUser.name,
                        style: new TextStyle(color: null, fontSize: 17.0),),
                      new Icon(Icons.arrow_drop_down, color: null,),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 6.0),
                ),
                onSelected: _onSelect,
                itemBuilder: (BuildContext context) {
                  return users.map((User user) {
                    return new PopupMenuItem<User>(
                        value: user,
                        child: new Row(
                          children: <Widget>[
                            new Icon(Icons.account_circle, color: user.color,),
                            new Text(user.name),
                          ],
                        )
                    );
                  }).toList();
                },
              ),
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.all(0),
            ),
            height: 50,
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
          ) : new Container(),
          new ListTile(
            leading: new Icon(
              Icons.home, color: screen == 0 ? Colors.blueAccent : null,),
            title: new Text(AppLocalizations.of(context).main_page,
              style: TextStyle(color: screen == 0 ? Colors.blueAccent : null),),
            onTap: () {
              screen = 0;
              Navigator.pop(context); // close the drawer
              Navigator.pushReplacementNamed(context, "/main");
            },
          ),
          new ListTile(
            leading: new Icon(
              Icons.assignment, color: screen == 1 ? Colors.blueAccent : null,),
            title: new Text(AppLocalizations.of(context).evaluations,
              style: TextStyle(color: screen == 1 ? Colors.blueAccent : null),),
            onTap: () {
              screen = 1;
              Navigator.pop(context); // close the drawer
              Navigator.pushReplacementNamed(context, "/evaluations");
            },
          ),
          new ListTile(
            leading: new Icon(
              IconData(0xf520, fontFamily: "Material Design Icons"),
              color: screen == 2 ? Colors.blueAccent : null,),
            title: new Text(AppLocalizations.of(context).timetable,
              style: TextStyle(color: screen == 2 ? Colors.blueAccent : null),),
            onTap: () {
              screen = 2;
              Navigator.pop(context); // close the drawer
              Navigator.pushReplacementNamed(context, "/timetable");
            },
          ),
          new ListTile(
            leading: new Icon(
              IconData(0xf2dc, fontFamily: "Material Design Icons"),
              color: screen == 8 ? Colors.blueAccent : null,),
            title: new Text(AppLocalizations.of(context).homeworks,
              style: TextStyle(color: screen == 8 ? Colors.blueAccent : null),),
            onTap: () {
              screen = 8;
              Navigator.pop(context); // close the drawer
              Navigator.pushReplacementNamed(context, "/homework");
            },
          ),
          new ListTile(
            leading: new Icon(
              IconData(0xf0e5, fontFamily: "Material Design Icons"),
              color: screen == 3 ? Colors.blueAccent : null,),
            title: new Text(AppLocalizations.of(context).notes,
              style: TextStyle(color: screen == 3 ? Colors.blueAccent : null),),
            onTap: () {
              screen = 3;
              Navigator.pop(context); // close the drawer
              Navigator.pushReplacementNamed(context, "/notes");
            },
          ),
          new ListTile(
            leading: new Icon(
              Icons.block, color: screen == 5 ? Colors.blueAccent : null,),
            title: new Text(AppLocalizations.of(context).absent_title,
              style: TextStyle(color: screen == 5 ? Colors.blueAccent : null),),
            onTap: () {
              screen = 5;
              Navigator.pop(context); // close the drawer
              Navigator.pushReplacementNamed(context, "/absents");
            },
          ),
          new ListTile(
            leading: new Icon(
              IconData(0xf127, fontFamily: "Material Design Icons"),
              color: screen == 6 ? Colors.blueAccent : null,),
            title: new Text(AppLocalizations.of(context).statistics,
              style: TextStyle(color: screen == 6 ? Colors.blueAccent : null),),
            onTap: () {
              screen = 6;
              Navigator.pop(context); // close the drawer
              Navigator.pushReplacementNamed(context, "/statistics");
            },
          ),
          new ListTile(
            leading: new Icon(Icons.supervisor_account,
              color: screen == 4 ? Colors.blueAccent : null,),
            title: new Text(AppLocalizations.of(context).accounts,
              style: TextStyle(color: screen == 4 ? Colors.blueAccent : null),),
            onTap: () {
              screen = 4;
              Navigator.pop(context); // close the drawer
              Navigator.pushReplacementNamed(context, "/accounts");
            },
          ),
          new ListTile(
            leading: new Icon(
              Icons.settings, color: screen == 7 ? Colors.blueAccent : null,),
            title: new Text(AppLocalizations.of(context).settings,
              style: TextStyle(color: screen == 7 ? Colors.blueAccent : null),),
            onTap: () {
              screen = 7;
              Navigator.pop(context); // close the drawer
              Navigator.pushReplacementNamed(context, "/settings");
            },
          ),
        ],
      ),
      ),
    );
  }
}
