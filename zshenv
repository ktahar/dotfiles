# ktaha's zshenv

export SHELL=/bin/zsh
export EDITOR=vim
export LANG=en_US.UTF-8
export LESS=-R

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

typeset -T LIBRARY_PATH library_path
typeset -U library_path
export LIBRARY_PATH=~/.local/lib

typeset -T LD_LIBRARY_PATH ld_library_path
typeset -U ld_library_path
export LD_LIBRARY_PATH=${LIBRARY_PATH}

## fzf
export FZF_DEFAULT_OPTS='--bind=ctrl-j:abort'
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
export FZF_COMPLETION_TRIGGER='~~'
