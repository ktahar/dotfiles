# ktaha's zshenv

## GOPATH
if [ -d ~/go ]; then
    export GOPATH=~/go
fi

## pyenv
export PYENV_ROOT=~/.pyenv

## PATH
typeset -U path
## dirs to put at head.
directories=($PYENV_ROOT/bin ~/gems/bin ~/opt/node/bin ~/opt/go/bin ~/.local/bin)
for dir in $directories; do
    if [ -d $dir ]; then
        path=($dir $path)
    fi
done

## dirs to put at tail.
directories=($GOPATH/bin ~/dotfiles/bin)
for dir in $directories; do
    if [ -d $dir ]; then
        path=($path $dir)
    fi
done

## CPATH
typeset -T CPATH cpath
typeset -U cpath
directories=(~/.local/include)
for dir in $directories; do
    if [ -d $dir ]; then
        cpath=($dir $cpath)
    fi
done
export CPATH

## LIBRARY_PATH and LD_LIBRARY_PATH
typeset -T LIBRARY_PATH library_path
typeset -U library_path
typeset -T LD_LIBRARY_PATH ld_library_path
typeset -U ld_library_path
directories=(~/.local/lib)
for dir in $directories; do
    if [ -d $dir ]; then
        library_path=($dir $ld_library_path)
        ld_library_path=($dir $ld_library_path)
    fi
done
export LIBRARY_PATH
export LD_LIBRARY_PATH

## PYTHONPATH
typeset -T PYTHONPATH pythonpath
typeset -U pythonpath
pythonpath=($pythonpath ~/dotfiles/py)
export PYTHONPATH
export PIPENV_VENV_IN_PROJECT=1

export EDITOR=vim

## Ruby and gem
export GEM_HOME=~/gems

## fzf
export FZF_DEFAULT_OPTS='--bind=ctrl-j:abort'
export FZF_DEFAULT_COMMAND='ag --nocolor --nogroup -g ""'
export FZF_COMPLETION_TRIGGER='~~'
