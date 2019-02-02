import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
    locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get title {
    return Intl.message('e-Szivacs',
        name: 'title', desc: 'The application title');
  }

  String get title_full {
    return Intl.message('e-Szivacs 2', name: 'title_full');
  }

  String get version {
    return Intl.message('verzió: ', name: 'version');
  }

  String get version_number {
    return Intl.message('2.0', name: 'version_number');
  }

  String get made_by {
    return Intl.message('készítette: ', name: 'made_by');
  }

  String get boa {
    return Intl.message('BoA', name: 'boa');
  }

  String get made_with {
    return Intl.message('made with: ', name: 'made_with');
  }

  String get flutter {
    return Intl.message('Flutter', name: 'flutter');
  }

  String get youtube {
    return Intl.message('YouTube', name: 'youtube');
  }

  String get telegram {
    return Intl.message('Telegram', name: 'telegram');
  }

  String get email {
    return Intl.message('eSzivacs@gmail.com', name: 'email');
  }

  String get github {
    return Intl.message('GitHub', name: 'github');
  }

  String get instagram {
    return Intl.message('Instagram', name: 'instagram');
  }



  String get absent_title {
    return Intl.message('Hiányzások / Késések', name: 'absent_title');
  }

  String get mode {
    return Intl.message('mód: ', name: 'mode');
  }

  String get subject {
    return Intl.message('tárgy', name: 'subject');
  }

  String get teacher {
    return Intl.message('tanár', name: 'teacher');
  }

  String get absence_time {
    return Intl.message('hiányzás ideje: ', name: 'absence_time');
  }

  String get administration_time {
    return Intl.message('naplózás ideje: ', name: 'administration_time');
  }

  String get justification_state {
    return Intl.message('igazolás állapota: ', name: 'justification_state');
  }

  String get justification_mode {
    return Intl.message('igazolás módja: ', name: 'justification_mode');
  }

  String get delay_mins {
    return Intl.message('késés mértéke: ', name: 'delay_mins');
  }

  String get ok {
    return Intl.message('oké', name: 'ok');
  }

  String get statistics {
    return Intl.message('Statisztikák', name: 'statistics');
  }

  String parental_justification(int amount) => Intl.message('Szülői igazolás: '
      '$amount db', name: 'parental_justification', args: [amount],
  );

  String all_absences (int amount) => Intl.message('Összes hiányzás '
      '(nincs benne a késés): $amount óra', name: 'all_absences', args: [amount]);

  String all_delay (int amount) => Intl.message(
      'Összes késés: $amount perc', name: 'all_delay', args: [amount]);



  String get sure {
    return Intl.message("Biztos?", name: "sure");
  }

  String delete_confirmation (String name) {
    return Intl.message("Törölni szeretnéd $name felhasználót?", args: [name], name: "delete_confirmation");
  }

  String get no {
    return Intl.message("nem", name: "no");
  }

  String get yes {
    return Intl.message("igen", name: "yes");
  }

  String get accounts {
    return Intl.message("Fiókok", name: "accounts");
  }




  String get evaluations {
    return Intl.message("Jegyek", name: "evaluations");
  }

  String get theme {
    return Intl.message("téma: ", name: "theme");
  }

  String get time {
    return Intl.message("idő: ", name: "time");
  }

  String get weight {
    return Intl.message("súly", name: "weight");
  }

  String get value {
    return Intl.message("érték", name: "value");
  }

  String get range {
    return Intl.message("határ", name: "range");
  }

  String get sort {
    return Intl.message("Rendezés", name: "sort");
  }




  String get homeworks {
    return Intl.message("Házi feladatok", name: "homeworks");
  }

  String get homework {
    return Intl.message("házi", name: "homework");
  }

  String get deadline {
    return Intl.message("határidő: ", name: "deadline");
  }

  String get uploader {
    return Intl.message("feltöltő: ", name: "uploader");
  }

  String get upload_time {
    return Intl.message("feltöltés ideje: ", name: "upload_time");
  }



  String get confirm_close {
    return Intl.message("Be akarod zárni az alkalmazást?", name: "confirm_close");
  }



  String get notes {
    return Intl.message("Feljegyzések", name: "notes");
  }



  String get settings {
    return Intl.message("Beállítások", name: "settings");
  }

  String get colorful_mainpage {
    return Intl.message("Színes főoldal", name: "colorful_mainpage");
  }

  String get singleuser_mainpage {
    return Intl.message("Egy felhasználó a főoldalon", name: "singleuser_mainpage");
  }

  String get dark_theme {
    return Intl.message("Sötét téma", name: "dark_theme");
  }

  String get notification {
    return Intl.message("Értesítés", name: "notification");
  }

  String sync_frequency (int mins) {
    return Intl.message("Szinkronizálás gyakorisága: $mins perc", args: [mins],
        name: "sync_frequency");
  }

  String get minute {
    return Intl.message("perc", name: "minute");
  }

  String get logo_menu {
    return Intl.message("Logó a menüben", name: "logo_menu");
  }

  String get info {
    return Intl.message("Infó", name: "info");
  }



  String get average {
    return Intl.message("Átlag: ", name: "average");
  }

  String get class_average {
    return Intl.message("Osztályátlag: ", name: "class_average");
  }

  String get grade1 {
    return Intl.message("1-es osztályzat:", name: "grade1");
  }

  String get grade2 {
    return Intl.message("2-es osztályzat:", name: "grade2");
  }

  String get grade3 {
    return Intl.message("3-as osztályzat:", name: "grade3");
  }

  String get grade4 {
    return Intl.message("4-es osztályzat:", name: "grade4");
  }

  String get grade5 {
    return Intl.message("5-ös osztályzat:", name: "grade5");
  }

  String get all_average {
    return Intl.message("Összes jegy átlaga: ", name: "all_average");
  }

  String get all_median {
    return Intl.message("Összes jegy mediánja:", name: "all_median");
  }

  String get all_mode {
    return Intl.message("Összes jegy módusza:", name: "all_mode");
  }

  String get averages {
    return Intl.message("Átlagok", name: "averages");
  }

  String get datas {
    return Intl.message("Adatok", name: "datas");
  }

  String get done {
    return Intl.message("kész", name: "done");
  }




  String get timetable {
    return Intl.message("Órarend", name: "timetable");
  }

  String get no_lessons {
    return Intl.message("Úgy néz ki ezen a napon nincs órád :)", name: "no_lessons");
  }

  String get prev_week {
    return Intl.message("előző hét", name: "prev_week");
  }

  String get next_week {
    return Intl.message("következő hét", name: "next_week");
  }

  String get prev_day {
    return Intl.message("előző nap", name: "prev_day");
  }

  String get next_day {
    return Intl.message("következő nap", name: "next_day");
  }

  String get group {
    return Intl.message("osztály: ", name: "group");
  }

  String get room {
    return Intl.message("terem: ", name: "room");
  }

  String get lesson_start {
    return Intl.message("órakezdés: ", name: "lesson_start");
  }

  String get lesson_end {
    return Intl.message("óra vége: ", name: "lesson_end");
  }

  String get state {
    return Intl.message("állapot: ", name: "state");
  }

  String get dep_teacher {
    return Intl.message("helyettesítő tanár", name: "dep_teacher");
  }

  String get missed {
    return Intl.message("elmarad", name: "missed");
  }

  String get short_monday {
    return Intl.message("H", name: "short_monday");
  }

  String get short_tuesday {
    return Intl.message("K", name: "short_tuesday");
  }

  String get short_wednesday {
    return Intl.message("Sz", name: "short_wednesday");
  }

  String get short_thursday {
    return Intl.message("Cs", name: "short_thursday");
  }

  String get short_friday {
    return Intl.message("P", name: "short_friday");
  }

  String get short_saturday {
    return Intl.message("Sz", name: "short_saturday");
  }

  String get short_sunday {
    return Intl.message("V", name: "short_sunday");
  }




  String get choose {
    return Intl.message("válassz", name: "choose");
  }

  String get day {
    return Intl.message("nap", name: "day");
  }

  String get week {
    return Intl.message("hét", name: "week");
  }

  String get month {
    return Intl.message("hónap", name: "month");
  }

  String get two_months {
    return Intl.message("két hónap", name: "two_months");
  }




  String get disclaimer {
    return Intl.message("Ez egy nonprofit kliens alkalmazás az e-Kréta "
        "rendszerhez. \n\nMivel az appot nem az eKRÉTA Informatikai Zrt. "
        "készítette, ha ötleted van az appal kapcsolatban, kérlek ne az ő "
        "ügyfélszolgálatukat terheld, inkább írj nekünk egy e-mailt: "
        "\n\neszivacs@gmail.com\n", name: "disclaimer");
  }

  String get choose_username {
    return Intl.message("Kérlek add meg a felhasználónevedet!", name: "choose_username");
  }

  String get choose_password {
    return Intl.message("Kérlek add meg a jelszavadat!", name: "choose_password");
  }

  String get wrong_pass {
    return Intl.message("hibás felasználónév vagy jelszó", name: "wrong_pass");
  }

  String get network_error {
    return Intl.message("hálózati probléma", name: "network_error");
  }

  String get username {
    return Intl.message("felhasználónév", name: "username");
  }

  String get username_hint {
    return Intl.message("oktatási azonosító 11-jegyű diákigazolványszám", name: "username_hint");
  }

  String get password {
    return Intl.message("jelszó", name: "password");
  }

  String get password_hint {
    return Intl.message("általában a születési dátum(pl.: 2000-01-02)", name: "password_hint");
  }

  String get school {
    return Intl.message("Iskola: ", name: "school");
  }

  String get choose_school_warning {
    return Intl.message("Válassz egy iskolát is", name: "choose_school_warning");
  }

  String get login {
    return Intl.message("Bejelentkezés", name: "login");
  }

  String get choose_school {
    return Intl.message("Válassz iskolát:", name: "choose_school");
  }




  String lessons (int db) {
    return Intl.message("órák: $db db", args: [db], name: "lessons");
  }

  String get absence {
    return Intl.message("hiányzás", name: "absence");
  }

  String get next_lesson {
    return Intl.message("Következő óra: ", name: "next_lesson");
  }

  String get later {
    return Intl.message("múlva", name: "later");
  }

  String get main_page {
    return Intl.message("Főoldal", name: "main_page");
  }

  String get absences_title {
    return Intl.message("Hiányzások", name: "absences_title");
  }

  String get sort_time {
    return Intl.message("idő", name: "sort_time");
  }

  String get sort_eval {
    return Intl.message("jegy", name: "sort_eval");
  }

  String get sort_subject {
    return Intl.message("tárgy", name: "sort_subject");
  }

  String get if_i_got {
    return Intl.message("Ha kapnék egy...", name: "if_i_got");
  }

  String get language {
    return Intl.message("nyelv", name: "language");
  }

  String get halfyear {
    return Intl.message("félévi", name: "halfyear");
  }

  String get endyear {
    return Intl.message("évvégi", name: "endyear");
  }

  String get quarteryear {
    return Intl.message("negyedéves", name: "quarteryear");
  }

  String get notworking {
    return Intl.message("nem működik", name: "notworking");
  }

  String get dep {
    return Intl.message("helyettesítés", name: "dep");
  }

  String get lesson {
    return Intl.message("óra", name: "lesson");
  }

}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['hu', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}