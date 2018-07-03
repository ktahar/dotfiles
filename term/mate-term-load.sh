#!/bin/bash

if [ $# -eq 0 ]; then
    fn=mate-term.dconf
elif [ $# -eq 1 ]; then
    fn=$1
else
    echo "invalid number of arguments."
    exit 1
fi

echo "loading from $fn"
dconf load /org/mate/terminal/profiles/default/ < $fn
