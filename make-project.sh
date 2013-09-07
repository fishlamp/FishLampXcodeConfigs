#!/bin/bash

function usage() {
    echo "bash new-project.sh \"../myProject\" \"Lib\" \"MyApp\""
}

if [ "$1" == "" ]; then
    echo "first param should be path to your git project"
    usage
    exit 1;
fi

if [ "$2" == "" ]; then 
    echo "second param should be name of project subfolder"
    usage
    exit 1;
fi

if [ "$3" == "" ]; then
    echo "third param should be project name"
    exit 1;
fi

git submodule update --init --recursive

python Piecemeal-Scripts/Scripts/Utils/NewProjectFromTemplate.py ProjectTemplate "$1" "$2" "$3"