#!/bin/bash

# Get psdk
chroot=$(aurora-cli api --route='/psdk/installed' | grep 'aurora_psdk/sdk-chroot' | head -n 1 | xargs | sed 's/,//g')
version=$($chroot version | tail -1 | awk -F' ' '{print $2}')

target_arm=$(aurora-cli api --route="/psdk/targets?version=$version" | grep -E '"AuroraOS.+armv7hl"' | head -n 1 | xargs | sed 's/,//g')
target_arm64=$(aurora-cli api --route="/psdk/targets?version=$version" | grep -E '"AuroraOS.+aarch64"' | head -n 1 | xargs | sed 's/,//g')
target_x64=$(aurora-cli api --route="/psdk/targets?version=$version" | grep -E '"AuroraOS.+x86_64"' | head -n 1 | xargs | sed 's/,//g')

# Set projects dir
DIR="$(dirname "$(realpath "$0")")"
cd $DIR
mkdir -p ../../projects

PROJECT_LOTTIE="$DIR/../../projects/lottie-qml"
PROJECT_APP="$DIR/../../projects/km-shop"

# Clone project lottie
if [ -d "$PROJECT_LOTTIE" ]; then
    cd $PROJECT_LOTTIE
    git clean -fdx
    git pull
    cd ../
else
    git clone https://github.com/keygenqt/lottie-qml.git
fi

# Clone project app
if [ -d "$PROJECT_APP" ]; then
    cd $PROJECT_APP
    git clean -fdx
    git pull
else
    git clone https://github.com/keygenqt/km-shop.git
    cd $PROJECT_APP
fi

buildProject() {
    # Build kmp
    cd $PROJECT_APP
    chmod +x ./gradlew
    ./gradlew assembleJsPackage

    # Build wrapper
    cd $PROJECT_APP
    cd shop/mobile/aurora/kmm-js-build
    npm update
    npm run build

    # Copy lottie
    cd $PROJECT_APP
    mkdir -p shop/mobile/aurora/shop/qml/lottie-qml
    cp -R ../lottie-qml/src shop/mobile/aurora/shop/qml/lottie-qml

    # Open folder Aurora OS
    cd $PROJECT_APP
    cd shop/mobile/aurora/shop

    # Build arm
    $chroot mb2 --no-fix-version --target $1 build
    mv ./RPMS/* $DIR/builds && git clean -fdx
}

# Folder builds
rm -rf $DIR/builds
mkdir $DIR/builds

buildProject $target_arm
buildProject $target_arm64
buildProject $target_x64
