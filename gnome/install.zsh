#!/bin/zsh

# install language support.
sudo -E apt install $(check-language-support)

# install vanilla gnome. (For Ubuntu 18.04 (bionic))
if [ $(lsb_release -cs) = 'bionic' ]; then
    sudo -E apt install vanilla-gnome-desktop
fi

# Set launcher icon.
local target=${HOME}/.local/share/applications/matlab.desktop
local matlabs=(${HOME}/opt/MATLAB/*)
if [ $? = 0 ]; then
    if [ $#matlabs = 1 ]; then
        echo $matlabs[1]
        local p=${matlabs[1]}
    else
        echo $matlabs
        read version\?"select version (like R2018b):"
        local p=${HOME}/opt/MATLAB/${version}
        echo $p
    fi
    sed "s@<PATH>@${p}@g" matlab.desktop > $target
    chmod u+x $target
else
    echo "no MATLAB found"
fi
