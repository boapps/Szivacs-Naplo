version=$1

if [[ -z "$version" ]]; then
	echo "Nem adtál meg verziót!"
	echo "pl.: sh build-apks.sh 1.2.3"
else
	echo "Fájlok építése a $version verzióhoz..."

	flutter build apk
	flutter build appbundle --target-platform android-arm,android-arm64
	flutter build apk --target-platform android-arm,android-arm64 --split-per-abi
	
	echo "A fájlok készen vannak, átmásolás a közös mappába..."

	cp build/app/outputs/apk/release/app-release.apk ~/release_apks/e-szivacs_v$version.apk
	cp build/app/outputs/bundle/release/app.aab ~/release_apks/e-szivacs_v$version.aab
	cp build/app/outputs/apk/release/app-armeabi-v7a-release.apk ~/release_apks/e-szivacs_v$version-arm.apk
	cp build/app/outputs/apk/release/app-arm64-v8a-release.apk ~/release_apks/e-szivacs_v$version-arm64.apk

	echo "Kész!"
fi
