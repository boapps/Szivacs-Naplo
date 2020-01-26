
# A projekt vége

A krétások(?) lassítása miatt a szivacs gyakorlatilag használhatatlanná vált több iskolában, ezért a fejlesztést abbahagyom, több frissítést nem tervezek kiadni. A lassítás okát nem árulták el, emailekre nem válaszolnak. Érdekes, hogy azt írták a weboldalukon, hogy engedik a nem hivatalos alkalmazások fejlesztését illetve emailes megkérdezésre ezt korábban kiegészítették a bevételt szerző alkalmazásokra is (itt direkt úgy kérdeztem rá, hogy a kréta apit használó alkalmazások). Azóta ezt nem vonták vissza, nekem nem tiltották meg a szivacs fejlesztését (habár felvetettek adatvédelmi és szerzői jogi gondokat, ezeknek szerintem azóta eleget tettem többek között az alkalmazás átnevezésével, illetve az adatvédelemmel nem értettem egyet, azt a naih vizsgálja). Helyette sunyin lassítják bizonyos iskolákban, amik felhasználói visszajelzések alpján klikes suliknak tűnnek, de olyan üzenetet is kaptam már, hogy van olyan klikes iskola, ahol még rendesen megy a szivacs.

Bocsánatot kérek azoktól, akiknek a hibáit nem fogom javítani, kifejezetten az értesítésekkel kapcsolatban. Köszönöm mindenkinek, aki segített commitokkal, szerverrel, ötletekkel, hibajelentésekkel és értékes információval! Az amúgy opcionális reklámokat már teljesen kiszedtem, többé bevételem nincs a szivacsból, valami 1500 Ft körüli összeg jött össze, amit ki se tudok venni az admobból, mert nem éri el azt a minimumot, amitől kivehetném. :pensive:

A repot és az alkalmázást nem tervezem leszedni, amíg a krétások nem mondják azt, hogy tilos a fejlesztés, de több commitot ne várjatok tőlem. A BSD licensz alapján forkolni szabad (természetesen legális kereteken belül), ha megnevezel, annak örülök, de egyébként tőlem nem kötelező. :wink:

Boa
2019. 12. 15.


A lassítást itt tárgyaljuk: https://github.com/boapps/Szivacs-Naplo/issues/58
A lassítás mértékét pedig ezen a weboldalon tudjátok követni: http://szivacsstatus.govt.hu/


# Szivacs Napló

A Szivacs Napló: egy multiplatformos kliensalkalmazás az e-napló rendszerhez.

Ez a play áruházas verziója a Szivacs Naplónak, amiben vannak opcionális (bekapcsolható, de alapból kikapcsolt) reklámok. A foss branchben van a reklámmentes és google-dependency mentes verzió. Ígérem, hogy soha nem lesz erőltetett reklám a Szivacsban és mindig lesz egy "Google Play Services"-mentes teljesen FOSS verziója is az appnak.


#### Jelenlegi funkciók:
* "faliújság"
* jegyek
* órarend
* hiányzások
* átlagok
* egyszerre több fiók kezelése
* gyors, logikus, modern felület
* sötét téma és személyre szabható színek
* értesítések
* grafikonok

## Letöltés
#### Forráskódból:
* `git clone https://github.com/boapps/Szivacs-Naplo`
* `cd Szivacs-Naplo`
* `flutter build apk --debug` vagy `flutter run`

#### Android:
<a href='https://play.google.com/store/apps/details?id=io.github.boapps.meSzivacs&pcampaignid=MKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Szerezd meg: Google Play' src='https://play.google.com/intl/en_us/badges/images/generic/hu_badge_web_generic.png' height=56px /></a> <br>

<a href='https://t.me/eSzivacs/'>
<img alt='Töltsd le a Telegram Chaten!' src='https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fthumb%2F8%2F82%2FTelegram_logo.svg%2F1200px-Telegram_logo.svg.png&f=1&nofb=1' height=56px /></a> <br>
(Töltsd le a legújabb verziót a Telegram csoportunkban innen)

#### iOS:
Az alkalmazás működik iOS-en is, mert Flutterben készült, de az AppStore-ba nem tettem fel, mert a fejlesztői fiók meglehetősen költséges.

Ennek ellenére [hajducsekb](https://github.com/hajducsekb) legyártott egy [.ipa fájlt](https://www.dropbox.com/s/3vzrqagpfhb6g8l/flutter_naplo.ipa?dl=0), amit Cydia Impactorral fel lehet telepíteni. [További infó a telepítésről](https://github.com/boapps/e-Szivacs-2/issues/30)



## Felhasznált nyílt forráskódú projectek:

* [Flutter](https://github.com/flutter/flutter) - alkalmazásfejlesztési keretrendszer (ezzel csináltam az appot)
* [Fira GO](https://github.com/bBoxType/FiraGO) - betűtípus
* Flutter kiegészítők:
  * [dynamic_theme](https://github.com/Norbert515/dynamic_theme) - a sötét témához
  * [Fluro](https://github.com/theyakka/fluro)
  * [Flutter Launcher Icons](https://github.com/fluttercommunity/flutter_launcher_icons)
  * [charts_flutter](https://github.com/google/charts)
  * [Flutter Local Notifications Plugin](https://github.com/MaikuB/flutter_local_notifications)
  * [flutter_html_view](https://github.com/PonnamKarthik/FlutterHtmlView)
  * [html_unescape](https://github.com/filiph/html_unescape)
  * [background_fetch](https://github.com/transistorsoft/flutter_background_fetch)

## Licensz:
```
BSD 2-Clause License

Copyright (c) 2019, Botos András
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
```
