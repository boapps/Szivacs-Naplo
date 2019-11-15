#!/usr/bin/env bash

m=$1

if [[ -z '$m' ]]; then
    echo 'no commit message given'
else
    flutter pub get

    git add -A
    git commit -a -m "$m"
    echo 'rsync'
    rsync -av --exclude='.git*' --exclude='README.md' ./ ../.szivacs-tmp/
    echo 'rsyncend'

    git checkout master

    echo 'rsync'
    rsync -av --exclude='.git*' --exclude='README.md' ../.szivacs-tmp/ ./
    echo 'rsyncend'
    sh to_foss.sh
    flutter pub get
    git add -A
    git commit -a -m "$m"

    git checkout play-edition

    rm -rf ../.szivacs-tmp/
    flutter pub get
fi
