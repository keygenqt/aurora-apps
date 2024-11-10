#!/bin/bash

DIR="$(dirname "$(realpath "$0")")"

bash $DIR/clear.sh

# Build all apps
for entry in $DIR/../apps/*/build.sh
do
    if [[ $entry != *"(error)"* ]]; then
        bash $entry
    fi
done

bash $DIR/validate.sh
