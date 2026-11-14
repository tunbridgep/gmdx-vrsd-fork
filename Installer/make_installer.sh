#!/bin/sh
if [ ! -f "$1" ]
then
    echo "Please specify a valid file as argument"
    exit 1
fi

wine ~/Downloads/nsisb/Bin/makensis.exe $1
