#!/bin/bash

if [ $# -eq 0 ]; then
    fn=gnome-term.dconf
elif [ $# -eq 1 ]; then
    fn=$1
else
    echo "invalid number of arguments."
    exit 1
fi

echo "loading from $fn"
dconf load /org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')/ < $fn
