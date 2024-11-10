#!/bin/bash

DIR="$(dirname "$(realpath "$0")")"

# Build all apps
for entry in $DIR/../apps/*
do
    if [[ -d $entry ]]; then
        rm -rf $entry/builds
    fi
done

rm -rf $DIR/../projects
