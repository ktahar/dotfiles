# dotfiles
just for me 😉

## Install

```bash
cd && git clone --recursive https://ktahar@github.com/ktahar/dotfiles
cd dotfiles/ && ./install.py
```

The install.py will do setups,
except for things that strongly depends on environment.

## Uninstall

```bash
cd ~/dotfiles/ && ./install.py --uninstall
```

For now, just remove symlinks.

## Submodule
Using git submodule to get apps/plugins from github.
See following directories.

* [apps](apps): applications, vim and fzf.
* [vim/pack](vim/pack): plugins for vim.
* [tmux/plugins](tmux/plugins): plugins for tmux.

### Commands for submodule manipulation
To sync with submodules:

```bash
cd ~/dotfiles/ && git submodule update -i
```

To upgrade submodules:

```bash
cd ~/dotfiles/ && git submodule foreach git pull origin master
```

See scripts in [submod](submod) for shortcuts.

## Environment Specific
### Linux (GNOME)
For linux desktop (GNOME), see [gnome](gnome) directory.

#### Extension: TopIcons Redux
Visit [here](https://extensions.gnome.org/extension/1497/topicons-redux/) and
download proper version.
Import (downloaded zip file) from Tweak Tool's Extensions menu.

To check gnome shell version:

```bash
gnome-shell --version
```

### Windows
For windows, see [windows](windows) directory.

#### TeraTerm
Copy TERATERM.INI to TeraTerm's directory or just load settings from TeraTerm.
