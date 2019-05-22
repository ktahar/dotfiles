# gnome

To be more specific, Ubuntu (LTS) desktop.

## ibus-mozc
ibus-mozc is installed as Japanese IM
in the [script](../install_linux_desktop).
Follow procedures below to complete setup.

1. Language Support: confirm "Keyboard input method system" is "IBus"
1. GNOME's settings (not that `ibus-setup` doesn't take effect for gnome)
    * Settings -> Region & Language -> Input methods: press + and select Japanese (mozc)
    * Settings -> Devices -> Keyboard -> Typing: change "Switch to next input source" to "Shift+Space"
1. load keymap at dotfiles/mozc/keymap.txt. Properties -> Keymap -> Customize... -> Edit -> Import from file
    * "Ctrl+Space" is mapped to Activate / Deactivate IME.
1. load dict at dotfiles/mozc/dict.txt. Properties -> Dictionary -> Edit user dictionary -> Import to this dictionary

## Extension: TopIcons Redux (Recommended for Ubuntu 16.04)
Visit [here](https://extensions.gnome.org/extension/1497/topicons-redux/) and
download proper version.
Import (downloaded zip file) from Tweak Tool's Extensions menu.

To check gnome shell version:

```bash
gnome-shell --version
```

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
