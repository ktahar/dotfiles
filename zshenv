# ktaha's zshenv

export EDITOR=vim

## PATH
typeset -U path
### put at head without existence check.
directories=(~/opt/node/bin ~/.local/bin)
for dir in $directories; do
    path=($dir $path)
done
### put at tail.
directories=(~/dotfiles/bin)
for dir in $directories; do
    if [ -d $dir ]; then
        path=($path $dir)
    fi
done

## fzf
export FZF_DEFAULT_OPTS='--bind=ctrl-j:abort'
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
export FZF_COMPLETION_TRIGGER='~~'
