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
cd ../../projects

APP_ID='ru.auroraos.MobileSound'
PROJECT='MobileSound'

# Clone project
if [ -d "$PROJECT" ]; then
    cd $PROJECT
    git clean -fdx
    git pull
else
    git clone https://gitlab.com/omprussia/examples/MobileSound.git
    cd $PROJECT
fi

$chroot mb2 --target $target_arm build
$chroot mb2 --target $target_arm64 build
$chroot mb2 --target $target_x64 build

# Move
rm -rf $DIR/builds
mkdir $DIR/builds
for entry in ./RPMS/*
do
    rpm=$(realpath "$entry")
    mv $rpm $DIR/builds
done
