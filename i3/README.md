# i3

## xrdp
[xsession](xsession) file is used to use i3 from xrdp session.

## ibus-mozc
ibus-mozc is installed as Japanese IM
in the [script](../install_linux_desktop).
Follow procedures below to complete setup.

1. run `ibus-setup`
    * add Japanese -> mozc
    * next input source to "Shift+Space"
    * may configure to use custom font
1. load keymap at dotfiles/mozc/keymap.txt. Properties -> Keymap -> Customize... -> Edit -> Import from file
    * "Ctrl+Space" is mapped to Activate / Deactivate IME.
1. load dict at dotfiles/mozc/dict.txt. Properties -> Dictionary -> Edit user dictionary -> Import to this dictionary

If ibus is not working properly, try to login on Ubuntu (GNOME) session,
and check "Language Support" or something.
See [gnome/README](../gnome/README.md) as well.

## xrandr
To configure display resolution and rotation, add setting in `~/.xprofile` like below.
(execute `xrandr -q` to see available monitors)
Here, if checks existence of an env to exclude xrdp session.

```bash
if [ -z "${MY_SESSION_XRDP+1}" ]; then
    xrandr --output DP-2 --auto --primary --output VGA-1 --right-of DP-2
fi
```

## lightdm
The root install script installs `lightdm-gtk-greeter`,
which can be configured on GUI by `sudo lightdm-gtk-greeter-settings`.
Sometimes lightdm is not configured and gdm starts,
in this case `sudo dpkg-reconfigure lightdm` and select lightdm.

Following settings look nice for me.
* Theme -> Adwaita (-dark version if it exists)
* Icons -> default

TODO: setting by commands or files ?
