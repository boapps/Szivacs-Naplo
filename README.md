# Szivacs Napló
Ez a 100% FOSS, reklámmentes verziója a Szivacs Naplónak. Van egy play-edition branch is, amiben a Google Play áruházas verziónak a forráskódja van és amiben vannak opcionális (bekapcsolható, de alapból kikapcsolt) reklámok. Ígérem, hogy soha nem lesz erőltetett reklám a szivacsban és mindig lesz egy "Google Play Services"-mentes teljesen FOSS verziója is az appnak.

A Szivacs Napló: egy multiplatformos kliensalkalmazás az e-napló rendszerhez.

Ez a második verziója a nemhivatalos e-Szivacs alkalmazásnak, amit azért írtam, mert idegesítettek az eredeti app hibái (lassú, bugos, stb.).

#### Jelenlegi funkciók:
* meg tudod nézni a jegyeidet, hiányzásaidat, órarendedet és a "faliújságot"
* több fiókkal be tudsz jelentkezni és nem kell átlépegetned egyikből a másikba hanem egyszerre látod az összes jegyet
* gyors, logikus, modern felület
* *sötét* téma (az e-Kréta app fejlesztő(i)ről elnevezve)
* "színes főoldal"
* értesítések
* grafikonok
#### Tervezett:
Issuekban vannak

#### Project felállításához instrukciók:
* `git clone https://github.com/boapps/Szivacs-Naplo
* `cd Szivacs-Naplo`
* `flutter build apk --debug` vagy `flutter run`

<a href='https://play.google.com/store/apps/details?id=io.github.boapps.meSzivacs&pcampaignid=MKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Szerezd meg: Google Play' src='https://play.google.com/intl/en_us/badges/images/generic/hu_badge_web_generic.png' height=56px /></a>

#### iOS verzió:
Az alkalmazás működik iOS-en is, mert Flutterben készült, de az AppStore-ba nem tettem fel, mert akkor a nevem publikussá válna és én azt nem szeretném :P

[hajducsekb](https://github.com/hajducsekb) [legyártott egy .ipa fájlt](https://www.dropbox.com/s/3vzrqagpfhb6g8l/flutter_naplo.ipa?dl=0), amit Cydia Impactorral fel lehet telepíteni. [további infó](https://github.com/boapps/e-Szivacs-2/issues/30)

##### Felhasznált nyílt forráskódú projectek:
* [Fira GO](https://github.com/bBoxType/FiraGO) - betűtípus
* [Flutter](https://github.com/flutter/flutter) - alkalmazásfejlesztési keretrendszer (ezzel csináltam az appot)
* Flutter kiegészítők:
  * [dynamic_theme](https://github.com/Norbert515/dynamic_theme) - a sötét témához
  * [Fluro](https://github.com/theyakka/fluro)
  * [Flutter Launcher Icons](https://github.com/fluttercommunity/flutter_launcher_icons)
  * [charts_flutter](https://github.com/google/charts)
  * [Flutter Local Notifications Plugin](https://github.com/MaikuB/flutter_local_notifications)
  * [flutter_html_view](https://github.com/PonnamKarthik/FlutterHtmlView)
  * [html_unescape](https://github.com/filiph/html_unescape)
  * [background_fetch](https://github.com/transistorsoft/flutter_background_fetch)

### Licenc:
BSD 2-Clause License

Copyright (c) 2019, boapps
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
