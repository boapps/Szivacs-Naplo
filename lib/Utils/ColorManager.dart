import 'package:flutter/material.dart';
import 'package:e_szivacs/globals.dart' as globals;

Color getColors(BuildContext context, int value, bool getBackground) {
    switch (value) { //Define background and foreground color of the card for number values.
        case 1:
          return getBackground
          ? globals.color1
          : globals.colorF1;
        case 2:
          return getBackground
          ? globals.color2
          : globals.colorF2;
        case 3:
          return getBackground
          ? globals.color3
          : globals.colorF3;
        case 4:
          return getBackground
          ? globals.color4
          : globals.colorF4;
        case 5:
          return getBackground
          ? globals.color5
          : globals.colorF5;
        default:
          return getBackground
          ? Colors.white
          : Colors.black;
  }
}

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
        return Colors.lightGreen;
      case 4:
        return Colors.yellow;
      case 5:
        return Colors.orangeAccent;
      case 6:
        return Colors.grey;
      case 7:
        return Colors.pink;
      case 8:
        return Colors.purple;
      case 9:
        return Colors.teal;
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
        accent = Colors.blue;
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
        accent = Colors.lightGreen;
        primaryLight = Colors.lightGreen[700];
        break;
      case 4:
        accent = Colors.yellow;
        primaryLight = Colors.yellow[700];
        break;
      case 5:
        accent = Colors.orangeAccent;
        primaryLight = Colors.orangeAccent[400];
        break;
      case 6:
        accent = Colors.blueGrey;
        primaryLight = Colors.grey[700];
        break;
      case 7:
        accent = Colors.pink;
        primaryLight = Colors.pink[700];
        break;
      case 8:
        accent = Colors.purple;
        primaryLight = Colors.purple[700];
        break;
      case 9:
        accent = Colors.teal;
        primaryLight = Colors.teal[700];
        break;

    }

    if (brightness.index == 0) {
      primary = primaryDark;
      background = Color.fromARGB(255, 40, 40, 40);
    } else {
      primary = primaryLight;
      background = null;
    }

    if (globals.isAmoled && globals.isDark) {
      primary = Colors.black;
      background = Colors.black;
    }

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