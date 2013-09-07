#!/bin/bash

git submodule update --init --recursive

py Piecemeal-Scripts/NewProjectFromTemplate.py ProjectTemplate "$destPath" "$projectName" "$subFolderName"