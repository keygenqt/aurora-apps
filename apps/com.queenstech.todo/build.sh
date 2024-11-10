#!/bin/bash

# Get flutter
flutter=$(aurora-cli api --route='/flutter/installed' | grep '/bin/flutter' | head -n 1 | xargs)
dart=$(echo $flutter | sed 's/bin\/flutter/bin\/dart/g')

# Set projects dir
DIR="$(dirname "$(realpath "$0")")"
cd $DIR
mkdir -p ../../projects
cd ../../projects

APP_ID='com.queenstech.todo'
PROJECT='fluttery-todo'

# Clone project
if [ -d "$PROJECT" ]; then
    cd $PROJECT
    git clean -fdx
    git pull
else
    git clone https://gitlab.com/omprussia/flutter/fluttery-todo.git
    cd $PROJECT
fi

# Apply patches
for entry in "$DIR/patches"/*
do
    git apply $(realpath "$entry")
done

$dart run build_runner build

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
