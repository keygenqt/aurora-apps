#!/bin/bash

# Get flutter
flutter=$(aurora-cli api --route='/flutter/installed' | grep '/bin/' | head -n 1 | xargs)

# Set projects dir
DIR="$(dirname "$(realpath "$0")")"
cd $DIR
mkdir -p ../../projects
cd ../../projects

APP_ID='com.keygenqt.rogue_shooter'
PROJECT='flame'

# Clone project
if [ -d "$PROJECT" ]; then
    cd $PROJECT
    git clean -fdx
    git pull
else
    git clone https://github.com/flame-engine/flame.git
    cd $PROJECT
fi

# Apply patches
for entry in "$DIR/patches"/*
do
    git apply $(realpath "$entry")
done

# Build project
cd examples/games/rogue_shooter

$flutter build aurora --release --target-platform aurora-arm
$flutter build aurora --release --target-platform aurora-arm64
$flutter build aurora --release --target-platform aurora-x64

# Move
rm -rf $DIR/builds
mkdir $DIR/builds
for entry in build/aurora/psdk_*/aurora-*/release/RPMS/*
do
    rpm=$(realpath "$entry")
    mv $rpm $DIR/builds
done
