# ktaha's zshenv

typeset -U path
path=($path ~/dotfiles/scripts)

if [ -d ~/bin ]; then
    path=(~/bin $path)
fi
if [ -d ~/.local/bin ]; then
    path=(~/.local/bin $path)
fi

export EDITOR=vim
