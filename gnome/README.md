# GNOME desktop

## 日本語入力
### ibus-mozc (Recommended for Ubuntu 18.04)
1. install (`sudo apt install ibus-mozc`) and restart X session
1. Language Support: confirm "Keyboard input method system" is "IBus"
1. Settings -> Region & Language -> Input methods: press + and select Japanese (mozc)
1. Settings -> Devices -> Keyboard -> Typing: change "Switch to next input source" to "Ctrl+Space"
1. cp mozc/config1.db to ~/.mozc and reboot
    * or manually add entries at mozc -> Tools -> Properties -> Keymap -> Customize...
    * "Direct input", "Shift Space", "Activate IME"
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

