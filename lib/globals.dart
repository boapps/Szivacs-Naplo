library flutter_naplo.globals;
import 'Datas/User.dart';
import 'Datas/Absence.dart';
import 'Datas/Average.dart';
import 'Datas/Evaluation.dart';

bool isLoggedIn = false;
bool isLogo = true;
List avers;
Map<String, List<Absence>> absents;
List searchres;
List jsonres;
List<User> users = new List<User>();
bool multiAccount;
User selectedUser;
String selectedSchoolCode = "";
String selectedSchoolUrl = "";
String selectedSchoolName = "Válassz";
int screen = 0;
int sort = 0;
int ido = 1;
List<String> idok = ["nap", "hét", "hónap", "két hónap"];
List<int> idoAdatok = [1, 7, 30, 60];
Average selectedAverage;
List<Evaluation> currentEvals = new List();

