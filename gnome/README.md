# GNOME desktop

To be more specific, Ubuntu (LTS) desktop.

## 日本語入力
### ibus-mozc (Recommended for Ubuntu 18.04)
1. install (`sudo apt install ibus-mozc`) and restart X session
1. Language Support: confirm "Keyboard input method system" is "IBus"
1. GNOME's settings
    * Settings -> Region & Language -> Input methods: press + and select Japanese (mozc)
    * Settings -> Devices -> Keyboard -> Typing: change "Switch to next input source" to "Shift+Space"
1. `ibus-setup`
    * add Japanese -> mozc
    * next input source to "Shift+Space"
    * may configure to use custom font
1. cp mozc/config1.db to ~/.mozc and reboot
    * or manually add entries at mozc -> Tools -> Properties -> Keymap -> Customize...
    * "Direct input", "Ctrl Space", "Activate IME"
    * "Precommit", "Ctrl Space", "Deactivate IME"
    * "Converion", "Ctrl n", "Select next candidate"
    * "Converion", "Ctrl p", "Select previous candidate"

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
