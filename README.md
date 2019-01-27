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
* `cd encrypt`
* `git revert --no-commit 632eb8c..HEAD`
* `cd ..`
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
