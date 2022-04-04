# dotfiles
just for me 😉

## Install

```bash
cd && git clone --recursive https://ktahar@github.com/ktahar/dotfiles
cd dotfiles/ && ./install
```

The install script will do setups,
except for things that strongly depends on environment.

### Full install (Ubuntu)
For full installation to Ubuntu desktop,
first try `./install -f`, restart the X session, and then `./install -A`.
If IM(mozc) is not working properly, try `./install_linux_desktop -l`.

### TODO for Windows
List of TODO things for Windows.

#### Programs
- Windows Terminal: get from the store
- winget Python.Python.3 vim.vim "The Silver Searcher"
- fzf: run apps/fzf/install.ps1 in PowerShell

#### Environment variables
- path
    - %APPDATA%\Python\Scripts
    - %APPDATA%\Python\Python3XY\Scripts
    - %HOME%\.fzf\bin
- fzf (see zshenv)
    - FZF_DEFAULT_OPTS='--bind=ctrl-j:abort'
    - FZF_DEFAULT_COMMAND='ag --nocolor --nogroup -g ""'

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

## Environment specific
See following directories.

* [i3](i3)
* [gnome](gnome)
* [windows](windows)

## Guidelines
Of course, these things are also just for me.

### Software installation directory
1. prefer package manager to manual-download/build.
    1. Consider `apt` package first.
    1. If it is too old or problematic, use language-specific package manager.
    1. If problem is well-known and ppa solves that, use ppa.
    1. If there are some other reasons,
    manually download binary or build from source.
1. avoid system-wide installation (use of sudo).
    1. `sudo apt install` is OK.
    1. But don't install manual-download/build things under `/usr` etc.
    1. If it is really necessary, install under `/opt`.
1. install "well-established" things under `~/.local`.
    1. `pip install --user` uses this directory.
    1. Manually-built libs and apps can be installed with `PREFIX=${HOME}/.local`
    1. To use C libraries there, configure envs like `LIBRARY_PATH`.
    See [zshenv](zshenv) and `man gcc`.
1. install "stand-alone" or "not-well-known" things under `~/opt`.
    1. languages like node.js and go are currently there.
