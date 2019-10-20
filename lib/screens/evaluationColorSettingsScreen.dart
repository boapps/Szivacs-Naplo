import 'dart:ui';

import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import '../GlobalDrawer.dart';
import '../Helpers/SettingsHelper.dart';
import '../globals.dart' as globals;

class colorSettingsScreen extends StatefulWidget {
  @override
  colorSettingsScreenState createState() => new colorSettingsScreenState();
}

class colorSettingsScreenState extends State<colorSettingsScreen> {
  List<Color> evalColors = [
    Colors.red,
    Colors.brown,
    Colors.orange,
    Color.fromARGB(255, 255, 241, 118),
    Colors.green
  ];
  Color selected;

  void _openDialog(String title, Widget content, int n) {
    showDialog(
      context: context,
      builder: (dialogCtx) =>
          AlertDialog(
            contentPadding: const EdgeInsets.all(6.0),
            title: Text(title),
            content: content,
            actions: [
              FlatButton(
                child: Text(S.of(context).no),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(S.of(context).ok),
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (selected != null) {
                    SettingsHelper().setEvalColor(n, selected).then((var a) async {
                      globals.color1 = await SettingsHelper().getEvalColor(0);
                      globals.color2 = await SettingsHelper().getEvalColor(1);
                      globals.color3 = await SettingsHelper().getEvalColor(2);
                      globals.color4 = await SettingsHelper().getEvalColor(3);
                      globals.color5 = await SettingsHelper().getEvalColor(4);
                      setState(() {});
                    });
                  }
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          globals.screen = 7;
          //Navigator.pushReplacementNamed(context, "/settings");
          return true;
        },
        child: Scaffold(
          drawer: GDrawer(),
          appBar: new AppBar(
            title: new Text(S
                .of(context)
                .title),
            actions: <Widget>[
            ],
          ),
          body:
          new Center(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(S
                      .of(context)
                      .grade1),
                  trailing: new Container(
                    child: new FlatButton(onPressed: () {
                      _openDialog(S
                          .of(context)
                          .color, MaterialColorPicker(
                        selectedColor: selected, onColorChange: (Color c) =>
                      selected = c,), 0);
                    },
                      child: new Icon(
                          Icons.color_lens, color: globals.color1),),
                  ),
                ),
                ListTile(
                  title: Text(S
                      .of(context)
                      .grade2),
                  trailing: new Container(
                    child: new FlatButton(onPressed: () {
                      _openDialog(S
                          .of(context)
                          .color, MaterialColorPicker(
                        selectedColor: selected, onColorChange: (Color c) =>
                      selected = c,), 1);
                    },
                      child: new Icon(
                          Icons.color_lens, color: globals.color2),),
                  ),
                ),
                ListTile(
                  title: Text(S
                      .of(context)
                      .grade3),
                  trailing: new Container(
                    child: new FlatButton(onPressed: () {
                      _openDialog(S
                          .of(context)
                          .color, MaterialColorPicker(
                        selectedColor: selected, onColorChange: (Color c) =>
                      selected = c,), 2);
                    },
                      child: new Icon(
                          Icons.color_lens, color: globals.color3),),
                  ),
                ),
                ListTile(
                  title: Text(S
                      .of(context)
                      .grade4),
                  trailing: new Container(
                    child: new FlatButton(onPressed: () {
                      _openDialog(S
                          .of(context)
                          .color, MaterialColorPicker(
                        selectedColor: selected, onColorChange: (Color c) =>
                      selected = c,), 3);
                    },
                      child: new Icon(
                          Icons.color_lens, color: globals.color4),),
                  ),
                ),
                ListTile(
                  title: Text(S
                      .of(context)
                      .grade5),
                  trailing: new Container(
                    child: new FlatButton(onPressed: () {
                      _openDialog(S
                          .of(context)
                          .color, MaterialColorPicker(
                        selectedColor: selected, onColorChange: (Color c) =>
                      selected = c,), 4);
                    },
                      child: new Icon(
                          Icons.color_lens, color: globals.color5),),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
