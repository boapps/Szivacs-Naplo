// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a hu locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

// ignore: unnecessary_new
final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'hu';

  static m0(amount) => "Összes hiányzás (nincs benne a késés): ${amount} óra";

  static m1(amount) => "Összes késés: ${amount} perc";

  static m2(name) => "Törölni szeretnéd ${name} felhasználót?";

  static m3(db) => "órák: ${db} db";

  static m4(amount) => "Szülői igazolás: ${amount} db";

  static m5(mins) => "Szinkronizálás gyakorisága: ${mins} perc";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "absence" : MessageLookupByLibrary.simpleMessage("hiányzás"),
    "absence_time" : MessageLookupByLibrary.simpleMessage("hiányzás ideje: "),
    "absences_title" : MessageLookupByLibrary.simpleMessage("Hiányzások"),
    "absent_title" : MessageLookupByLibrary.simpleMessage("Hiányzások / Késések"),
    "accounts" : MessageLookupByLibrary.simpleMessage("Fiókok"),
    "administration_time" : MessageLookupByLibrary.simpleMessage("naplózás ideje: "),
    "all_absences" : m0,
    "all_average" : MessageLookupByLibrary.simpleMessage("Összes jegy átlaga: "),
    "all_delay" : m1,
    "all_median" : MessageLookupByLibrary.simpleMessage("Összes jegy mediánja: "),
    "all_mode" : MessageLookupByLibrary.simpleMessage("Összes jegy módusza: "),
    "average" : MessageLookupByLibrary.simpleMessage("Átlag: "),
    "averages" : MessageLookupByLibrary.simpleMessage("Átlagok"),
    "boa" : MessageLookupByLibrary.simpleMessage("BoA"),
    "choose" : MessageLookupByLibrary.simpleMessage("válassz"),
    "choose_password" : MessageLookupByLibrary.simpleMessage("Kérlek add meg a jelszavadat!"),
    "choose_school" : MessageLookupByLibrary.simpleMessage("Válassz iskolát:"),
    "choose_school_warning" : MessageLookupByLibrary.simpleMessage("Válassz egy iskolát is"),
    "choose_username" : MessageLookupByLibrary.simpleMessage("Kérlek add meg a felhasználónevedet!"),
    "class_average" : MessageLookupByLibrary.simpleMessage("Osztályátlag: "),
    "colorful_mainpage" : MessageLookupByLibrary.simpleMessage("Színes főoldal"),
    "confirm_close" : MessageLookupByLibrary.simpleMessage("Be akarod zárni az alkalmazást?"),
    "dark_theme" : MessageLookupByLibrary.simpleMessage("Sötét téma"),
    "datas" : MessageLookupByLibrary.simpleMessage("Adatok"),
    "day" : MessageLookupByLibrary.simpleMessage("nap"),
    "deadline" : MessageLookupByLibrary.simpleMessage("határidő: "),
    "delay_mins" : MessageLookupByLibrary.simpleMessage("késés mértéke: "),
    "delete_confirmation" : m2,
    "dep_teacher" : MessageLookupByLibrary.simpleMessage("helyettesítő tanár"),
    "disclaimer" : MessageLookupByLibrary.simpleMessage("Ez egy nonprofit kliens alkalmazás az e-Kréta rendszerhez. \n\nMivel az appot nem az eKRÉTA Informatikai Zrt. készítette, ha ötleted van az appal kapcsolatban, kérlek ne az ő ügyfélszolgálatukat terheld, inkább írj nekünk egy e-mailt: \n\neszivacs@gmail.com\n"),
    "done" : MessageLookupByLibrary.simpleMessage("kész"),
    "email" : MessageLookupByLibrary.simpleMessage("eSzivacs@gmail.com"),
    "endyear" : MessageLookupByLibrary.simpleMessage("évvégi"),
    "evaluations" : MessageLookupByLibrary.simpleMessage("Jegyek"),
    "flutter" : MessageLookupByLibrary.simpleMessage("Flutter"),
    "github" : MessageLookupByLibrary.simpleMessage("GitHub"),
    "grade1" : MessageLookupByLibrary.simpleMessage("1-es osztályzat:"),
    "grade2" : MessageLookupByLibrary.simpleMessage("2-es osztályzat:"),
    "grade3" : MessageLookupByLibrary.simpleMessage("3-as osztályzat:"),
    "grade4" : MessageLookupByLibrary.simpleMessage("4-es osztályzat:"),
    "grade5" : MessageLookupByLibrary.simpleMessage("5-ös osztályzat:"),
    "group" : MessageLookupByLibrary.simpleMessage("osztály: "),
    "halfyear" : MessageLookupByLibrary.simpleMessage("félévi"),
    "homework" : MessageLookupByLibrary.simpleMessage("házi"),
    "homeworks" : MessageLookupByLibrary.simpleMessage("Házi feladatok"),
    "if_i_got" : MessageLookupByLibrary.simpleMessage("Ha kapnék egy..."),
    "info" : MessageLookupByLibrary.simpleMessage("Infó"),
    "instagram" : MessageLookupByLibrary.simpleMessage("Instagram"),
    "justification_mode" : MessageLookupByLibrary.simpleMessage("igazolás módja: "),
    "justification_state" : MessageLookupByLibrary.simpleMessage("igazolás állapota: "),
    "language" : MessageLookupByLibrary.simpleMessage("Nyelv"),
    "later" : MessageLookupByLibrary.simpleMessage("múlva"),
    "lesson_end" : MessageLookupByLibrary.simpleMessage("óra vége: "),
    "lesson_start" : MessageLookupByLibrary.simpleMessage("órakezdés: "),
    "lessons" : m3,
    "login" : MessageLookupByLibrary.simpleMessage("Bejelentkezés"),
    "logo_menu" : MessageLookupByLibrary.simpleMessage("Logó a menüben"),
    "made_by" : MessageLookupByLibrary.simpleMessage("készítette: "),
    "made_with" : MessageLookupByLibrary.simpleMessage("made with: "),
    "main_page" : MessageLookupByLibrary.simpleMessage("Főoldal"),
    "minute" : MessageLookupByLibrary.simpleMessage("perc"),
    "missed" : MessageLookupByLibrary.simpleMessage("elmarad"),
    "mode" : MessageLookupByLibrary.simpleMessage("mód: "),
    "month" : MessageLookupByLibrary.simpleMessage("hónap"),
    "network_error" : MessageLookupByLibrary.simpleMessage("hálózati probléma"),
    "next_day" : MessageLookupByLibrary.simpleMessage("következő nap"),
    "next_lesson" : MessageLookupByLibrary.simpleMessage("Következő óra: "),
    "next_week" : MessageLookupByLibrary.simpleMessage("következő hét"),
    "no" : MessageLookupByLibrary.simpleMessage("nem"),
    "no_lessons" : MessageLookupByLibrary.simpleMessage("Úgy néz ki ezen a napon nincs órád :)"),
    "notes" : MessageLookupByLibrary.simpleMessage("Feljegyzések"),
    "notification" : MessageLookupByLibrary.simpleMessage("Értesítés"),
    "ok" : MessageLookupByLibrary.simpleMessage("oké"),
    "parental_justification" : m4,
    "password" : MessageLookupByLibrary.simpleMessage("jelszó"),
    "password_hint" : MessageLookupByLibrary.simpleMessage("általában a születési dátum(pl.: 2000-01-02)"),
    "prev_day" : MessageLookupByLibrary.simpleMessage("előző nap"),
    "prev_week" : MessageLookupByLibrary.simpleMessage("előző hét"),
    "quarteryear" : MessageLookupByLibrary.simpleMessage("negyedéves"),
    "range" : MessageLookupByLibrary.simpleMessage("határ: "),
    "room" : MessageLookupByLibrary.simpleMessage("terem: "),
    "school" : MessageLookupByLibrary.simpleMessage("Iskola: "),
    "settings" : MessageLookupByLibrary.simpleMessage("Beállítások"),
    "short_friday" : MessageLookupByLibrary.simpleMessage("P"),
    "short_monday" : MessageLookupByLibrary.simpleMessage("H"),
    "short_saturday" : MessageLookupByLibrary.simpleMessage("Sz"),
    "short_sunday" : MessageLookupByLibrary.simpleMessage("V"),
    "short_thursday" : MessageLookupByLibrary.simpleMessage("Cs"),
    "short_tuesday" : MessageLookupByLibrary.simpleMessage("K"),
    "short_wednesday" : MessageLookupByLibrary.simpleMessage("Sz"),
    "singleuser_mainpage" : MessageLookupByLibrary.simpleMessage("Egy felhasználó a főoldalon"),
    "sort" : MessageLookupByLibrary.simpleMessage("Rendezés"),
    "sort_eval" : MessageLookupByLibrary.simpleMessage("jegy"),
    "sort_subject" : MessageLookupByLibrary.simpleMessage("tárgy"),
    "sort_time" : MessageLookupByLibrary.simpleMessage("idő"),
    "state" : MessageLookupByLibrary.simpleMessage("állapot: "),
    "statistics" : MessageLookupByLibrary.simpleMessage("Statisztikák"),
    "subject" : MessageLookupByLibrary.simpleMessage("tárgy: "),
    "sure" : MessageLookupByLibrary.simpleMessage("Biztos?"),
    "sync_frequency" : m5,
    "teacher" : MessageLookupByLibrary.simpleMessage("tanár: "),
    "telegram" : MessageLookupByLibrary.simpleMessage("Telegram"),
    "theme" : MessageLookupByLibrary.simpleMessage("téma: "),
    "time" : MessageLookupByLibrary.simpleMessage("idő: "),
    "timetable" : MessageLookupByLibrary.simpleMessage("Órarend"),
    "title" : MessageLookupByLibrary.simpleMessage("e-Szivacs"),
    "title_full" : MessageLookupByLibrary.simpleMessage("e-Szivacs 2"),
    "two_months" : MessageLookupByLibrary.simpleMessage("két hónap"),
    "upload_time" : MessageLookupByLibrary.simpleMessage("feltöltés ideje: "),
    "uploader" : MessageLookupByLibrary.simpleMessage("feltöltő: "),
    "username" : MessageLookupByLibrary.simpleMessage("felhasználónév"),
    "username_hint" : MessageLookupByLibrary.simpleMessage("oktatási azonosító 11-jegyű diákigazolványszám"),
    "value" : MessageLookupByLibrary.simpleMessage("érték: "),
    "version" : MessageLookupByLibrary.simpleMessage("verzió: "),
    "version_number" : MessageLookupByLibrary.simpleMessage("2.0"),
    "week" : MessageLookupByLibrary.simpleMessage("hét"),
    "weight" : MessageLookupByLibrary.simpleMessage("súly: "),
    "wrong_pass" : MessageLookupByLibrary.simpleMessage("hibás felasználónév vagy jelszó"),
    "yes" : MessageLookupByLibrary.simpleMessage("igen"),
    "youtube" : MessageLookupByLibrary.simpleMessage("YouTube")
  };
}
