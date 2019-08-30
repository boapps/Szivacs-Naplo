library e_szivacs.globals;

import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'Datas/User.dart';
import 'Datas/Average.dart';
import 'Datas/Student.dart';
import 'Datas/Note.dart';
import 'Datas/Lesson.dart';
import 'Datas/Account.dart';

bool firstMain = true;
String version;
bool isLoggedIn = false;
bool isLogo = true;
bool isColor = true;
Map<String, List<Absence>> absents;
List searchres;
List jsonres;
List<User> users = new List<User>();
bool multiAccount;
bool isSingle;
User selectedUser;
String lang = "";
String selectedSchoolCode = "";
String selectedSchoolUrl = "";
String selectedSchoolName;
int screen = 0;
int sort = 0;
int selectedTimeForHomework = 1;
List<int> idoAdatok = [1, 7, 30, 60];
Average selectedAverage;
List<Evaluation> currentEvals = new List();
int themeID = 0;

List<Account> accounts = new List();
Account selectedAccount;

List<Evaluation> evals = new List();

bool isDark = false;
bool isAmoled = false;
bool canSyncOnData = true;

List<Evaluation> global_evals = new List();
List<Average> avers = new List();
Map<String, List<Absence>> global_absents = new Map();
List<Note> notes = new List();
List <Lesson> lessons = new List();

Color color1 = Colors.red;
Color color2 = Colors.brown;
Color color3 = Colors.orange;
Color color4 = Color.fromARGB(255, 255, 241, 118);
Color color5 = Colors.green;

DatabaseFactory dbFactory = databaseFactoryIo;

Database db;
var store = StoreRef.main();

