#!/bin/bash

git submodule update --init --recursive

python Piecemeal-Scripts/Scripts/Utils/NewProjectFromTemplate.py --template-path ProjectTemplate $@