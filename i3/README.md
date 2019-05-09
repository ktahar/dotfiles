# i3
## install
[install](install) script helps to install following things.

### xrdp
[xsession](xsession) file to use i3 from xrdp session.

### ibus-mozc
To enter Japanese, install ibus-mozc, and open `ibus-setup` to add mozc.
If ibus is not launched on i3 session, try to login on Ubuntu (GNOME) session,
check open up "Language Support" and select "IBus" for IM.
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
