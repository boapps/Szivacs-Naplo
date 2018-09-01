import 'package:flutter/material.dart';
import 'globals.dart';

Widget GlobalDrawer(BuildContext context) {

  return new Drawer(
    child: new ListView(
      children: <Widget>[
        new Container(
          child: new DrawerHeader(
            child: new Column(
              children: <Widget>[
                Image.asset(
                  "assets/icon.png",
//                  alignment: new Alignment(-1.0, 1.0),
                  height: 160.0,
                  width: 160.0,
                ),
                new Row(
                  children: <Widget>[
                    new Container(
                      child: new Text(
                        "e-Szivacs",
                        style: TextStyle(fontSize: 19.0),
                      ),
//                      alignment: new Alignment(-1.0, 1.0),
                      padding: new EdgeInsets.fromLTRB(16.0, 0.0, 5.0, 0.0),
                    ),
                    new Container(
                      child: new Text(
                        "2.0",
                        style:
                            TextStyle(fontSize: 19.0, color: Colors.blueAccent),
                      ),
//                      alignment: new Alignment(-1.0, 1.0),
                    ),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Container(
                      child: new Text(
                        "made by:",
                        style: TextStyle(
                          fontSize: 19.0,
                        ),
                      ),
//                      alignment: new Alignment(-1.0, 1.0),
                      padding: new EdgeInsets.fromLTRB(16.0, 0.0, 5.0, 4.0),
                    ),
                    new Container(
                      child: new Text(
                        "BoA",
                        style:
                        TextStyle(fontSize: 19.0, color: Colors.blueAccent),
                      ),
//                      alignment: new Alignment(-1.0, 1.0),
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
          height: 238.0,
        ),
        new ListTile(
          leading: new Icon(Icons.home, color: screen==0 ? Colors.blue:null,),
          title: new Text("Főoldal",style: TextStyle(color: screen==0 ? Colors.blue:null),),
          onTap: () {
            screen=0;
            Navigator.pop(context); // close the drawer
            Navigator.pushReplacementNamed(context, "/main");
          },
        ),
        new ListTile(
          leading: new Icon(Icons.assignment, color: screen==1 ? Colors.blue:null,),
          title: new Text("Jegyek",style: TextStyle(color: screen==1 ? Colors.blue:null),),
          onTap: () {
            screen=1;
            Navigator.pop(context); // close the drawer
            Navigator.pushReplacementNamed(context, "/evaluations");
          },
        ),
        new ListTile(
          leading: new Icon(IconData(0xf520, fontFamily: "Material Design Icons"), color: screen==2 ? Colors.blue:null,),
          title: new Text("Órarend",style: TextStyle(color: screen==2 ? Colors.blue:null),),
          onTap: () {
            screen=2;
            Navigator.pop(context); // close the drawer
            Navigator.pushReplacementNamed(context, "/timetable");
          },
        ),
        new ListTile(
          leading: new Icon(IconData(0xf0e5, fontFamily: "Material Design Icons"), color: screen==3 ? Colors.blue:null,),
          title: new Text("Faliújság",style: TextStyle(color: screen==3 ? Colors.blue:null),),
          onTap: () {
            screen=3;
            Navigator.pop(context); // close the drawer
            Navigator.pushReplacementNamed(context, "/notes");
          },
        ),
        new ListTile(
          leading: new Icon(Icons.supervisor_account, color: screen==4 ? Colors.blue:null,),
          title: new Text("Fiókok",style: TextStyle(color: screen==4 ? Colors.blue:null),),
          onTap: () {
            screen=4;
            Navigator.pop(context); // close the drawer
            Navigator.pushReplacementNamed(context, "/accounts");
          },
        ),
        new ListTile(
          leading: new Icon(Icons.block, color: screen==5 ? Colors.blue:null,),
          title: new Text("Hiányzások",style: TextStyle(color: screen==5 ? Colors.blue:null),),
          onTap: () {
            screen=5;
            Navigator.pop(context); // close the drawer
            Navigator.pushReplacementNamed(context, "/absents");
          },
        ),
        new ListTile(
          leading: new Icon(Icons.info, color: screen==6 ? Colors.blue:null,),
          title: new Text("Infó",style: TextStyle(color: screen==6 ? Colors.blue:null),),
          onTap: () {
            screen=6;
            Navigator.pop(context); // close the drawer
            Navigator.pushReplacementNamed(context, "/about");
//            Navigator.pushNamed(context, "/about");
          },
        ),
        new ListTile(
          leading: new Icon(Icons.settings, color: screen==7 ? Colors.blue:null,),
          title: new Text("Beállítások",style: TextStyle(color: screen==7 ? Colors.blue:null),),
          onTap: () {
            screen=7;
            Navigator.pop(context); // close the drawer
            Navigator.pushReplacementNamed(context, "/settings");
//            Navigator.pushNamed(context, "/about");
          },
        ),
      ],
    ),
  );
}
