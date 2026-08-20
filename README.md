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
[submod](submod) contains some scripts for submodule manipulations.

To sync with submodules:

```bash
cd ~/dotfiles/ && ./submod/update # or, git submodule update --init
```

To upgrade all the submodules (use with care):

```bash
cd ~/dotfiles/ && ./submod/upgrade
```

## Guidelines
Some guidelines to help maintain my environment.

### Software installation directory on Linux (Ubuntu)
Not to mess up the Linux environment...

1. prefer OS package manager to manual-download/build.
    1. Consider `apt` package first.
    1. If problem is well-known (well-localized) and ppa solves that, use ppa.
    1. If it is tied to a programming language, consider using the language's package manager.
    1. If nothing above applies, manually download the binary or build from source.
1. avoid system-wide installation of custom-built stuffs (use of sudo).
    1. `sudo apt install` is OK.
    1. But don't install manual-download/build things under `/usr` etc (don't `sudo make install` blindly).
    1. If it is really necessary, consider installing under `/opt` (like, `PREFIX=/opt` and `sudo make install`).
1. prefer installing user-local things under `~/.local`.
    1. `pip install --user` uses this directory too.
    1. Custom-built libs and apps can be installed with `PREFIX=${HOME}/.local`
    1. To use C libraries there, configure env vars like `LIBRARY_PATH` or `LD_LIBRARY_PATH`.
1. also consider putting user-local things in `~/opt` if it doesn't look appropriate to use `~/.local`.
    1. node.js/npm is placed there now.
