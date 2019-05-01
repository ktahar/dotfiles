# dotfiles
just for me 😉

## Install

```bash
cd && git clone --recursive https://ktahar@github.com/ktahar/dotfiles
cd dotfiles/ && ./install
```

The install script will do setups,
except for things that strongly depends on environment.

## Uninstall

```bash
cd ~/dotfiles/ && ./install --uninstall
```

For now, just remove symlinks.

## Submodule
Using git submodule to get apps/plugins from github.
See following directories.

* [apps](apps): applications, vim, fzf, pyenv etc.
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
* [i3](i3)
* [gnome](gnome)
* [windows](windows)
