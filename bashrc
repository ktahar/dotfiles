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

export PATH=$PATH:$HOME/dotfiles/scripts
