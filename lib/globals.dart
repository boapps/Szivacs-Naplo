library e_szivacs.globals;

import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'Datas/User.dart';
import 'Datas/Average.dart';
import 'Datas/Student.dart';
import 'Datas/Note.dart';
import 'Datas/Homework.dart';
import 'Datas/Lesson.dart';
import 'Datas/Account.dart';
// ad_start
import 'package:firebase_admob/firebase_admob.dart';
// ad_end

bool firstMain = true;
String version;
String latestVersion = "";
bool isBeta = false;
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
String htmlFAQ = "betöltés...";

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
//FF9700
//
Color color4 = Color.fromARGB(255, 255, 151, 0);
Color color5 = Colors.green;

DatabaseFactory dbFactory = databaseFactoryIo;

Database db;
var store = StoreRef.main();

List<Homework> currentHomeworks = List();

// ad_start
bool isAds = false;
BannerAd myBanner;
double adHeight;
bool loaded = false;
// ad_end
