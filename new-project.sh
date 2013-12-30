#!/bin/bash

MY_PATH="`dirname \"$0\"`"
MY_PATH="`( cd \"$MY_PATH\" && pwd )`"

# currentPath=`pwd`
# cd "$MY_PATH"


# echo "## Updating submodule for piecemeal scripts!!"
# git submodule update --init --recursive

# python "$MY_PATH/Scripts/NewProjectFromTemplate.py $@

name="$1"

cp "$MY_PATH/ProjectTemplate" .
mv ProjectTemplate "$name"

cd "$name"
DIRS=`find * -type d -name "*TEMPLATE*" -d`