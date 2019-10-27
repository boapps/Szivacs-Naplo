version=$1
flavor="play_release"

if [[ -z "$version" ]]; then
	echo "Nem adtál meg verziót!"
	echo "pl.: sh build-apks.sh 1.2.3"
else
	echo "Fájlok építése a $version verzióhoz..."

	if [[ $2 == "beta" ]]; then
		flavor="play_beta"
		version="$version-beta"
		echo "building beta version"
		flutter build apk --flavor play_beta
		flutter build appbundle --flavor play_beta --target-platform android-arm,android-arm64
		flutter build apk --flavor play_beta --target-platform android-arm,android-arm64 --split-per-abi
	else
		echo "building release version"
		flutter build apk --flavor play_release
		flutter build appbundle --flavor play_release --target-platform android-arm,android-arm64
		flutter build apk --flavor play_release --target-platform android-arm,android-arm64 --split-per-abi
	fi

	echo "A fájlok készen vannak, átmásolás a közös mappába..."

	cp build/app/outputs/apk/$flavor/release/app-$flavor-release.apk ~/release_apks/e-szivacs_v$version.apk
	cp build/app/outputs/bundle/${flavor}Release/app.aab ~/release_apks/e-szivacs_v$version.aab
	cp build/app/outputs/apk/$flavor/release/app-$flavor-armeabi-v7a-release.apk ~/release_apks/e-szivacs_v$version-arm.apk
	cp build/app/outputs/apk/$flavor/release/app-$flavor-arm64-v8a-release.apk ~/release_apks/e-szivacs_v$version-arm64.apk

	echo "Kész!"
fi
