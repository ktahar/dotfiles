#!/bin/zsh

# gnome-settings
gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'

# install language support.
local langsup=$(check-language-support)
if [ -n "$langsp" ]; then
    sudo -E apt install $langsp
fi

# install vanilla gnome. (For Ubuntu 18.04 (bionic))
if [ $(lsb_release -cs) = 'bionic' ]; then
    dpkg-query -W vanilla-gnome-desktop > /dev/null
    if [ "$?" != 0 ]; then
        sudo -E apt install vanilla-gnome-desktop
    fi
fi

# caps to ctrl.
grep "ctrl:nocaps" /etc/default/keyboard > /dev/null
if [ "$?" = 0 ]; then
    echo "Caps to Ctrl is already done."
else
    sudo su -c "sed -iE 's/^XKBOPTIONS/#XKBOPTIONS/' /etc/default/keyboard"
    sudo su -c "echo XKBOPTIONS=ctrl:nocaps >> /etc/default/keyboard"
fi

# install Cica font.
fc-list | grep Cica > /dev/null
if [ "$?" = 0 ]; then
    echo "Cica font is already installed."
else
    local cica_v=v4.1.1
    local cica_fn=Cica-${cica_v}.zip
    local cica_dir=Cica-${cica_v}

    echo "Download and install Cica ${cica_v}..."

    curl -SL https://github.com/miiton/Cica/releases/download/${cica_v}/${cica_fn} -o ${cica_fn}
    unzip ${cica_fn} -d ${cica_dir}
    mkdir -p ~/.local/share/fonts
    mv ${cica_dir}/Cica*.ttf ~/.local/share/fonts/
    fc-cache -fv
    rm -r ${cica_fn} ${cica_dir}
fi

# Set launcher icon.
local target=${HOME}/.local/share/applications/matlab.desktop
local matlab=${HOME}/opt/matlab
if [ -d ${matlab} ]; then
    sed "s@<HOME>@${HOME}@g" matlab.desktop > $target
    chmod u+x $target
else
    echo "no MATLAB directory (${matlab}) found"
fi
