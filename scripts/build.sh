#!/bin/bash

DIR="$(dirname "$(realpath "$0")")"

# Build all apps
for entry in $DIR/../apps/*/build.sh
do
    sh $entry
done
