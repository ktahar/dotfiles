# i3
## install
[install](install) script helps to install following things.

### xrdp
[xsession](xsession) file to use i3 from xrdp session.

### fcitx-mozc
To enter Japanese, install fcitx-mozc, (reboot necessary ?),
and then open `fcitx-configtool` to add mozc.

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

Following settings look nice for me.
* Theme -> Adwaita
* Icons -> default

TODO: setting by commands or files ?
