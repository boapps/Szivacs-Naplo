#!/usr/bin/env bash

version=$1
fossness="foss"
# ad_start
fossness="play"
# ad_end

if [[ -z "$version" ]]; then
    echo "Nem adtál meg verziót!"
    echo "pl.: sh build-apks.sh 1.2.3"
else
    echo "Fájlok építése a $version verzióhoz..."

    flavor="$fossness"
    echo "building release version"
    flutter build apk --flavor $flavor
    flutter build appbundle --flavor $flavor --target-platform android-arm,android-arm64
    flutter build apk --flavor $flavor --target-platform android-arm,android-arm64 --split-per-abi

    echo "A fájlok készen vannak, átmásolás a közös mappába..."

    cp build/app/outputs/apk/$flavor/release/app-$flavor-release.apk ~/release_apks/szivacs-naplo_${fossness}_v$version.apk
    cp build/app/outputs/bundle/${flavor}Release/app.aab ~/release_apks/szivacs-naplo_${fossness}_v$version.aab
    cp build/app/outputs/apk/$flavor/release/app-$flavor-armeabi-v7a-release.apk ~/release_apks/szivacs-naplo_${fossness}_v$version-arm.apk
    cp build/app/outputs/apk/$flavor/release/app-$flavor-arm64-v8a-release.apk ~/release_apks/szivacs-naplo_${fossness}_v$version-arm64.apk

    echo "Kész!"
fi
