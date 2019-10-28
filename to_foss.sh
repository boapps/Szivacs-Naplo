#!/bin/bash

find . -path "*lib/*.dart" -type f -print0 | while IFS= read -r -d $'\0' file; do
  sed -i '/ad_start/,/ad_end/d' $file
done

sed -i '/ad_start/,/ad_end/d' "android/app/src/main/AndroidManifest.xml"
sed -i '/ad_start/,/ad_end/d' "pubspec.yaml"
sed -i '/ad_start/,/ad_end/d' "build-apks.sh"
