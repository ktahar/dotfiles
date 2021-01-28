# ktaha's zshenv

export SHELL=/bin/zsh
export EDITOR=vim
export LANG=en_US.UTF-8
export LESS=-R

## Python
export PIPENV_VENV_IN_PROJECT=1

## Golang
if [ -d ~/go ]; then
    export GOPATH=~/go
fi

## Rust
if [ -e ~/.cargo/env ]; then
    source ~/.cargo/env
fi

## PATH
typeset -U path
### put at head without existence check.
directories=(~/opt/node/bin ~/.local/bin)
for dir in $directories; do
    path=($dir $path)
done
### put at head.
directories=(~/opt/go/bin)
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

typeset -T LD_LIBRARY_PATH ld_library_path
typeset -U ld_library_path
export LD_LIBRARY_PATH

## fzf
export FZF_DEFAULT_OPTS='--bind=ctrl-j:abort'
export FZF_DEFAULT_COMMAND='ag --nocolor --nogroup -g ""'
export FZF_COMPLETION_TRIGGER='~~'
