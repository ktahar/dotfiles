# ktaha's zshenv

export SHELL=/bin/zsh
export EDITOR=vim
export LANG=en_US.UTF-8
export LESS=-R

## Python
### pyenv and pipenv
export PYENV_ROOT=~/.pyenv
export PIPENV_VENV_IN_PROJECT=1

## Golang
if [ -d ~/go ]; then
    export GOPATH=~/go
fi

## PATH
typeset -U path
### put at head without existence check.
directories=(~/opt/node/bin)
for dir in $directories; do
    path=($dir $path)
done
### put at head.
directories=($PYENV_ROOT/bin ~/opt/go/bin ~/.local/bin)
for dir in $directories; do
    if [ -d $dir ]; then
        path=($dir $path)
    fi
done
### put at tail.
directories=($GOPATH/bin ~/dotfiles/bin)
for dir in $directories; do
    if [ -d $dir ]; then
        path=($path $dir)
    fi
done

## fzf
export FZF_DEFAULT_OPTS='--bind=ctrl-j:abort'
export FZF_DEFAULT_COMMAND='ag --nocolor --nogroup -g ""'
export FZF_COMPLETION_TRIGGER='~~'
