#!/usr/bin/env bash

git checkout master
git push
git checkout foss
git push
git checkout master
flutter pub get