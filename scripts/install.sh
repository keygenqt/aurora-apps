#!/bin/bash

DIR="$(dirname "$(realpath "$0")")"

# Build all apps
for entry in $DIR/../apps/*/builds/*x86*
do
    if [[ $entry != *"(error)"* ]]; then
        path=$(realpath $entry)
        aurora-cli psdk package sign -p $path
        aurora-cli emulator package install -p $path -a -r
    fi
done
