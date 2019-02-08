import 'dart:async';
import 'dart:convert' show json, ascii, base64, utf8;
import 'dart:io';

import '../Datas/User.dart';
import '../main.dart';
import 'PlainSaver.dart' as PS;
import 'AccountManager.dart' ;

//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:pointycastle/random/fortuna_random.dart';
//import 'package:encrypt/encrypt.dart';
//import 'package:pointycastle/api.dart' show KeyParameter;
//import 'dart:typed_data';
//import 'dart:math';

//final storage = new FlutterSecureStorage();
//get encrypter async => new Encrypter(new AES(await key, iv));
//final iv = IV.fromLength(16);

//var rng = new Random();
/*
void initEncryption() async {

  Map<String, String> allValues = await storage.readAll();
  if (!allValues.containsKey("encryption")) {
    //todo ez kriptográfiailag biztonságos??
    Uint8List seed = new Uint8List.fromList(List.filled(32, (rng.nextInt(255))));
    FortunaRandom rnd = new FortunaRandom()..seed(new KeyParameter(seed));
    await storage.write(key: "encryption", value: String.fromCharCodes(rnd.nextBytes(32)));
    //await storage.write(key: "iv", value: String.fromCharCodes(rnd.nextBytes(16)));
  }

  if (await shouldMigrate)
    migrate();
}
*/
/*
Future<String> get key async {
  return await storage.read(key: "encryption");
}
*/
//Future<IV> get iv async {
//  return IV.fromBase64(base64.encode((await storage.read(key: "iv")).codeUnits));
//}

Future<String> doEncrypt(String text) async {
  return text;
//  Encrypted encrypted = (await encrypter).encrypt(text);
//  return encrypted.base64;
}

Future<String> doDecrypt(String text) async {
  return text;
//  try {
//    Encrypted encrypted = Encrypted(base64.decode(text));
//    return (await encrypter).decrypt(encrypted).toString().replaceAll(new RegExp('[\x00-\x09\x0B\x0C\x0E-\x1F\x7F]+'), '');
//  } catch (e) {
//    return "";
//  }
}

Future<String> get _localFolder async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> _localEvaluations(User user) async {
  final path = await _localFolder;
  String suffix = user.id.toString();
  return new File('$path/evaluations_$suffix.json');
}

Future<File> saveEvaluations(String evaluationsString, User user) async {
  final file = await _localEvaluations(user);

  return file.writeAsString(await doEncrypt(evaluationsString));
}

Future<String> readStudent(User user) async {
  try {
    final file = await _localEvaluations(user);
    String contents = await doDecrypt(await file.readAsString());
    return contents;
  } catch (e) {
    print(e);
  }
}

Future<File> _localEvents(User user) async {
  final path = await _localFolder;
  String suffix = user.id.toString();
  return new File('$path/events_$suffix.json');
}

Future<File> saveEvents(String eventsString, User user) async {
  final file = await _localEvents(user);
  return file.writeAsString(await doEncrypt(eventsString));
}

Future<String> readEventsString(User user) async {
  try {
    final file = await _localEvents(user);
    String contents = await doDecrypt(await file.readAsString());
    return contents;
  } catch (e) {
    print(e);
  }
}

Future<File> _localHomework(User user) async {
  final path = await _localFolder;
  String suffix = user.id.toString();
  return new File('$path/' + suffix + '_homework.json');
}

Future<File> saveHomework(String homeworkString, User user) async {
  final file = await _localHomework(user);
  return file.writeAsString(await doEncrypt(homeworkString));
}

Future<List<Map<String, dynamic>>> readHomework(User user) async {
  try {
    final file = await _localHomework(user);
    String contents = await doDecrypt(await file.readAsString());

    List<Map<String, dynamic>> notes = new List();
    List<dynamic> notesMap = json.decode(contents);
    for (dynamic note in notesMap)
      notes.add(note as Map<String, dynamic>);

    return notes;
  } catch (e) {
    return new List();
  }
}


Future<File> _localTimeTable(String time, User user) async {
  final path = await _localFolder;
  String suffix = user.id.toString();
  return new File('$path/timetable_$time-$suffix.json');
}

Future<File> saveTimetable(String timetableString, String time, User user) async {
  final file = await _localTimeTable(time, user);

  return file.writeAsString(await doEncrypt(timetableString));
}

Future<List<dynamic>> readTimetable(String time, User user) async {
  try {
    final file = await _localTimeTable(time, user);
    String contents = await doDecrypt(await file.readAsString());

    List<dynamic> timetableMap = json.decode(contents);
    return timetableMap;
  } catch (e) {
  }
}

Future<File> get _localSettings async {
  final path = await _localFolder;
  return new File('$path/settings.json');
}

Future<File> saveSettings(String settingsString) async {
  final file = await _localSettings;

  return file.writeAsString(await doEncrypt(settingsString));
}

void migrate() async {
  saveSettings(json.encode(await PS.readSettings()));

  String usrs = await (await _userFile).readAsString();
  (await _userFile).writeAsString(await doEncrypt(usrs));

  List<User> users = await AccountManager().getUsers();

  for (User u in users){
    saveEvaluations(json.encode(await PS.readEvaluations(u)), u);
    saveEvents(json.encode(await PS.readEvents(u)), u);
    saveHomework(json.encode(await PS.readHomework(u)), u);
  }

  main();
}

Future<File> get _userFile async {
  final path = await _localFolder;
  return new File('$path/users.json');
}

Future<File> saveUsers(List<User> users) async {
  print("save");
  final file = await _userFile;
  List<Map<String, dynamic>> userMap = new List();
  for (User user in users)
    userMap.add(user.toMap());
  return file.writeAsString(await doEncrypt(json.encode(userMap)));
}

Future<List<Map<String, dynamic>>> readUsers() async {
  List<Map<String, dynamic>> userMap = new List();
  final file = await _userFile;
  String contents;
  List<dynamic> userlist = new List<dynamic>();
  try {
    contents = await doDecrypt(await file.readAsString());
    print(contents);
    userlist = json.decode(contents);
  } catch (error) {
    print(error);
    contents = "";
  }

  for (dynamic d in userlist)
    userMap.add(d as Map<String, dynamic>);

  return userMap;
}

Future<bool> get shouldMigrate async {
  return false;
  try {
    final file = await _userFile;
    String contents;
    contents = file.readAsStringSync();
    if (contents == "")
      return false;
    return (contents.contains("username" ) && contents.contains("password"));
  } catch (e) {
    print(e);
    return false;
  }
}

Future<Map<String, dynamic>> readSettings() async {
  try {
    final file = await _localSettings;
    String contents = await file.readAsString();

    Map<String, dynamic> settingsMap = json.decode(await doDecrypt(contents));
    return settingsMap;
  } catch (e) {
    return new Map();
  }
}
