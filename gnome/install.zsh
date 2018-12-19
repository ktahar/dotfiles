#!/bin/zsh

# install vanilla gnome. (For Ubuntu 18.04 (bionic))
if [ $(lsb_release -cs) = 'bionic' ]; then
    sudo -E apt install vanilla-gnome-desktop
fi

# Set launcher icon.
target=${HOME}/.local/share/applications/idea.desktop
if [ -e ${HOME}/opt/IntelliJ/idea ] && \
    [ ! -e $target ]; then
    sed "s@<HOME>@${HOME}@g" idea.desktop > $target
    chmod u+x $target
fi
