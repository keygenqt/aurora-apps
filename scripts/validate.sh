#!/bin/bash

DIR="$(dirname "$(realpath "$0")")"

# Get psdk
chroot=$(aurora-cli api --route='/psdk/installed' | grep 'aurora_psdk/sdk-chroot' | head -n 1 | xargs | sed 's/,//g')
version=$($chroot version | tail -1 | awk -F' ' '{print $2}')

target_arm=$(aurora-cli api --route="/psdk/targets?version=$version" | grep -E '"AuroraOS.+armv7hl"' | head -n 1 | xargs | sed 's/,//g')
target_arm64=$(aurora-cli api --route="/psdk/targets?version=$version" | grep -E '"AuroraOS.+aarch64"' | head -n 1 | xargs | sed 's/,//g')
target_x64=$(aurora-cli api --route="/psdk/targets?version=$version" | grep -E '"AuroraOS.+x86_64"' | head -n 1 | xargs | sed 's/,//g')

# Check rpm
echo ""
echo "########################################"
echo ""
echo "Run check builds..."
is_error=false
for entry in $DIR/../apps/*
do
    if [[ -d $entry ]] && [[ ${entry} != *"(error)"* ]]; then
        count=$(ls $entry/builds/* 2> /dev/null | wc -l)
        if [[ $count -ne 3 ]]; then
            echo "Error count RPM packages: $count: \"$entry\"!"
            is_error=true
        else
            for rpm in $entry/builds/*
            do
                target=$target_arm64

                if [[ ${rpm} == *"aarch64"* ]]; then
                    target=$target_arm64
                fi
                if [[ ${rpm} == *"armv7hl"* ]]; then
                    target=$target_arm
                fi
                if [[ ${rpm} == *"x86_64"* ]]; then
                    target=$target_x64
                fi

                rpm_name=$(basename $rpm)
                echo ""
                echo "Start validation: $rpm_name..."

                code=$(aurora-cli api --route="/psdk/package/validate?version=$version&target=$target&path=$rpm&profile=regular" | grep "code" | head -n 1 | xargs | sed 's/,//g')

                if [[ ${code} != *"code: 200"* ]]; then
                    echo "Error validation!"
                    is_error=true
                else
                    echo "Successfully validation!"
                fi
            done
        fi
    fi
done

echo ""
if [[ "$is_error" = true ]]; then
    echo "Packages have been checked and errors found."
else
    echo "Packages were checked successfully, no errors were found."
fi
