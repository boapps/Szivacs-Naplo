#!/usr/bin/env bash

m=$1

if [[ -z '$m' ]]; then
    echo 'no commit message given'
else
    current=$(git rev-parse --abbrev-ref HEAD)
    if [[ $current == "master" ]]; then
        echo {git branch | grep \* | cut -d ' ' -f2}

        git checkout master

        git add -A
        git commit -a -m "$m"
        rsync -av --exclude='.git*' --exclude='README.md' ./ ../.szivacs-tmp/

        git checkout foss

        rsync -av --exclude='.git*' --exclude='README.md' ../.szivacs-tmp/ ./
        sh to_foss.sh
        flutter pub get
        git add -A
        git commit -a -m "$m"

        git checkout master

        rm -rf ../.szivacs-tmp/
        flutter pub get
    else
        echo "Please use the master branch for committing changes!"
    fi
fi
