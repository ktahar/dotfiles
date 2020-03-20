# ktaha's zshenv

export SHELL=/bin/zsh
export EDITOR=vim
export LANG=en_US.UTF-8

## C headers and libs
### CPATH
typeset -T CPATH cpath
typeset -U cpath
directories=(~/.local/include)
for dir in $directories; do
    if [ -d $dir ]; then
        cpath=($dir $cpath)
    fi
done
export CPATH
### LIBRARY_PATH and LD_LIBRARY_PATH
typeset -T LIBRARY_PATH library_path
typeset -U library_path
typeset -T LD_LIBRARY_PATH ld_library_path
typeset -U ld_library_path
directories=(~/.local/lib)
for dir in $directories; do
    if [ -d $dir ]; then
        library_path=($dir $library_path)
        ld_library_path=($dir $ld_library_path)
    fi
done
export LIBRARY_PATH
export LD_LIBRARY_PATH

## Python
### pyenv and pipenv
export PYENV_ROOT=~/.pyenv
export PIPENV_VENV_IN_PROJECT=1

### PYTHONPATH
typeset -T PYTHONPATH pythonpath
typeset -U pythonpath
pythonpath=($pythonpath ~/dotfiles/py)
export PYTHONPATH

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
