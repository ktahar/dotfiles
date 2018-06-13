set -o vi
bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'
bind '"\C-j": vi-movement-mode'

set -o ignoreeof

alias ll='ls -Bltr'
alias la='ls -altr'

export TERM=gnome-256color
