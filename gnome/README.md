# GNOME

For Linux desktop - GNOME on Ubuntu LTS.

## dotfiles
All options of `./install` script will work.
For installing everything on Ubuntu desktop,
first try `./install -f`, restart the desktop session, and then `./install -A`.

## Japanese IM (ibus-mozc)
If IM (mozc) is not working, install language support: try `./install_linux_desktop -l`
and/or look at the GUI menu by searching "language support".
Apt packages `ibus-mozc` and `mozc-utils-gui` should be installed if Japanese language support is fine.
Follow procedures below to complete setup.

1. Language Support: confirm "Keyboard input method system" is "IBus"
1. GNOME's settings (note that `ibus-setup` doesn't take effect for gnome)
    - Settings -> Keyboard -> Input Sources: press + and select Japanese (mozc)
1. load keymap at dotfiles/mozc/keymap.txt. Properties -> Keymap -> Customize... -> Edit -> Import from file
    - "Ctrl+Space" is mapped to Activate / Deactivate IME.
1. load dict at dotfiles/mozc/dict.txt. Properties -> Dictionary -> Edit user dictionary -> Import to this dictionary

## X keymap (/etc/default/keyboard -> XKBOPTIONS)
See `man keyboard` and `/usr/share/X11/xkb/rules/xorg.lst`.

"Caps to Ctrl", i.e. `XKBOPTIONS=ctrl:nocaps` is set by `install.zsh`.

Other options like `altwin:swap_lalt_lwin` may be useful for some keyboards,
but setting `XKBOPTIONS="ctrl:nocaps,altwin:swap_lalt_lwin"` doesn't work sometimes.
In this situation, try gsettings instead:
```
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps','altwin:swap_lalt_lwin']"
```

Current option can be queried by `setxkbmap -query`.
