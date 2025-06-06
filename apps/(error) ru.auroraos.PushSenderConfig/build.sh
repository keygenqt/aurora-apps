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

PROJECT='PushSenderConfig'

# Clone project
if [ -d "$PROJECT" ]; then
    cd $PROJECT
    git clean -fdx
    git pull
else
    git clone https://gitlab.com/omprussia/examples/PushSenderConfig.git
    cd $PROJECT
fi

# Folder builds
rm -rf $DIR/builds
mkdir $DIR/builds

# Build arm
$chroot mb2 --target $target_arm build
# Copy noarch to target name
noarch_name=$(basename $(realpath ./RPMS/*noarch*))
arch_name=$(echo $noarch_name | sed 's/noarch/armv7hl/g')
mv ./RPMS/$noarch_name ./RPMS/$arch_name
# Copy rpm to builds
mv ./RPMS/* $DIR/builds && git clean -fdx

# Build arm64
$chroot mb2 --target $target_arm64 build
# Copy noarch to target name
noarch_name=$(basename $(realpath ./RPMS/*noarch*))
arch_name=$(echo $noarch_name | sed 's/noarch/aarch64/g')
mv ./RPMS/$noarch_name ./RPMS/$arch_name
# Copy rpm to builds
mv ./RPMS/* $DIR/builds && git clean -fdx

# Build x64
$chroot mb2 --target $target_x64 build
# Copy noarch to target name
noarch_name=$(basename $(realpath ./RPMS/*noarch*))
arch_name=$(echo $noarch_name | sed 's/noarch/x86_64/g')
mv ./RPMS/$noarch_name ./RPMS/$arch_name
# Copy rpm to builds
mv ./RPMS/* $DIR/builds && git clean -fdx
