# i3
## xrdp
[install](install) setups [xsession](xsession) file
to use i3 from xrdp session.

## xrandr
To configure display rotation and orientation, edit `~/.xprofile` like below.
(execute `xrandr -q` to see available monitors)
Here, if checks existence of an env to exclude xrdp session.

```bash
if [ -z "${MY_SESSION_XRDP+1}" ]; then
    xrandr --output DP-2 --auto --output VGA-1 --right-of DP-2
fi
```

## fcitx-mozc
To enter Japanese, install fcitx-mozc with `sudo apt install fcitx-mozc`,
(reboot ?,) and then open `fcitx-configtool` to add mozc.
