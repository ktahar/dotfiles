#!/bin/zsh

# install vanilla gnome. (For Ubuntu 18.04 (bionic))
if [ $(lsb_release -cs) = 'bionic' ]; then
    sudo -E apt install vanilla-gnome-desktop
fi
