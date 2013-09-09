#!/bin/bash

MY_PATH="`dirname \"$0\"`"
MY_PATH="`( cd \"$MY_PATH\" && pwd )`"

# currentPath=`pwd`
# cd "$MY_PATH"

git submodule update --init --recursive

python Piecemeal-Scripts/Scripts/Utils/NewProjectFromTemplate.py --template-path ProjectTemplate $@