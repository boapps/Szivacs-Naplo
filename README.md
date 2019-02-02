# e-Szivacs 2.0

Az e-Szivacs 2: egy multiplatformos kliensalkalmazás az e-Kréta rendszerhez.

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
* `git clone https://github.com/boapps/e-Szivacs-2`
* `cd e-Szivacs-2`
* `git clone -b "v2.0" https://github.com/leocavalcante/encrypt/`

* `flutter build apk --debug` vagy `flutter run`

<a href='https://play.google.com/store/apps/details?id=io.github.boapps.meSzivacs&pcampaignid=MKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Szerezd meg: Google Play' src='https://play.google.com/intl/en_us/badges/images/generic/hu_badge_web_generic.png' height=56px /></a>
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
Copyright (c) 2019, boapps
Minden jog fenntartva.

A forrás és bináris formában való újraterjesztés és használat, módosításokkal vagy anélkül is engedélyezett, feltéve, hogy a következő feltételek teljesülnek:

1. A forráskód újraterjesztésénél kötelező alkalmazni a fenti copyright felhívást, az itt található feltételeket és a következőkben olvasható korlátozott felelősségi nyilatkozatot.
2. A bináris formában való újraterjesztés esetén a binárishoz adott dokumentációban és/vagy egyéb anyagban kötelező idézni a fenti copyright felhívást, az itt található feltételeket és a következőkben olvasható korlátozott felelősségi nyilatkozatot.

EZT A SZOFTVERT A(Z) boapps ÉS A KÖZREMŰKÖDŐK "AHOGY VAN" SZOLGÁLTATJÁK ÉS MINDEN NYÍLT VAGY BURKOLT GARANCIAJOGOT VISSZAUTASÍTANAK VELE KAPCSOLATBAN - BELEÉRTVE DE NEM KIZÁRÓLAGOSAN KORLÁTOZVA AZ ELADHATÓSÁGRA, VAGY EGY ADOTT CÉLRA VALÓ ALKALMAZHATÓSÁGRA VONATKOZÓ GARANCIÁT. A boapps ÉS A KÖZREMŰKÖDŐK NEM VONHATÓK SEMMILYEN SZINTŰ FELELŐSSÉGRE -, MELYET AKÁR SZERZŐDÉSBEN RENDEZETT, VAGY SZERZŐDÉSEN KÍVÜLI FELELŐSSÉGVISZONY ALAPJÁN ÁLLAPÍTANÁNAK MEG (BELEÉRTVE A HANYAGSÁG VAGY MÁS MIATT KIALAKULÓ VISZONYT IS), SEMMILYEN A SZOFTVER HASZNÁLATÁBÓL EREDŐ ESEMÉNY KAPCSÁN MELY KÖZVETLEN, KÖZVETETT, VÉLETLENSZERŰ, KÜLÖNLEGES, PÉLDÁTLAN VAGY SZÜKSÉGSZERŰEN BEKÖVETKEZŐ KÁRHOZ VEZET (BELEÉRTVE A KÁROK KÖZÉ DE NEM KIZÁRÓLAGOSAN KORLÁTOZVA AZT A HELYETTESÍTŐ TERMÉKEK VAGY SZOLGÁLTATÁSOK BESZERZÉSÉRE, ÜZEMKIESÉSRE, ADATVESZTÉSRE, ELMARADT HASZONRA, VAGY ÜZLETMENET MEGSZAKADÁSÁRA) MÉG AKKOR SEM HA A KÁROSODÁS LEHETŐSÉGE ELŐRE LÁTHATÓ VOLT.

### Eredeti (angol nyelvű) licenc:
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
