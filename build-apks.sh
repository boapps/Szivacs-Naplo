#!/usr/bin/env bash

version=$1
fossness="foss"

if [[ -z "$version" ]]; then
    echo "Nem adtál meg verziót!"
    echo "pl.: sh build-apks.sh 1.2.3"
else
    echo "Fájlok építése a $version verzióhoz..."

    if [[ $2 == "beta" ]]; then
        flavor="${fossness}_beta"
        version="$version-beta"
        echo "building beta version"
        flutter build apk --flavor $flavor
        flutter build appbundle --flavor $flavor --target-platform android-arm,android-arm64
        flutter build apk --flavor $flavor --target-platform android-arm,android-arm64 --split-per-abi
    else
       flavor="${fossness}_release"
       echo "building release version"
       flutter build apk --flavor $flavor
       flutter build appbundle --flavor $flavor --target-platform android-arm,android-arm64
       flutter build apk --flavor $flavor --target-platform android-arm,android-arm64 --split-per-abi
    fi

    echo "A fájlok készen vannak, átmásolás a közös mappába..."

    cp build/app/outputs/apk/$flavor/release/app-$flavor-release.apk ~/release_apks/szivacs-naplo_${fossness}_v$version.apk
    cp build/app/outputs/bundle/${flavor}Release/app.aab ~/release_apks/szivacs-naplo_${fossness}_v$version.aab
    cp build/app/outputs/apk/$flavor/release/app-$flavor-armeabi-v7a-release.apk ~/release_apks/szivacs-naplo_${fossness}_v$version-arm.apk
    cp build/app/outputs/apk/$flavor/release/app-$flavor-arm64-v8a-release.apk ~/release_apks/szivacs-naplo_${fossness}_v$version-arm64.apk

    echo "Kész!"
fi
