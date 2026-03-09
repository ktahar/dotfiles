# dotfiles
just for me 😉

## Install

```bash
cd && git clone --recursive https://ktahar@github.com/ktahar/dotfiles
cd dotfiles/ && ./install
```

The install script will do basic setups. 
But, for desktop environments (Linux or Windows), look at environment-specific notes:

- [Linux (GNOME)](gnome/README.md)
- [Windows](windows/README.md)

## Uninstall

```bash
cd ~/dotfiles/ && ./install --uninstall
```

For now, just remove symlinks.

## Submodule
Using git submodule to get apps/plugins from github.
See following directories.

* [apps](apps): applications and libraries, vim, fzf, etc.
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

## Guidelines
Of course, these things are also just for me.

### Software installation directory on Linux
1. prefer package manager to manual-download/build.
    1. Consider `apt` package first.
    1. If it is too old or problematic, use language-specific package manager.
    1. If problem is well-known and ppa solves that, use ppa.
    1. If there are some other reasons, manually download binary or build from source.
1. avoid system-wide installation (use of sudo).
    1. `sudo apt install` is OK.
    1. But don't install manual-download/build things under `/usr` etc.
    1. If it is really necessary, install under `/opt`.
1. install "well-established" or "traditional" things (like C library) under `~/.local`.
    1. `pip install --user` uses this directory too.
    1. Manually-built libs and apps can be installed with `PREFIX=${HOME}/.local`
    1. To use C libraries there, configure envs like `LIBRARY_PATH`.
    See [zshenv](zshenv) and `man gcc`.
1. install "stand-alone" or "not-well-known" things under `~/opt`.
    1. languages like node.js and go are there now.
