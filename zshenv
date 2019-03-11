# ktaha's zshenv

## GOPATH
if [ -d ~/go ]; then
    export GOPATH=~/go
fi

## PATH
typeset -U path
## dirs to put at head.
directories=(~/gems/bin /usr/local/go/bin ~/bin ~/.local/bin)
for dir in $directories; do
    if [ -d $dir ]; then
        path=($dir $path)
    fi
done

## dirs to put at tail.
directories=($GOPATH/bin ~/dotfiles/scripts ~/opt/node/bin ~/opt/matlab/bin)
for dir in $directories; do
    if [ -d $dir ]; then
        path=($path $dir)
    fi
done

## PYTHONPATH
typeset -T PYTHONPATH pythonpath
typeset -U pythonpath
pythonpath=($pythonpath ~/dotfiles/py)
export PYTHONPATH
export PIPENV_VENV_IN_PROJECT=1

export EDITOR=vim

## Ruby and gem
export GEM_HOME=$HOME/gems

# fzf
export FZF_DEFAULT_OPTS='--bind=ctrl-j:abort'
export FZF_DEFAULT_COMMAND='ag --nocolor --nogroup -g ""'
export FZF_COMPLETION_TRIGGER='~~'
