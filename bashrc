set -o vi
bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'
bind '"\C-j": vi-movement-mode'

set -o ignoreeof

alias l='ls -Ch'
alias ll='ls -Bltrh'
alias la='ls -altrh'
alias less='less -R'
alias info='info --vi-keys'

if [ -t 0 ]; then    # stdin is opened
    stty stop undef  # unbind C-s
    stty start undef # unbind C-q
fi

# set envs just once.
# should be in ~/.profile or something. but I want to be portable.
if [ -z "${DOTFILES_ENV_SET+1}" ]; then
    export DOTFILES_ENV_SET=1
    export PATH=$PATH:$HOME/dotfiles/scripts
fi
