#!/bin/bash

DIR="$(dirname "$(realpath "$0")")"
cd $DIR/..

package=$1

if [[ -z "$package" ]]; then
    echo 'Select package argument.'
    exit 1
fi

path=$(realpath $DIR/../apps/$package/builds/*x86*)

aurora-cli psdk package sign -p $path
aurora-cli emulator package install -p $path -a -r
aurora-cli emulator package run -p $package
