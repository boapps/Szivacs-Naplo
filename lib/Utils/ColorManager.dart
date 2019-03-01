import 'package:flutter/material.dart';
import 'package:flutter_naplo/globals.dart' as globals;

class ColorManager {

  Color getColorSample(int id){
    switch(id) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.red;
      case 2:
        return Colors.green;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.grey;
    }
  }

  ThemeData getTheme(brightness) {
    Color accent;
    Color primary;
    Color primaryLight;
    Color primaryDark = Color.fromARGB(255, 25, 25, 25);
    Color background;

    switch (globals.themeID) {
      case 0:
        accent = Colors.blueAccent;
        primaryLight = Colors.blue[700];
        break;
      case 1:
        accent = Colors.redAccent;
        primaryLight = Colors.red[700];
        break;
      case 2:
        accent = Colors.green;
        primaryLight = Colors.green[700];
        break;
      case 3:
        accent = Colors.yellow;
        primaryLight = Colors.yellow[700];
        break;
      case 4:
        accent = Colors.orangeAccent;
        primaryLight = Colors.orange[700];
        break;
      case 5:
        accent = Colors.blueGrey;
        primaryLight = Colors.grey[700];
        break;

    }

    if (brightness.index == 0) {
      primary = primaryDark;
      background = Color.fromARGB(255, 36, 36, 36);
    } else {
      primary = primaryLight;
      background = null;
    }

    if (globals.isAmoled && globals.isDark) {
      primary = Colors.black;
      background = Colors.black;
    }

    print(brightness.index);
    //globals.isDark = brightness.index == 0;
    return new ThemeData(
      primarySwatch: Colors.blue,
      accentColor: accent,
      brightness: brightness,
      primaryColor: primary,
      primaryColorLight: primaryLight,
      primaryColorDark: primaryDark,
      appBarTheme: AppBarTheme(
        color: primary,
      ),
      scaffoldBackgroundColor: background,
      dialogBackgroundColor: background,
      cardColor: brightness.index == 0 ? Color.fromARGB(255, 25, 25, 25) : null,
      fontFamily: 'Quicksand',
    );
  }
}